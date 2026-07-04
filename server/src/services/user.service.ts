import { prisma } from '../config/database.js';

export async function updateAvatarUrl(userId: string, avatarUrl: string) {
  return await prisma.user.update({
    where: { id: userId },
    data: { avatarUrl },
    select: {
      id: true,
      avatarUrl: true,
    },
  });
}