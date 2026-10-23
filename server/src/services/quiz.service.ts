import { prisma } from '../config/database.js';

// correctIndex/explanation must never leave the server in the question list;
// answers are revealed per-question via checkQuizAnswer() only after the
// user has picked an option.
export async function getQuizQuestions(count: number = 7) {
  const allQuestions = await prisma.quizQuestion.findMany({
    select: { id: true, question: true, options: true },
  });
  // Fisher-Yates shuffle and take `count`
  for (let i = allQuestions.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [allQuestions[i], allQuestions[j]] = [allQuestions[j], allQuestions[i]];
  }
  return allQuestions.slice(0, count);
}

export async function checkQuizAnswer(questionId: string, selectedIndex: number) {
  const question = await prisma.quizQuestion.findUnique({ where: { id: questionId } });
  if (!question) return null;

  const options = Array.isArray(question.options) ? (question.options as unknown[]) : [];
  if (selectedIndex >= options.length) {
    throw Object.assign(
      new Error('Selected index is out of range for this question.'),
      { statusCode: 400, code: 'VALIDATION_ERROR' },
    );
  }

  return {
    isCorrect: selectedIndex === question.correctIndex,
    correctIndex: question.correctIndex,
    explanation: question.explanation,
  };
}

interface QuizAnswerInput {
  questionId: string;
  selectedIndex: number;
}

// Server-side grading: the client reports its answers but never its score,
// so score history cannot be inflated through the API directly.
export async function gradeAndSaveScore(userId: string, answers: QuizAnswerInput[]) {
  const uniqueIds = [...new Set(answers.map((a) => a.questionId))];
  const questions = await prisma.quizQuestion.findMany({
    where: { id: { in: uniqueIds } },
    select: { id: true, correctIndex: true },
  });
  const correctById = new Map(questions.map((q) => [q.id, q.correctIndex]));

  let score = 0;
  let total = 0;
  for (const answer of answers) {
    const correctIndex = correctById.get(answer.questionId);
    if (correctIndex === undefined) {
      throw Object.assign(
        new Error('One or more questions no longer exist. Please restart the quiz.'),
        { statusCode: 400, code: 'VALIDATION_ERROR' },
      );
    }
    total++;
    if (answer.selectedIndex === correctIndex) score++;
  }
  if (total === 0) {
    throw Object.assign(new Error('No answers were submitted.'), {
      statusCode: 400,
      code: 'VALIDATION_ERROR',
    });
  }

  return await prisma.quizScore.create({
    data: { userId, score, totalQuestions: total },
  });
}

export async function getQuizScoreHistory(userId: string) {
  return await prisma.quizScore.findMany({
    where: { userId },
    orderBy: { createdAt: 'desc' },
    take: 10
  });
}
