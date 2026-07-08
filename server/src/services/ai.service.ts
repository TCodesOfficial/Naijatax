import { prisma } from '../config/database.js';
import { env } from '../config/env.js';
import { NIGERIAN_TAX_CONTEXT } from '../config/prompts.js';

const GEMINI_API_URL = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

interface GeminiMessage {
  role: 'user' | 'model';
  parts: { text: string }[];
}

async function callGemini(
  messages: GeminiMessage[],
  systemInstruction?: string,
  options: { temperature?: number; maxOutputTokens?: number; responseMimeType?: string } = {},
  maxRetries = 1,
): Promise<string> {
  const body: Record<string, unknown> = {
    contents: messages,
    generationConfig: {
      temperature: options.temperature ?? 0.3,
      maxOutputTokens: options.maxOutputTokens ?? 1000,
      ...(options.responseMimeType ? { responseMimeType: options.responseMimeType } : {}),
    },
  };

  if (systemInstruction) {
    body.systemInstruction = { parts: [{ text: systemInstruction }] };
  }

  for (let attempt = 1; attempt <= maxRetries; attempt++) {
    try {
      const res = await fetch(GEMINI_API_URL, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'x-goog-api-key': env.GEMINI_API_KEY,
        },
        body: JSON.stringify(body),
      });

      if (!res.ok) {
        const errorBody = await res.text();
        const isRateLimited = res.status === 429;

        if (isRateLimited && attempt < maxRetries) {
          const delay = Math.pow(2, attempt) * 1000;
          await new Promise((resolve) => setTimeout(resolve, delay));
          continue;
        }

        if (isRateLimited) {
          return 'AI is busy processing other requests. Please try again in a moment.';
        }

        throw new Error(`Gemini API error ${res.status}: ${errorBody}`);
      }

      const data = await res.json() as {
        candidates?: { content?: { parts?: { text?: string }[] } }[];
      };

      const text = data.candidates?.[0]?.content?.parts?.[0]?.text;
      return text || 'I apologize, I am unable to process your request at this time.';
    } catch (error: unknown) {
      if (attempt < maxRetries) {
        const delay = Math.pow(2, attempt) * 1000;
        await new Promise((resolve) => setTimeout(resolve, delay));
        continue;
      }
      throw error;
    }
  }

  return 'I apologize, I am unable to process your request at this time.';
}

function toGeminiMessages(
  history: { role: string; content: string }[],
  currentMessage: string,
): GeminiMessage[] {
  const messages: GeminiMessage[] = [];

  for (const msg of history) {
    messages.push({
      role: msg.role === 'assistant' ? 'model' : 'user',
      parts: [{ text: msg.content }],
    });
  }

  messages.push({ role: 'user', parts: [{ text: currentMessage }] });

  return messages;
}

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
    orderBy: { createdAt: 'desc' },
    take: 5
  });
  history.reverse();

  await prisma.chatMessage.create({
    data: { sessionId: session.id, role: 'user', content }
  });

  const geminiMessages = toGeminiMessages(
    history.map((msg) => ({ role: msg.role, content: msg.content })),
    content,
  );

  const responseContent = await callGemini(geminiMessages, NIGERIAN_TAX_CONTEXT, {
    temperature: 0.3,
    maxOutputTokens: 1000,
  });

  const isBusy = responseContent.includes('busy processing') || responseContent.includes('unable to process');

  const aiMessage = await prisma.chatMessage.create({
    data: {
      sessionId: session.id,
      role: 'assistant',
      content: isBusy ? 'I apologize, the AI service is temporarily busy. Please try again in a moment.' : responseContent,
    }
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

  const jsonStr = await callGemini(
    [{ role: 'user', parts: [{ text: parsePrompt }] }],
    undefined,
    { temperature: 0.1, responseMimeType: 'application/json' },
  );
  return JSON.parse(jsonStr);
}
