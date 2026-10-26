import { prisma } from '../config/database.js';

const userSelect = {
  id: true,
  email: true,
  phone: true,
  displayName: true,
  avatarUrl: true,
  address: true,
  onboarded: true,
  role: true,
  createdAt: true,
} as const;

// The users row is normally created by a Supabase trigger on sign-up. Writes
// use upsert so a missing row (trigger not installed, older accounts) is
// created instead of failing silently, which used to lose the saved photo
// and the onboarding flag.

export async function updateAvatarUrl(userId: string, avatarUrl: string) {
  return await prisma.user.upsert({
    where: { id: userId },
    update: { avatarUrl },
    create: { id: userId, avatarUrl },
    select: {
      id: true,
      avatarUrl: true,
    },
  });
}

export async function completeOnboarding(userId: string) {
  return await prisma.user.upsert({
    where: { id: userId },
    update: { onboarded: true },
    create: { id: userId, onboarded: true },
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

export async function getUserProfile(userId: string) {
  return await prisma.user.findUnique({
    where: { id: userId },
    select: userSelect,
  });
}

interface UpdateUserProfileInput {
  displayName?: string;
  phone?: string;
  address?: string;
}

export async function updateUserProfile(userId: string, data: UpdateUserProfileInput) {
  // Upsert-safe: create the row if it somehow doesn't exist yet
  // (e.g. user signed up before this server existed).
  return await prisma.user.upsert({
    where: { id: userId },
    update: data,
    create: { id: userId, ...data },
    select: userSelect,
  });
}