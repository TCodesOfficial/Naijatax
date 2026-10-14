import { Response, Request } from 'express';
import { z } from 'zod';
import {
  updateAvatarUrl,
  completeOnboarding,
  getOnboardedStatus,
  getUserProfile,
  updateUserProfile,
} from '../services/user.service.js';
import { asyncHandler } from '../utils/asyncHandler.js';
import { successResponse, errorResponse } from '../utils/response.js';

const avatarUrlSchema = z.object({
  avatarUrl: z.string(),
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

export const getMeHandler = asyncHandler(async (req: Request, res: Response) => {
  if (!req.user) {
    return errorResponse(res, 'UNAUTHORIZED', 'Authentication required', 401);
  }
  const profile = await getUserProfile(req.user.id);
  if (!profile) {
    return errorResponse(res, 'NOT_FOUND', 'User profile not found', 404);
  }
  successResponse(res, profile);
});

const updateProfileSchema = z
  .object({
    displayName: z.string().min(1).max(120).optional(),
    phone: z.string().min(5).max(20).optional(),
    address: z.string().max(300).optional(),
  })
  .refine(
    (o) => o.displayName !== undefined || o.phone !== undefined || o.address !== undefined,
    { message: 'At least one field is required' }
  );

export const updateProfileHandler = asyncHandler(async (req: Request, res: Response) => {
  if (!req.user) {
    return errorResponse(res, 'UNAUTHORIZED', 'Authentication required', 401);
  }
  const data = updateProfileSchema.parse(req.body);
  const updated = await updateUserProfile(req.user.id, data);
  successResponse(res, updated);
});