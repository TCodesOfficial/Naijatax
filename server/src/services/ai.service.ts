import OpenAI from 'openai';
import { prisma } from '../config/database.js';
import { env } from '../config/env.js';
import { NIGERIAN_TAX_CONTEXT } from '../config/prompts.js';

const openai = new OpenAI({
  apiKey: env.GEMINI_API_KEY,
  baseURL: 'https://generativelanguage.googleapis.com/v1beta/openai/',
});

export async function getOrCreateChatSession(userId: string, sessionId?: string, title = 'New Conversation') {
  if (sessionId) {
    const session = await prisma.chatSession.findFirst({
      where: { id: sessionId, userId },
      include: { messages: { orderBy: { createdAt: 'asc' } } }
    });
    if (session) return session;
  }

  return await prisma.chatSession.create({
    data: { userId, title },
    include: { messages: true }
  });
}

export async function getSessions(userId: string) {
  return await prisma.chatSession.findMany({
    where: { userId },
    orderBy: { updatedAt: 'desc' },
  });
}

export async function getSessionDetail(sessionId: string, userId: string) {
  const session = await prisma.chatSession.findUnique({
    where: { id: sessionId },
    include: { messages: { orderBy: { createdAt: 'asc' } } },
  });

  if (!session || session.userId !== userId) return null;
  return session;
}

export async function deleteSession(sessionId: string, userId: string) {
  const session = await prisma.chatSession.findUnique({ where: { id: sessionId } });

  if (!session || session.userId !== userId) return false;

  await prisma.chatSession.delete({ where: { id: sessionId } });
  return true;
}

export async function sendChatMessage(userId: string, content: string, sessionId?: string) {
  const session = await getOrCreateChatSession(userId, sessionId, content.substring(0, 40));

  const history = await prisma.chatMessage.findMany({
    where: { sessionId: session.id },
    orderBy: { createdAt: 'asc' },
    take: 20
  });

  await prisma.chatMessage.create({
    data: { sessionId: session.id, role: 'user', content }
  });

  const messages: { role: 'system' | 'user' | 'assistant'; content: string }[] = [
    { role: 'system', content: NIGERIAN_TAX_CONTEXT },
    ...history.map((msg) => ({ role: msg.role as 'user' | 'assistant', content: msg.content })),
    { role: 'user', content }
  ];

  const completion = await openai.chat.completions.create({
    model: 'gemini-2.0-flash',
    messages,
    temperature: 0.3,
    max_tokens: 1000,
  });

  const responseContent = completion.choices[0]?.message?.content || 'I apologize, I am unable to process your request at this time.';

  const aiMessage = await prisma.chatMessage.create({
    data: { sessionId: session.id, role: 'assistant', content: responseContent }
  });

  await prisma.chatSession.update({
    where: { id: session.id },
    data: { updatedAt: new Date() }
  });

  return { sessionId: session.id, sessionTitle: session.title, message: aiMessage };
}

export async function parseStatementText(text: string) {
  const parsePrompt = `
You are an expert financial document parser. Your job is to analyze the extracted text from a user's bank statement and estimate key annual tax parameters in Nigeria.
Analyze the transactions, deposits, and transfers to extract:
1. Inferred monthly income: Average monthly salary, income deposits, or inflows.
2. Annual rent paid: Look for rent payments, housing allowance transfers, or accommodation transactions.
3. Annual pension contribution rate: Look for pension contributions or retirement fund transactions (voluntary/mandatory). Return as a decimal (e.g., 0.08 for 8%).
4. Business turnover: If the account appears to show business trading inflows, calculate the sum of business revenue.
5. Business assets: Look for capital expenditure transactions, vehicle purchases, land purchase transactions, or asset values.

Provide the response strictly as a JSON object, with the following keys. Do not include any formatting or explanation outside this JSON.
JSON keys:
- monthlyIncome: number (0 if not found)
- rentPaid: number (0 if not found)
- pensionRate: number (0 if not found, or 0.08 if pension indicators exist)
- turnover: number (0 if not found, represents business revenue)
- assets: number (0 if not found, represents business assets value)
- explanation: string (short, 2-sentence summary of what transactions were identified)

Extracted bank statement text:
--------------------
${text.substring(0, 10000)}
--------------------
`;

  const completion = await openai.chat.completions.create({
    model: 'gemini-2.0-flash',
    messages: [{ role: 'user', content: parsePrompt }],
    temperature: 0.1,
    response_format: { type: 'json_object' }
  });

  const jsonStr = completion.choices[0]?.message?.content || '{}';
  return JSON.parse(jsonStr);
}
