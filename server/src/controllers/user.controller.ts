import { Response } from 'express';
import { z } from 'zod';
import { updateAvatarUrl } from '../services/user.service.js';
import { asyncHandler } from '../utils/asyncHandler.js';
import { successResponse, errorResponse } from '../utils/response.js';
import { Request } from 'express';

const avatarUrlSchema = z.object({
  avatarUrl: z.string().url('Invalid avatar URL format'),
});

export const updateAvatar = asyncHandler(async (req: Request, res: Response) => {
  const { avatarUrl } = avatarUrlSchema.parse(req.body);
  const updatedUser = await updateAvatarUrl(req.user!.id, avatarUrl);
  successResponse(res, updatedUser);
});