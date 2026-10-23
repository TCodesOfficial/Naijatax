import { Response, Request } from 'express';
import { z } from 'zod';
import {
  getForumTopics,
  getForumTopicDetail,
  createForumTopic,
  createForumReply,
  acceptForumReply,
  voteOnTopic,
  removeTopicVote,
  ForumError,
} from '../services/forum.service.js';
import { asyncHandler } from '../utils/asyncHandler.js';
import { successResponse, errorResponse } from '../utils/response.js';

const topicSchema = z.object({
  title: z.string().trim().min(5, 'Title must be at least 5 characters long').max(150),
  content: z.string().trim().min(10, 'Content must be at least 10 characters long').max(20000),
  tags: z.array(z.string().trim().min(1).max(30)).max(5).default([]),
});

const replySchema = z.object({
  content: z.string().trim().min(2, 'Reply must be at least 2 characters long').max(5000),
});

const listQuerySchema = z.object({
  tag: z.string().max(50).optional(),
  q: z.string().max(100).optional(),
});

const voteSchema = z.object({
  direction: z.union([z.literal(1), z.literal(-1)]),
});

/** Maps typed forum failures to their HTTP envelope; returns false otherwise. */
function sendForumError(res: Response, error: unknown): boolean {
  if (error instanceof ForumError) {
    errorResponse(res, error.code, error.message, error.status);
    return true;
  }
  return false;
}

export const getTopics = asyncHandler(async (req: Request, res: Response) => {
  const { tag, q } = listQuerySchema.parse(req.query);
  const topics = await getForumTopics(tag, q?.trim() || undefined, req.user?.id);
  successResponse(res, topics);
});

export const getTopicDetail = asyncHandler(async (req: Request, res: Response) => {
  const topic = await getForumTopicDetail(req.params.id, req.user?.id);
  if (!topic) {
    return errorResponse(res, 'NOT_FOUND', 'Topic not found', 404);
  }
  successResponse(res, topic);
});

export const createTopic = asyncHandler(async (req: Request, res: Response) => {
  const { title, content, tags } = topicSchema.parse(req.body);
  const topic = await createForumTopic(req.user!.id, title, content, tags);
  successResponse(res, topic, 201);
});

export const createReply = asyncHandler(async (req: Request, res: Response) => {
  const { content } = replySchema.parse(req.body);
  try {
    const reply = await createForumReply(req.user!.id, req.params.id, content);
    successResponse(res, reply, 201);
  } catch (error) {
    if (sendForumError(res, error)) return;
    throw error;
  }
});

export const acceptReply = asyncHandler(async (req: Request, res: Response) => {
  try {
    const reply = await acceptForumReply(req.user!.id, req.params.id);
    successResponse(res, reply);
  } catch (error) {
    if (sendForumError(res, error)) return;
    throw error;
  }
});

export const voteTopic = asyncHandler(async (req: Request, res: Response) => {
  const { direction } = voteSchema.parse(req.body);
  try {
    const vote = await voteOnTopic(req.user!.id, req.params.id, direction);
    successResponse(res, vote);
  } catch (error) {
    if (sendForumError(res, error)) return;
    throw error;
  }
});

export const unvoteTopic = asyncHandler(async (req: Request, res: Response) => {
  try {
    await removeTopicVote(req.user!.id, req.params.id);
    successResponse(res, { voted: false });
  } catch (error) {
    if (sendForumError(res, error)) return;
    throw error;
  }
});
