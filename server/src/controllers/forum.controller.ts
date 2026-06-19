import { Response } from 'express';
import { z } from 'zod';
import {
  getForumTopics,
  getForumTopicDetail,
  createForumTopic,
  createForumReply,
  acceptForumReply,
} from '../services/forum.service.js';
import { asyncHandler } from '../utils/asyncHandler.js';
import { AuthenticatedRequest } from '../auth/auth.middleware.js';

const topicSchema = z.object({
  title: z.string().min(5, 'Title must be at least 5 characters long'),
  content: z.string().min(10, 'Content must be at least 10 characters long'),
  tags: z.array(z.string()).default([]),
});

const replySchema = z.object({
  content: z.string().min(2, 'Reply must be at least 2 characters long'),
});

export const getTopics = asyncHandler(async (req: AuthenticatedRequest, res: Response) => {
  const tag = req.query.tag as string | undefined;
  const topics = await getForumTopics(tag);

  res.status(200).json({
    success: true,
    data: topics,
  });
});

export const getTopicDetail = asyncHandler(async (req: AuthenticatedRequest, res: Response) => {
  const topic = await getForumTopicDetail(req.params.id);

  if (!topic) {
    return res.status(404).json({
      success: false,
      error: { code: 'NOT_FOUND', message: 'Topic not found' },
    });
  }

  res.status(200).json({
    success: true,
    data: topic,
  });
});

export const createTopic = asyncHandler(async (req: AuthenticatedRequest, res: Response) => {
  if (!req.user) {
    return res.status(401).json({
      success: false,
      error: { code: 'UNAUTHORIZED', message: 'You must log in to create topics.' },
    });
  }

  const { title, content, tags } = topicSchema.parse(req.body);
  const topic = await createForumTopic(req.user.id, title, content, tags);

  res.status(201).json({
    success: true,
    data: topic,
  });
});

export const createReply = asyncHandler(async (req: AuthenticatedRequest, res: Response) => {
  if (!req.user) {
    return res.status(401).json({
      success: false,
      error: { code: 'UNAUTHORIZED', message: 'You must log in to reply.' },
    });
  }

  const { content } = replySchema.parse(req.body);
  const reply = await createForumReply(req.user.id, req.params.id, content);

  res.status(201).json({
    success: true,
    data: reply,
  });
});

export const acceptReply = asyncHandler(async (req: AuthenticatedRequest, res: Response) => {
  if (!req.user) {
    return res.status(401).json({
      success: false,
      error: { code: 'UNAUTHORIZED', message: 'Unauthorized' },
    });
  }

  try {
    const reply = await acceptForumReply(req.user.id, req.params.id);
    res.status(200).json({
      success: true,
      data: reply,
    });
  } catch (error: any) {
    res.status(403).json({
      success: false,
      error: { code: 'FORBIDDEN', message: error.message },
    });
  }
});
