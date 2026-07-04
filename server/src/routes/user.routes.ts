import { Router } from 'express';
import { updateAvatar } from '../controllers/user.controller.js';
import { requireAuth } from '../auth/auth.middleware.js';

const router = Router();

router.patch('/avatar', requireAuth, updateAvatar);

export default router;