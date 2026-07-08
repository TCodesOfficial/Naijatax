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

export async function completeOnboarding(userId: string) {
  return await prisma.user.update({
    where: { id: userId },
    data: { onboarded: true },
    select: {
      id: true,
      onboarded: true,
    },
  });
}

export async function getOnboardedStatus(userId: string) {
  const user = await prisma.user.findUnique({
    where: { id: userId },
    select: { onboarded: true },
  });
  return user?.onboarded ?? false;
}