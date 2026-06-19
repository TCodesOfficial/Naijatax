import { prisma } from '../config/database.js';

export async function getForumTopics(tag?: string) {
  return await prisma.forumTopic.findMany({
    where: tag ? {
      tags: {
        array_contains: tag
      }
    } : undefined,
    include: {
      user: {
        select: { id: true, email: true }
      },
      _count: {
        select: { replies: true }
      }
    },
    orderBy: { createdAt: 'desc' }
  });
}

export async function getForumTopicDetail(topicId: string) {
  return await prisma.forumTopic.findUnique({
    where: { id: topicId },
    include: {
      user: {
        select: { id: true, email: true }
      },
      replies: {
        include: {
          user: {
            select: { id: true, email: true }
          }
        },
        orderBy: { createdAt: 'asc' }
      }
    }
  });
}

export async function createForumTopic(userId: string, title: string, content: string, tags: string[]) {
  return await prisma.forumTopic.create({
    data: {
      userId,
      title,
      content,
      tags
    }
  });
}

export async function createForumReply(userId: string, topicId: string, content: string) {
  return await prisma.forumReply.create({
    data: {
      userId,
      topicId,
      content
    }
  });
}

export async function acceptForumReply(userId: string, replyId: string) {
  const reply = await prisma.forumReply.findUnique({
    where: { id: replyId },
    include: { topic: true }
  });

  if (!reply) throw new Error('Reply not found');
  if (reply.topic.userId !== userId) {
    throw new Error('Unauthorized: Only the topic creator can accept this reply');
  }

  // Mark this reply as accepted
  return await prisma.forumReply.update({
    where: { id: replyId },
    data: { isAccepted: true }
  });
}
