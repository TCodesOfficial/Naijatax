import { prisma } from '../config/database.js';

export async function getQuizQuestions() {
  return await prisma.quizQuestion.findMany({
    orderBy: { id: 'asc' }
  });
}

export async function submitQuizScore(userId: string, score: number, totalQuestions: number) {
  return await prisma.quizScore.create({
    data: {
      userId,
      score,
      totalQuestions
    }
  });
}

export async function getQuizScoreHistory(userId: string) {
  return await prisma.quizScore.findMany({
    where: { userId },
    orderBy: { createdAt: 'desc' },
    take: 10
  });
}
