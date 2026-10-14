import { Router } from 'express';
import {
  updateAvatar,
  completeOnboardingHandler,
  getOnboardedStatusHandler,
  getMeHandler,
  updateProfileHandler,
} from '../controllers/user.controller.js';
import { requireAuth } from '../auth/auth.middleware.js';

const router = Router();

router.get('/me', requireAuth, getMeHandler);
router.patch('/profile', requireAuth, updateProfileHandler);
router.patch('/avatar', requireAuth, updateAvatar);
router.patch('/onboarded', requireAuth, completeOnboardingHandler);
router.get('/onboarded', requireAuth, getOnboardedStatusHandler);

export default router;