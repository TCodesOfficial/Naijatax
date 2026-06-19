import { PrismaClient } from "@prisma/client/extension";

const prisma = new PrismaClient();

async function main() {
  console.log("🌱 Starting database seeding...");

  // 1. Seed VAT Items (50+ items classified under NTA 2025 rules)
  console.log("📦 Seeding VAT items...");
  const vatItems = [
    // Zero-Rated Items (0% - Input VAT recoverable)
    {
      name: "Locally produced baby food",
      category: "Baby Products",
      status: "ZERO_RATED",
      rate: 0.0,
    },
    {
      name: "Fresh fruits and vegetables",
      category: "Agriculture & Food",
      status: "ZERO_RATED",
      rate: 0.0,
    },
    {
      name: "Locally manufactured animal feed",
      category: "Agriculture & Food",
      status: "ZERO_RATED",
      rate: 0.0,
    },
    {
      name: "Raw agricultural crops (rice, beans, maize)",
      category: "Agriculture & Food",
      status: "ZERO_RATED",
      rate: 0.0,
    },
    {
      name: "Locally produced cooking oil",
      category: "Agriculture & Food",
      status: "ZERO_RATED",
      rate: 0.0,
    },
    {
      name: "Local brown bread",
      category: "Agriculture & Food",
      status: "ZERO_RATED",
      rate: 0.0,
    },
    {
      name: "Raw fish and poultry meat",
      category: "Agriculture & Food",
      status: "ZERO_RATED",
      rate: 0.0,
    },
    {
      name: "Locally manufactured agricultural machinery",
      category: "Agriculture & Food",
      status: "ZERO_RATED",
      rate: 0.0,
    },
    {
      name: "Exported goods and merchandise",
      category: "Exports",
      status: "ZERO_RATED",
      rate: 0.0,
    },
    {
      name: "Exported services (provided to non-residents)",
      category: "Exports",
      status: "ZERO_RATED",
      rate: 0.0,
    },
    {
      name: "Educational textbooks and workbooks",
      category: "Education",
      status: "ZERO_RATED",
      rate: 0.0,
    },
    {
      name: "Scientific laboratory equipment for schools",
      category: "Education",
      status: "ZERO_RATED",
      rate: 0.0,
    },
    {
      name: "Electricity supply (residential connection)",
      category: "Energy & Power",
      status: "ZERO_RATED",
      rate: 0.0,
    },
    {
      name: "Solar panels and solar charge controllers",
      category: "Energy & Power",
      status: "ZERO_RATED",
      rate: 0.0,
    },
    {
      name: "Wind energy power generators",
      category: "Energy & Power",
      status: "ZERO_RATED",
      rate: 0.0,
    },
    {
      name: "Locally produced sanitary pads",
      category: "Hygiene & Health",
      status: "ZERO_RATED",
      rate: 0.0,
    },
    {
      name: "Locally produced toilet paper",
      category: "Hygiene & Health",
      status: "ZERO_RATED",
      rate: 0.0,
    },

    // Exempt Items (No VAT charged - Input VAT NOT recoverable)
    {
      name: "School tuition fees",
      category: "Education",
      status: "EXEMPT",
      rate: 0.0,
    },
    {
      name: "Crèche and playgroup services",
      category: "Education",
      status: "EXEMPT",
      rate: 0.0,
    },
    {
      name: "Hospital clinical consultations",
      category: "Medical Services",
      status: "EXEMPT",
      rate: 0.0,
    },
    {
      name: "Surgical operations and therapies",
      category: "Medical Services",
      status: "EXEMPT",
      rate: 0.0,
    },
    {
      name: "Prescription pharmaceuticals and drugs",
      category: "Medical Services",
      status: "EXEMPT",
      rate: 0.0,
    },
    {
      name: "Diagnostic services (X-ray, MRI, blood tests)",
      category: "Medical Services",
      status: "EXEMPT",
      rate: 0.0,
    },
    {
      name: "Dental care clinical procedures",
      category: "Medical Services",
      status: "EXEMPT",
      rate: 0.0,
    },
    {
      name: "Vaccines and immunizations",
      category: "Medical Services",
      status: "EXEMPT",
      rate: 0.0,
    },
    {
      name: "Residential apartment house rent",
      category: "Real Estate",
      status: "EXEMPT",
      rate: 0.0,
    },
    {
      name: "Purchase of land",
      category: "Real Estate",
      status: "EXEMPT",
      rate: 0.0,
    },
    {
      name: "Commercial passenger bus transport",
      category: "Transport",
      status: "EXEMPT",
      rate: 0.0,
    },
    {
      name: "Intra-city public rail passenger transport",
      category: "Transport",
      status: "EXEMPT",
      rate: 0.0,
    },
    {
      name: "Interest on bank savings accounts",
      category: "Financial Services",
      status: "EXEMPT",
      rate: 0.0,
    },
    {
      name: "Life insurance policy premiums",
      category: "Financial Services",
      status: "EXEMPT",
      rate: 0.0,
    },
    {
      name: "Agricultural crop insurance policies",
      category: "Financial Services",
      status: "EXEMPT",
      rate: 0.0,
    },
    {
      name: "Microfinance loan processing fees",
      category: "Financial Services",
      status: "EXEMPT",
      rate: 0.0,
    },
    {
      name: "Basic water supply (public taps & utilities)",
      category: "Utilities",
      status: "EXEMPT",
      rate: 0.0,
    },

    // Standard Rated Items (7.5% - Standard VAT applies)
    {
      name: "Smartphones and mobile tablets",
      category: "Electronics",
      status: "STANDARD",
      rate: 7.5,
    },
    {
      name: "Laptops and personal desktop computers",
      category: "Electronics",
      status: "STANDARD",
      rate: 7.5,
    },
    {
      name: "Television sets and home audio consoles",
      category: "Electronics",
      status: "STANDARD",
      rate: 7.5,
    },
    {
      name: "Imported canned foods and snacks",
      category: "Agriculture & Food",
      status: "STANDARD",
      rate: 7.5,
    },
    {
      name: "Bottled carbonated soda beverages",
      category: "Agriculture & Food",
      status: "STANDARD",
      rate: 7.5,
    },
    {
      name: "Imported clothing and designer footwear",
      category: "Apparel",
      status: "STANDARD",
      rate: 7.5,
    },
    {
      name: "Cosmetic perfumes and makeup accessories",
      category: "Beauty & Personal Care",
      status: "STANDARD",
      rate: 7.5,
    },
    {
      name: "Automobile passenger cars (imported)",
      category: "Transport",
      status: "STANDARD",
      rate: 7.5,
    },
    {
      name: "Legal consultation fees (commercial)",
      category: "Professional Services",
      status: "STANDARD",
      rate: 7.5,
    },
    {
      name: "Financial auditing and accounting services",
      category: "Professional Services",
      status: "STANDARD",
      rate: 7.5,
    },
    {
      name: "Software engineering development services",
      category: "Professional Services",
      status: "STANDARD",
      rate: 7.5,
    },
    {
      name: "Restaurant prepared meals and dining",
      category: "Hospitality",
      status: "STANDARD",
      rate: 7.5,
    },
    {
      name: "Hotel lodging and accommodation",
      category: "Hospitality",
      status: "STANDARD",
      rate: 7.5,
    },
    {
      name: "Cinema ticket purchases",
      category: "Entertainment",
      status: "STANDARD",
      rate: 7.5,
    },
    {
      name: "Telecom mobile call plans and airtime",
      category: "Telecommunications",
      status: "STANDARD",
      rate: 7.5,
    },
    {
      name: "Internet data plans and broadband bills",
      category: "Telecommunications",
      status: "STANDARD",
      rate: 7.5,
    },
    {
      name: "Gym memberships and fitness trainers",
      category: "Health & Wellness",
      status: "STANDARD",
      rate: 7.5,
    },
    {
      name: "Commercial office building rent",
      category: "Real Estate",
      status: "STANDARD",
      rate: 7.5,
    },
  ];

  for (const item of vatItems) {
    await prisma.vatItem.upsert({
      where: { name: item.name },
      update: { category: item.category, status: item.status, rate: item.rate },
      create: item,
    });
  }
  console.log(`✅ Seeded ${vatItems.length} VAT items.`);

  // 2. Seed Quiz Questions
  console.log("❓ Seeding Quiz questions...");
  const quizQuestions = [
    {
      question:
        "Under the 2025 Nigeria Tax Act, what is the annual income threshold below which individuals are completely exempt from PAYE tax?",
      options: ["₦300,000", "₦500,000", "₦800,000", "₦1,200,000"],
      correctIndex: 2,
      explanation:
        "The 2025 reforms raise the minimum annual income tax threshold to ₦800,000, completely exempting low-income earners earning minimum wage (₦70,000 monthly) from paying PAYE tax.",
    },
    {
      question:
        "Which of the following federal agencies replaces the Federal Inland Revenue Service (FIRS) under the new reforms?",
      options: [
        "Joint Tax Board (JTB)",
        "Nigeria Revenue Service (NRS)",
        "Federal Tax Commission (FTC)",
        "National Revenue Administration (NRA)",
      ],
      correctIndex: 1,
      explanation:
        "The Nigeria Revenue Service (NRS) has been established to replace the former FIRS, serving as the modernized single collector for all federal revenues.",
    },
    {
      question:
        "Small businesses are completely exempt from Company Income Tax (CIT). What is the maximum annual turnover limit to qualify as a small business?",
      options: ["₦25 million", "₦50 million", "₦100 million", "₦250 million"],
      correctIndex: 2,
      explanation:
        "Companies with an annual turnover not exceeding ₦100 million and fixed assets under ₦250 million are completely exempt from paying Company Income Tax (CIT).",
    },
    {
      question:
        "What is the current standard Value Added Tax (VAT) rate in Nigeria?",
      options: ["5.0%", "7.5%", "10.0%", "15.0%"],
      correctIndex: 1,
      explanation:
        "The standard VAT rate on standard-rated goods and services in Nigeria remains at 7.5%, while specific commodities are zero-rated or exempt.",
    },
    {
      question:
        "What is the mandatory employee pension contribution rate deducted from gross salary under Nigerian law?",
      options: ["5%", "8%", "10%", "12%"],
      correctIndex: 1,
      explanation:
        "Under the Pension Reform Act, the mandatory minimum employee contribution rate is 8% of gross monthly salary, which is fully tax-deductible.",
    },
  ];

  for (const q of quizQuestions) {
    await prisma.quizQuestion.create({
      data: {
        question: q.question,
        options: q.options,
        correctIndex: q.correctIndex,
        explanation: q.explanation,
      },
    });
  }
  console.log(`✅ Seeded ${quizQuestions.length} quiz questions.`);

  // 3. Seed Core Educational Articles
  console.log("📚 Seeding educational articles...");
  const articles = [
    {
      title: "Introduction to the 2025 Nigeria Tax Act reforms",
      summary:
        "An overview of the landmark reforms restructuring Nigeria's tax brackets, exemptions, and collection agency.",
      content:
        "Effective January 1, 2026, the 2025 Nigeria Tax Act (NTA) fundamentally restructures the nation's fiscal framework. Signed into law by President Bola Ahmed Tinubu in June 2025, the new reforms target three main goals: relief for low-income earners, administrative efficiency, and simplified business compliance. Key highlights include the transition of the FIRS into the Nigeria Revenue Service (NRS), the raising of the personal income tax threshold to ₦800,000 annually, and tax exemptions for small businesses with annual turnovers of less than ₦100 million.",
      source: "NRS Gazette",
      isFeatured: true,
    },
    {
      title:
        "Understanding PAYE (Pay-As-You-Earn) calculations under the new bands",
      summary:
        "Learn how to calculate your personal income tax using the progressive annual brackets and mandatory deductions.",
      content:
        "Under the new 2025 progressive tax bands, personal income tax is calculated annually. The system applies progressive tax brackets: the first ₦800,000 is exempt (0% rate). The subsequent ₦3,000,000 is taxed at 15%. The next ₦3,000,000 is taxed at 20%, the next ₦14,000,000 is taxed at 22%, and any income exceeding ₦20,800,000 annually is taxed at the top rate of 25%. Deductions include a mandatory 8% employee pension contribution and rent reliefs (20% of rent paid, capped at ₦500,000 per year). Taxable Income = Gross Income - Pension - Rent Relief.",
      source: "KPMG Advisory",
      isFeatured: false,
    },
    {
      title:
        "Company Income Tax (CIT) exemptions for small and micro businesses",
      summary:
        "How the ₦100 million turnover and ₦250 million asset limits protect small enterprises from taxation.",
      content:
        "To foster economic growth, the 2025 NTA reforms provide complete tax relief to micro and small businesses. Companies whose annual turnover does not exceed ₦100 million and whose total net book value of fixed assets does not exceed ₦250 million are completely exempt from paying Company Income Tax (CIT). Medium companies (turnover between ₦100 million and ₦500 million) pay a reduced rate of 20%, while large companies (turnover exceeding ₦500 million) pay the standard 30% rate. This exemption covers over 90% of registered SMEs in Nigeria.",
      source: "PwC Nigeria Report",
      isFeatured: false,
    },
  ];

  for (const article of articles) {
    await prisma.taxArticle.create({ data: article });
  }
  console.log(`✅ Seeded ${articles.length} educational articles.`);

  console.log("🎉 Database seeding complete!");
}

main()
  .catch((e) => {
    console.error("❌ Error during seeding:", e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
