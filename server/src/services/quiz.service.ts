import { prisma } from '../config/database.js';

export async function getQuizQuestions(count: number = 7) {
  const allQuestions = await prisma.quizQuestion.findMany();
  // Fisher-Yates shuffle and take `count`
  for (let i = allQuestions.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [allQuestions[i], allQuestions[j]] = [allQuestions[j], allQuestions[i]];
  }
  return allQuestions.slice(0, count);
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
