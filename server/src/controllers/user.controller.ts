import { Response, Request } from 'express';
import { z } from 'zod';
import { updateAvatarUrl, completeOnboarding, getOnboardedStatus } from '../services/user.service.js';
import { asyncHandler } from '../utils/asyncHandler.js';
import { successResponse, errorResponse } from '../utils/response.js';

const avatarUrlSchema = z.object({
  avatarUrl: z.string().url('Invalid avatar URL format'),
});

export const updateAvatar = asyncHandler(async (req: Request, res: Response) => {
  const { avatarUrl } = avatarUrlSchema.parse(req.body);
  const updatedUser = await updateAvatarUrl(req.user!.id, avatarUrl);
  successResponse(res, updatedUser);
});

export const completeOnboardingHandler = asyncHandler(async (req: Request, res: Response) => {
  if (!req.user) {
    return errorResponse(res, 'UNAUTHORIZED', 'Authentication required', 401);
  }
  const result = await completeOnboarding(req.user.id);
  successResponse(res, result);
});

export const getOnboardedStatusHandler = asyncHandler(async (req: Request, res: Response) => {
  if (!req.user) {
    return errorResponse(res, 'UNAUTHORIZED', 'Authentication required', 401);
  }
  const onboarded = await getOnboardedStatus(req.user.id);
  successResponse(res, { onboarded });
});