import { Router } from 'express';
import {
  getTopics,
  getTopicDetail,
  createTopic,
  createReply,
  acceptReply,
  voteTopic,
  unvoteTopic,
} from '../controllers/forum.controller.js';
import { requireAuth, optionalAuth } from '../auth/auth.middleware.js';

const router = Router();

// Guest-accessible: Browse all topics (read-only)
router.get('/', optionalAuth, getTopics);
router.get('/:id', optionalAuth, getTopicDetail);

// Auth-required: Create and interact with topics
router.post('/', requireAuth, createTopic);
router.post('/:id/replies', requireAuth, createReply);
router.post('/:id/votes', requireAuth, voteTopic);
router.delete('/:id/votes', requireAuth, unvoteTopic);
router.patch('/replies/:id/accept', requireAuth, acceptReply);

export default router;
