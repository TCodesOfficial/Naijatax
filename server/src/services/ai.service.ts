import { GoogleGenAI } from '@google/genai';
import { prisma } from '../config/database.js';
import { env } from '../config/env.js';
import { NIGERIAN_TAX_CONTEXT } from '../config/prompts.js';

// 1. Initialize the official Google Gen AI client with your AI Studio Key
const ai = new GoogleGenAI({ apiKey: env.GEMINI_API_KEY });

// Using the standard stable production model identifier
const MODEL_NAME = 'gemini-3.8-flash';

interface GeminiMessage {
  role: 'user' | 'model';
  parts: { text: string }[];
}

async function callGemini(
  messages: GeminiMessage[],
  systemInstruction?: string,
  options: { temperature?: number; maxOutputTokens?: number; responseMimeType?: string } = {},
  maxRetries = 2,
): Promise<string> {
  for (let attempt = 1; attempt <= maxRetries; attempt++) {
    try {
      // Hard server-side guard: never let the Gemini call hang past ~17s
      // so we always respond before the client's 20s receive timeout.
      const geminiPromise = ai.models.generateContent({
        model: MODEL_NAME,
        contents: messages,
        config: {
          temperature: options.temperature ?? 0.3,
          maxOutputTokens: options.maxOutputTokens ?? 1024,
          systemInstruction: systemInstruction,
          responseMimeType: options.responseMimeType,
        },
      });
      const timeoutPromise = new Promise((_, reject) =>
        setTimeout(() => reject(new Error('GEMINI_TIMEOUT_17S')), 17_000),
      );
      const response = (await Promise.race([geminiPromise, timeoutPromise])) as Awaited<
        ReturnType<typeof ai.models.generateContent>
      >;

      return response.text || 'I apologize, I am unable to process your request at this time.';
    } catch (error: any) {
      console.error('🔴 RAW GEMINI AI API ERROR:', error);

      if (error?.message === 'GEMINI_TIMEOUT_17S') {
        return 'The AI took too long to respond. Please try again.';
      }

      // Gracefully catch standard transient rate limits (429) or busy server flags (503)
      const status = error?.status || error?.statusCode;
      const isTransient = status === 429 || status === 503 || error?.message?.includes('429');

      if (isTransient && attempt < maxRetries) {
        const delay = Math.pow(2, attempt) * 1000;
        await new Promise((resolve) => setTimeout(resolve, delay));
        continue;
      }

      if (isTransient) {
        return 'AI is busy processing other requests. Please try again in a moment.';
      }

      throw error;
    }
  }

  return 'I apologize, I am unable to process your request at this time.';
}

/**
 * Sanitizes and prepares history objects ensuring strict alternating user -> model roles
 */
function toGeminiMessages(
  history: { role: string; content: string }[],
  currentMessage: string,
): GeminiMessage[] {
  const messages: GeminiMessage[] = [];

  for (const msg of history) {
    const role = msg.role === 'assistant' ? 'model' : 'user';

    // Prevent consecutive identical roles from throwing an API validation exception
    if (messages.length > 0 && messages[messages.length - 1].role === role) {
      messages[messages.length - 1].parts[0].text += `\n${msg.content}`;
    } else {
      messages.push({
        role,
        parts: [{ text: msg.content }],
      });
    }
  }

  // Double check user constraint sequencing right before adding the active prompt
  if (messages.length > 0 && messages[messages.length - 1].role === 'user') {
    messages[messages.length - 1].parts[0].text += `\n${currentMessage}`;
  } else {
    messages.push({ role: 'user', parts: [{ text: currentMessage }] });
  }

  return messages;
}

/* ==========================================
   Prisma Chat Session Persistent Layer Data Methods
   ========================================== */

export async function getOrCreateChatSession(userId: string, sessionId?: string, title = 'New Conversation') {
  if (sessionId) {
    // Only fetch the session shell — messages are fetched separately with a
    // capped take, so including them here wasted a large DB transfer.
    const session = await prisma.chatSession.findFirst({
      where: { id: sessionId, userId },
      select: { id: true, userId: true, title: true, createdAt: true, updatedAt: true },
    });
    if (session) return session;
  }

  return await prisma.chatSession.create({
    data: { userId, title },
    select: { id: true, userId: true, title: true, createdAt: true, updatedAt: true },
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
  const t0 = Date.now();

  const session = await getOrCreateChatSession(userId, sessionId, content.substring(0, 40));
  const tSession = Date.now();

  // Fetch the last 10 messages (enough context, light payload) and save the
  // user's message in parallel — both only need the session id.
  const [history, _userMsg] = await Promise.all([
    prisma.chatMessage.findMany({
      where: { sessionId: session.id },
      orderBy: { createdAt: 'desc' },
      take: 10,
    }),
    prisma.chatMessage.create({
      data: { sessionId: session.id, role: 'user', content },
    }),
  ]);
  history.reverse();
  const tHistory = Date.now();

  const geminiMessages = toGeminiMessages(
    history.map((msg) => ({ role: msg.role, content: msg.content })),
    content,
  );

  const responseContent = await callGemini(geminiMessages, NIGERIAN_TAX_CONTEXT, {
    temperature: 0.3,
    maxOutputTokens: 1024,
  });
  const tGemini = Date.now();

  const isBusy = responseContent.includes('busy processing') || responseContent.includes('unable to process');

  const aiMessage = await prisma.chatMessage.create({
    data: {
      sessionId: session.id,
      role: 'assistant',
      content: isBusy ? 'I apologize, the AI service is temporarily busy. Please try again in a moment.' : responseContent,
    }
  });

  // Fire-and-forget: session ordering touch shouldn't block the user's reply.
  prisma.chatSession
    .update({ where: { id: session.id }, data: { updatedAt: new Date() } })
    .catch(() => {});

  const t1 = Date.now();
  console.log(
    `[AI] session: ${tSession - t0}ms | history+saveUser: ${tHistory - tSession}ms | ` +
    `GEMINI: ${tGemini - tHistory}ms | saveReply: ${t1 - tGemini}ms | TOTAL: ${t1 - t0}ms`,
  );

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
  
  try {
    return JSON.parse(jsonStr);
  } catch {
    throw new Error('AI returned an invalid response. Please try again.');
  }
}