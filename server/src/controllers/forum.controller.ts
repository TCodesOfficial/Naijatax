import { Response, Request } from 'express';
import { z } from 'zod';
import {
  getForumTopics,
  getForumTopicDetail,
  createForumTopic,
  createForumReply,
  acceptForumReply,
} from '../services/forum.service.js';
import { asyncHandler } from '../utils/asyncHandler.js';
import { successResponse, errorResponse } from '../utils/response.js';

const topicSchema = z.object({
  title: z.string().min(5, 'Title must be at least 5 characters long'),
  content: z.string().min(10, 'Content must be at least 10 characters long'),
  tags: z.array(z.string()).default([]),
});

const replySchema = z.object({
  content: z.string().min(2, 'Reply must be at least 2 characters long'),
});

export const getTopics = asyncHandler(async (req: Request, res: Response) => {
  const tag = req.query.tag as string | undefined;
  const topics = await getForumTopics(tag);
  successResponse(res, topics);
});

export const getTopicDetail = asyncHandler(async (req: Request, res: Response) => {
  const topic = await getForumTopicDetail(req.params.id);
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
  const reply = await createForumReply(req.user!.id, req.params.id, content);
  successResponse(res, reply, 201);
});

export const acceptReply = asyncHandler(async (req: Request, res: Response) => {
  try {
    const reply = await acceptForumReply(req.user!.id, req.params.id);
    successResponse(res, reply);
  } catch (error: any) {
    errorResponse(res, 'FORBIDDEN', error.message, 403);
  }
});
