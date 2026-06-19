import OpenAI from 'openai';
import { prisma } from '../config/database.js';
import { env } from '../config/env.js';

const openai = new OpenAI({
  apiKey: env.OPENAI_API_KEY,
});

// Detailed system prompt containing NTA 2025 knowledge base
const NIGERIAN_TAX_CONTEXT = `
You are the NaijaTax Enlighten AI Assistant, a specialized expert on Nigerian taxation, specifically trained on the 2025 Nigeria Tax Act (NTA) reforms. Your purpose is to educate citizens, answer tax-related questions factually, and provide helpful guidance in a friendly, conversational manner.

Key Nigerian Tax Knowledge for the 2025 reforms:
1. Personal Income Tax (PAYE):
   - Exemption Threshold: Anyone earning ₦800,000 or less annually is completely exempt from PAYE.
   - Progressive Annual Tax Bands:
     - Up to ₦800,000: 0% (Exempt)
     - Next ₦3,000,000 (from ₦800,001 to ₦3,800,000): 15%
     - Next ₦3,000,000 (from ₦3,800,001 to ₦6,800,000): 20%
     - Next ₦14,000,000 (from ₦6,800,001 to ₦20,800,000): 22%
     - Above ₦20,800,000: 25%
   - Deductions: Mandatory pension (default 8% of gross salary) and rent relief (20% of rent paid, capped at ₦500,000 per year) are tax-deductible.
   - Minimum Wage: Set at ₦70,000 monthly (₦840,000 annually), meaning standard minimum wage earners are mostly exempt or pay negligible tax.

2. Company Income Tax (CIT):
   - Small Businesses (Turnover <= ₦100 million AND assets <= ₦250 million) are 100% exempt from CIT.
   - Medium Businesses (Turnover ₦100 million to ₦500 million) pay 20% CIT.
   - Large Businesses (Turnover > ₦500 million) pay 30% CIT.

3. Value Added Tax (VAT) categories (Standard Rate: 7.5%):
   - Zero-Rated (0% VAT): Basic local food items, local bread, fresh produce, locally manufactured animal feeds, solar panels, exported goods/services, residential electricity, and educational textbooks.
   - Exempt: Commercial passenger public transport, school tuition fees, residential housing rent, commercial land purchase, medical consultations, surgical operations, prescription drugs, and savings account interest.
   - Standard (7.5% VAT): Laptops, smartphones, imported clothing, hotel lodging, restaurants, data plans, airtime, cars, legal fees.

4. Administrative Changes:
   - The Nigeria Revenue Service (NRS) replaces the Federal Inland Revenue Service (FIRS) as the single tax collector.

Instructions:
- Address users politely. Use Nigerian currency (Naira ₦) for all values.
- Keep answers factual. If you do not know the answer, do not make up tax details. Politely refer them to a tax practitioner.
- Remind users that your advice is for educational purposes and does not constitute official legal advice.
`;

export async function getOrCreateChatSession(userId: string, sessionId?: string, title = 'New Conversation') {
  if (sessionId) {
    const session = await prisma.chatSession.findFirst({
      where: { id: sessionId, userId },
      include: { messages: { orderBy: { createdAt: 'asc' } } }
    });
    if (session) return session;
  }

  // Create a new session
  return await prisma.chatSession.create({
    data: {
      userId,
      title,
    },
    include: { messages: true }
  });
}

export async function sendChatMessage(userId: string, content: string, sessionId?: string) {
  // 1. Fetch or create chat session
  const session = await getOrCreateChatSession(userId, sessionId, content.substring(0, 40));
  
  // 2. Fetch last 20 messages in this session
  const history = await prisma.chatMessage.findMany({
    where: { sessionId: session.id },
    orderBy: { createdAt: 'asc' },
    take: 20
  });

  // 3. Save User Message
  await prisma.chatMessage.create({
    data: {
      sessionId: session.id,
      role: 'user',
      content
    }
  });

  // 4. Format prompt messages for OpenAI
  const messages:{
    role: 'system' | 'user' | 'assistant';
    content: string;
  }[] = [
    { role: 'system', content: NIGERIAN_TAX_CONTEXT },
    ...history.map((msg: { role: any; content: any; }) => ({ role: msg.role, content: msg.content })),
    { role: 'user', content }
  ];

  // 5. Query OpenAI
  const completion = await openai.chat.completions.create({
    model: 'gpt-4o-mini',
    messages,
    temperature: 0.3, // keeps the model factual
    max_tokens: 1000,
  });

  const responseContent = completion.choices[0]?.message?.content || 'I apologize, I am unable to process your request at this time.';

  // 6. Save AI Response
  const aiMessage = await prisma.chatMessage.create({
    data: {
      sessionId: session.id,
      role: 'assistant',
      content: responseContent
    }
  });

  // 7. Update Session timestamp
  await prisma.chatSession.update({
    where: { id: session.id },
    data: { updatedAt: new Date() }
  });

  return {
    sessionId: session.id,
    sessionTitle: session.title,
    message: aiMessage
  };
}

export async function parseStatementText(text: string) {
  const parsePrompt = `
You are an expert financial document parser. Your job is to analyze the extracted text from a user's bank statement and estimate key annual tax parameters in Nigeria.
Analyze the transactions, deposits, and transfers to extract:
1. Inferred monthly income: Average monthly salary, income deposits, or inflows.
2. Annual rent paid: Look for rent payments, housing allowance transfers, or accommodation transactions.
3. Annual pension paid: Look for pension contributions or retirement fund transactions (voluntary/mandatory).
4. Business turnover: If the account appears to show business trading inflows, calculate the sum of business revenue.
5. Business assets: Look for capital expenditure transactions, vehicle purchases, land purchase transactions, or asset values.

Provide the response strictly as a JSON object, with the following keys. Do not include any formatting or explanation outside this JSON.
JSON keys:
- monthlyIncome: number (0 if not found)
- rentPaid: number (0 if not found)
- pensionPaid: number (0 if not found, or calculate 8% of income if pension indicators exist)
- turnover: number (0 if not found, represents business revenue)
- assets: number (0 if not found, represents business assets value)
- explanation: string (short, 2-sentence summary of what transactions were identified)

Extracted bank statement text:
--------------------
${text.substring(0, 10000)}
--------------------
`;

  const completion = await openai.chat.completions.create({
    model: 'gpt-4o-mini',
    messages: [{ role: 'user', content: parsePrompt }],
    temperature: 0.1, // low temperature for precise parsing
    response_format: { type: 'json_object' }
  });

  const jsonStr = completion.choices[0]?.message?.content || '{}';
  return JSON.parse(jsonStr);
}
