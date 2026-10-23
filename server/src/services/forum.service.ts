import { prisma } from '../config/database.js';
import type { Prisma } from '@prisma/client';

// Public-safe author fields — never expose emails on forum endpoints.
const USER_SELECT = { id: true, displayName: true, avatarUrl: true } as const;

const MAX_TOPICS = 50;
const MAX_REPLIES = 50;
const NO_USER = '__none__';

/** Typed forum failure carrying an HTTP status + envelope code. */
export class ForumError extends Error {
  constructor(
    message: string,
    readonly status: number,
    readonly code: string,
  ) {
    super(message);
    this.name = 'ForumError';
  }
}

function votesSelect(userId?: string) {
  return {
    where: { userId: userId ?? NO_USER },
    select: { direction: true },
    take: 1,
  };
}

function withMyVote<T extends { votes?: { direction: number }[] }>(topic: T) {
  const { votes, ...rest } = topic;
  return { ...rest, myVote: votes?.[0]?.direction ?? null };
}

export async function getForumTopics(tag?: string, q?: string, userId?: string) {
  const and: Prisma.ForumTopicWhereInput[] = [];
  if (tag) and.push({ tags: { array_contains: tag } });
  if (q) {
    const contains = { contains: q, mode: 'insensitive' as const };
    and.push({ OR: [{ title: contains }, { content: contains }] });
  }

  const topics = await prisma.forumTopic.findMany({
    where: and.length > 0 ? { AND: and } : undefined,
    include: {
      user: { select: USER_SELECT },
      _count: { select: { replies: true } },
      votes: votesSelect(userId),
    },
    orderBy: { createdAt: 'desc' },
    take: MAX_TOPICS,
  });
  return topics.map(withMyVote);
}

export async function getForumTopicDetail(topicId: string, userId?: string) {
  const topic = await prisma.forumTopic.findUnique({
    where: { id: topicId },
    include: {
      user: { select: USER_SELECT },
      _count: { select: { replies: true } },
      votes: votesSelect(userId),
      replies: {
        include: { user: { select: USER_SELECT } },
        orderBy: { createdAt: 'asc' },
        take: MAX_REPLIES,
      },
    },
  });
  return topic ? withMyVote(topic) : null;
}

export async function createForumTopic(userId: string, title: string, content: string, tags: string[]) {
  return await prisma.forumTopic.create({
    data: { userId, title, content, tags },
  });
}

export async function createForumReply(userId: string, topicId: string, content: string) {
  const topic = await prisma.forumTopic.findUnique({
    where: { id: topicId },
    select: { id: true },
  });
  if (!topic) throw new ForumError('Topic not found', 404, 'NOT_FOUND');

  return await prisma.forumReply.create({
    data: { userId, topicId, content },
  });
}

export async function acceptForumReply(userId: string, replyId: string) {
  return await prisma.$transaction(async (tx) => {
    const reply = await tx.forumReply.findUnique({
      where: { id: replyId },
      include: { topic: { select: { id: true, userId: true } } },
    });

    if (!reply) throw new ForumError('Reply not found', 404, 'NOT_FOUND');
    if (reply.topic.userId !== userId) {
      throw new ForumError(
        'Only the topic creator can accept this reply',
        403,
        'FORBIDDEN',
      );
    }

    // One accepted answer per topic: clear siblings, then accept this one.
    await tx.forumReply.updateMany({
      where: { topicId: reply.topicId, isAccepted: true, id: { not: replyId } },
      data: { isAccepted: false },
    });
    return await tx.forumReply.update({
      where: { id: replyId },
      data: { isAccepted: true },
    });
  });
}

/**
 * Casts/replaces a vote on a topic (1 or -1) and keeps the topic's
 * upVotes/downVotes counters in sync inside the same transaction.
 */
export async function voteOnTopic(userId: string, topicId: string, direction: 1 | -1) {
  const topic = await prisma.forumTopic.findUnique({
    where: { id: topicId },
    select: { id: true },
  });
  if (!topic) throw new ForumError('Topic not found', 404, 'NOT_FOUND');

  return await prisma.$transaction(async (tx) => {
    const key = { topicId_userId: { topicId, userId } };
    const existing = await tx.forumVote.findUnique({ where: key });

    let upDelta = 0;
    let downDelta = 0;
    if (!existing) {
      if (direction === 1) upDelta = 1;
      else downDelta = 1;
    } else if (existing.direction !== direction) {
      // Switching sides: -1 → 1 or 1 → -1.
      upDelta = direction === 1 ? 1 : -1;
      downDelta = direction === -1 ? 1 : -1;
    }

    const vote = await tx.forumVote.upsert({
      where: { topicId_userId: { topicId, userId } },
      create: { topicId, userId, direction },
      update: { direction },
    });

    if (upDelta !== 0 || downDelta !== 0) {
      await tx.forumTopic.update({
        where: { id: topicId },
        data: { upVotes: { increment: upDelta }, downVotes: { increment: downDelta } },
      });
    }

    return { ...vote, upVotesDelta: upDelta, downVotesDelta: downDelta };
  });
}

/** Removes the user's vote and decrements the matching counter. */
export async function removeTopicVote(userId: string, topicId: string) {
  return await prisma.$transaction(async (tx) => {
    const key = { topicId_userId: { topicId, userId } };
    const existing = await tx.forumVote.findUnique({ where: key });
    if (!existing) return false;

    await tx.forumVote.delete({ where: { id: existing.id } });
    await tx.forumTopic.update({
      where: { id: topicId },
      data: {
        upVotes: { increment: existing.direction === 1 ? -1 : 0 },
        downVotes: { increment: existing.direction === -1 ? -1 : 0 },
      },
    });
    return true;
  });
}
