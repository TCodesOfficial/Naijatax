import { PrismaPg } from '@prisma/adapter-pg';
import { PrismaClient } from "@prisma/client";
import "dotenv/config";

const adapter = new PrismaPg({ connectionString: process.env.DIRECT_URL! });
const prisma = new PrismaClient({ adapter });

async function main() {
  console.log("🌱 Starting database seeding...");

  // 1. Seed VAT Items (~100 items classified under NTA 2025 rules)
  console.log("📦 Seeding VAT items...");
  const vatItems = [
    // ─── Zero-Rated Items (0% - Input VAT recoverable) ──────────────────────
    { name: "Locally produced baby food", category: "Baby Products", status: "ZERO_RATED", rate: 0.0 },
    { name: "Fresh fruits and vegetables", category: "Agriculture & Food", status: "ZERO_RATED", rate: 0.0 },
    { name: "Locally manufactured animal feed", category: "Agriculture & Food", status: "ZERO_RATED", rate: 0.0 },
    { name: "Raw agricultural crops (rice, beans, maize)", category: "Agriculture & Food", status: "ZERO_RATED", rate: 0.0 },
    { name: "Locally produced cooking oil", category: "Agriculture & Food", status: "ZERO_RATED", rate: 0.0 },
    { name: "Local brown bread", category: "Agriculture & Food", status: "ZERO_RATED", rate: 0.0 },
    { name: "Raw fish and poultry meat", category: "Agriculture & Food", status: "ZERO_RATED", rate: 0.0 },
    { name: "Locally manufactured agricultural machinery", category: "Agriculture & Food", status: "ZERO_RATED", rate: 0.0 },
    { name: "Exported goods and merchandise", category: "Exports", status: "ZERO_RATED", rate: 0.0 },
    { name: "Exported services (provided to non-residents)", category: "Exports", status: "ZERO_RATED", rate: 0.0 },
    { name: "Educational textbooks and workbooks", category: "Education", status: "ZERO_RATED", rate: 0.0 },
    { name: "Scientific laboratory equipment for schools", category: "Education", status: "ZERO_RATED", rate: 0.0 },
    { name: "Electricity supply (residential connection)", category: "Energy & Power", status: "ZERO_RATED", rate: 0.0 },
    { name: "Solar panels and solar charge controllers", category: "Energy & Power", status: "ZERO_RATED", rate: 0.0 },
    { name: "Wind energy power generators", category: "Energy & Power", status: "ZERO_RATED", rate: 0.0 },
    { name: "Locally produced sanitary pads", category: "Hygiene & Health", status: "ZERO_RATED", rate: 0.0 },
    { name: "Locally produced toilet paper", category: "Hygiene & Health", status: "ZERO_RATED", rate: 0.0 },
    { name: "Locally packaged table water (sachet/bottle)", category: "Agriculture & Food", status: "ZERO_RATED", rate: 0.0 },
    { name: "Unprocessed cassava, yam, and plantain", category: "Agriculture & Food", status: "ZERO_RATED", rate: 0.0 },
    { name: "Locally produced insecticide-treated mosquito nets", category: "Hygiene & Health", status: "ZERO_RATED", rate: 0.0 },
    { name: "Fertilizers and crop protection chemicals", category: "Agriculture & Food", status: "ZERO_RATED", rate: 0.0 },
    { name: "Educational computers and tablets for schools", category: "Education", status: "ZERO_RATED", rate: 0.0 },
    { name: "Locally produced soap and detergent", category: "Hygiene & Health", status: "ZERO_RATED", rate: 0.0 },
    { name: "Electric vehicles (locally assembled)", category: "Energy & Power", status: "ZERO_RATED", rate: 0.0 },

    // ─── Exempt Items (No VAT charged - Input VAT NOT recoverable) ──────────
    { name: "School tuition fees", category: "Education", status: "EXEMPT", rate: 0.0 },
    { name: "Crèche and playgroup services", category: "Education", status: "EXEMPT", rate: 0.0 },
    { name: "Hospital clinical consultations", category: "Medical Services", status: "EXEMPT", rate: 0.0 },
    { name: "Surgical operations and therapies", category: "Medical Services", status: "EXEMPT", rate: 0.0 },
    { name: "Prescription pharmaceuticals and drugs", category: "Medical Services", status: "EXEMPT", rate: 0.0 },
    { name: "Diagnostic services (X-ray, MRI, blood tests)", category: "Medical Services", status: "EXEMPT", rate: 0.0 },
    { name: "Dental care clinical procedures", category: "Medical Services", status: "EXEMPT", rate: 0.0 },
    { name: "Vaccines and immunizations", category: "Medical Services", status: "EXEMPT", rate: 0.0 },
    { name: "Residential apartment house rent", category: "Real Estate", status: "EXEMPT", rate: 0.0 },
    { name: "Purchase of land", category: "Real Estate", status: "EXEMPT", rate: 0.0 },
    { name: "Commercial passenger bus transport", category: "Transport", status: "EXEMPT", rate: 0.0 },
    { name: "Intra-city public rail passenger transport", category: "Transport", status: "EXEMPT", rate: 0.0 },
    { name: "Interest on bank savings accounts", category: "Financial Services", status: "EXEMPT", rate: 0.0 },
    { name: "Life insurance policy premiums", category: "Financial Services", status: "EXEMPT", rate: 0.0 },
    { name: "Agricultural crop insurance policies", category: "Financial Services", status: "EXEMPT", rate: 0.0 },
    { name: "Microfinance loan processing fees", category: "Financial Services", status: "EXEMPT", rate: 0.0 },
    { name: "Basic water supply (public taps & utilities)", category: "Utilities", status: "EXEMPT", rate: 0.0 },
    { name: "Medical laboratory test results", category: "Medical Services", status: "EXEMPT", rate: 0.0 },
    { name: "Optical eye care and prescription glasses", category: "Medical Services", status: "EXEMPT", rate: 0.0 },
    { name: "Maternity and antenatal care services", category: "Medical Services", status: "EXEMPT", rate: 0.0 },
    { name: "Residential house mortgage interest", category: "Financial Services", status: "EXEMPT", rate: 0.0 },
    { name: "Commercial road passenger transport", category: "Transport", status: "EXEMPT", rate: 0.0 },
    { name: "Domestic air passenger economy tickets", category: "Transport", status: "EXEMPT", rate: 0.0 },
    { name: "Tertiary education tuition (universities)", category: "Education", status: "EXEMPT", rate: 0.0 },
    { name: "Religious and charitable organization services", category: "Non-Profit", status: "EXEMPT", rate: 0.0 },
    { name: "Local government public service charges", category: "Government", status: "EXEMPT", rate: 0.0 },
    { name: "Workers compensation insurance", category: "Financial Services", status: "EXEMPT", rate: 0.0 },
    { name: "Health maintenance organization (HMO) fees", category: "Medical Services", status: "EXEMPT", rate: 0.0 },

    // ─── Standard Rated Items (7.5% - Standard VAT applies) ─────────────────
    { name: "Smartphones and mobile tablets", category: "Electronics", status: "STANDARD", rate: 7.5 },
    { name: "Laptops and personal desktop computers", category: "Electronics", status: "STANDARD", rate: 7.5 },
    { name: "Television sets and home audio consoles", category: "Electronics", status: "STANDARD", rate: 7.5 },
    { name: "Imported canned foods and snacks", category: "Agriculture & Food", status: "STANDARD", rate: 7.5 },
    { name: "Bottled carbonated soda beverages", category: "Agriculture & Food", status: "STANDARD", rate: 7.5 },
    { name: "Imported clothing and designer footwear", category: "Apparel", status: "STANDARD", rate: 7.5 },
    { name: "Cosmetic perfumes and makeup accessories", category: "Beauty & Personal Care", status: "STANDARD", rate: 7.5 },
    { name: "Automobile passenger cars (imported)", category: "Transport", status: "STANDARD", rate: 7.5 },
    { name: "Legal consultation fees (commercial)", category: "Professional Services", status: "STANDARD", rate: 7.5 },
    { name: "Financial auditing and accounting services", category: "Professional Services", status: "STANDARD", rate: 7.5 },
    { name: "Software engineering development services", category: "Professional Services", status: "STANDARD", rate: 7.5 },
    { name: "Restaurant prepared meals and dining", category: "Hospitality", status: "STANDARD", rate: 7.5 },
    { name: "Hotel lodging and accommodation", category: "Hospitality", status: "STANDARD", rate: 7.5 },
    { name: "Cinema ticket purchases", category: "Entertainment", status: "STANDARD", rate: 7.5 },
    { name: "Telecom mobile call plans and airtime", category: "Telecommunications", status: "STANDARD", rate: 7.5 },
    { name: "Internet data plans and broadband bills", category: "Telecommunications", status: "STANDARD", rate: 7.5 },
    { name: "Gym memberships and fitness trainers", category: "Health & Wellness", status: "STANDARD", rate: 7.5 },
    { name: "Commercial office building rent", category: "Real Estate", status: "STANDARD", rate: 7.5 },
    { name: "Gaming consoles and video game discs", category: "Electronics", status: "STANDARD", rate: 7.5 },
    { name: "Washing machines and home appliances", category: "Electronics", status: "STANDARD", rate: 7.5 },
    { name: "Air conditioning units (split and window)", category: "Electronics", status: "STANDARD", rate: 7.5 },
    { name: "Imported rice (processed and packaged)", category: "Agriculture & Food", status: "STANDARD", rate: 7.5 },
    { name: "Alcoholic beverages and spirits", category: "Agriculture & Food", status: "STANDARD", rate: 7.5 },
    { name: "Cigarettes and tobacco products", category: "Agriculture & Food", status: "STANDARD", rate: 7.5 },
    { name: "Premium fashion brands and leather goods", category: "Apparel", status: "STANDARD", rate: 7.5 },
    { name: "Jewelry and precious accessories", category: "Beauty & Personal Care", status: "STANDARD", rate: 7.5 },
    { name: "Hair care and salon services", category: "Beauty & Personal Care", status: "STANDARD", rate: 7.5 },
    { name: "Motorcycles and tricycles (commercial)", category: "Transport", status: "STANDARD", rate: 7.5 },
    { name: "Vehicle spare parts and accessories", category: "Transport", status: "STANDARD", rate: 7.5 },
    { name: "Architectural and engineering consultancy", category: "Professional Services", status: "STANDARD", rate: 7.5 },
    { name: "Management and business consulting services", category: "Professional Services", status: "STANDARD", rate: 7.5 },
    { name: "Event catering and party planning", category: "Hospitality", status: "STANDARD", rate: 7.5 },
    { name: "Sporting event tickets and memberships", category: "Entertainment", status: "STANDARD", rate: 7.5 },
    { name: "Streaming subscriptions (Netflix, Spotify)", category: "Entertainment", status: "STANDARD", rate: 7.5 },
    { name: "Satellite TV and cable subscriptions", category: "Telecommunications", status: "STANDARD", rate: 7.5 },
    { name: "Printing and photocopying services", category: "Professional Services", status: "STANDARD", rate: 7.5 },
    { name: "Photography and videography services", category: "Professional Services", status: "STANDARD", rate: 7.5 },
    { name: "Courier and logistics delivery services", category: "Transport", status: "STANDARD", rate: 7.5 },
    { name: "Domestic flight business class tickets", category: "Transport", status: "STANDARD", rate: 7.5 },
    { name: "Luxury wristwatches and smartwatches", category: "Electronics", status: "STANDARD", rate: 7.5 },
    { name: "Property management and agency fees", category: "Real Estate", status: "STANDARD", rate: 7.5 },
    { name: "Swimming pool and spa services", category: "Health & Wellness", status: "STANDARD", rate: 7.5 },
    { name: "Laundry and dry cleaning services", category: "Health & Wellness", status: "STANDARD", rate: 7.5 },
    { name: "Fuel and petrol (diesel/petrol pump sales)", category: "Energy & Power", status: "STANDARD", rate: 7.5 },
    { name: "Natural gas (commercial/industrial supply)", category: "Energy & Power", status: "STANDARD", rate: 7.5 },
    { name: "Plumbing and electrical maintenance", category: "Professional Services", status: "STANDARD", rate: 7.5 },
    { name: "Car hire and ride-sharing services", category: "Transport", status: "STANDARD", rate: 7.5 },
    { name: "Advertising and marketing agency services", category: "Professional Services", status: "STANDARD", rate: 7.5 },
  ];

  for (const item of vatItems) {
    await prisma.vatItem.upsert({
      where: { name: item.name },
      update: { category: item.category, status: item.status, rate: item.rate },
      create: item,
    });
  }
  console.log(`✅ Seeded ${vatItems.length} VAT items.`);

  // 2. Seed Quiz Questions (50 questions across all topics)
  console.log("❓ Seeding Quiz questions...");
  const quizQuestions = [
    // ─── PAYE / Personal Income Tax ─────────────────────────────────────────
    {
      question: "Under the 2025 Nigeria Tax Act, what is the annual income threshold below which individuals are completely exempt from PAYE tax?",
      options: ["₦300,000", "₦500,000", "₦800,000", "₦1,200,000"],
      correctIndex: 2,
      explanation: "The 2025 reforms raise the minimum annual income tax threshold to ₦800,000, completely exempting low-income earners earning minimum wage (₦70,000 monthly) from paying PAYE tax.",
    },
    {
      question: "What is the tax rate applied to income between ₦800,001 and ₦3,800,000 under the new progressive bands?",
      options: ["10%", "15%", "20%", "25%"],
      correctIndex: 1,
      explanation: "The second tax band applies a 15% rate to annual income between ₦800,001 and ₦3,800,000.",
    },
    {
      question: "What is the top marginal PAYE tax rate for income exceeding ₦20,800,000 annually?",
      options: ["20%", "22%", "25%", "30%"],
      correctIndex: 2,
      explanation: "Income above ₦20,800,000 annually is taxed at the top rate of 25%.",
    },
    {
      question: "What is the mandatory employee pension contribution rate deducted from gross salary?",
      options: ["5%", "8%", "10%", "12%"],
      correctIndex: 1,
      explanation: "Under the Pension Reform Act, the mandatory minimum employee contribution rate is 8% of gross monthly salary, which is fully tax-deductible.",
    },
    {
      question: "What is the maximum annual rent relief cap under the 2025 NTA?",
      options: ["₦200,000", "₦350,000", "₦500,000", "₦750,000"],
      correctIndex: 2,
      explanation: "Rent relief is 20% of rent paid, capped at ₦500,000 per year.",
    },
    {
      question: "What is the monthly minimum wage set by the 2025 NTA reforms?",
      options: ["₦30,000", "₦50,000", "₦70,000", "₦100,000"],
      correctIndex: 2,
      explanation: "The minimum wage was set at ₦70,000 monthly (₦840,000 annually), meaning minimum wage earners are mostly exempt from PAYE.",
    },
    {
      question: "Which tax band applies to income between ₦3,800,001 and ₦6,800,000?",
      options: ["15%", "20%", "22%", "25%"],
      correctIndex: 1,
      explanation: "The third tax band applies a 20% rate to annual income between ₦3,800,001 and ₦6,800,000.",
    },
    {
      question: "What is the PAYE rate for income between ₦6,800,001 and ₦20,800,000?",
      options: ["15%", "20%", "22%", "25%"],
      correctIndex: 2,
      explanation: "The fourth tax band applies a 22% rate to annual income between ₦6,800,001 and ₦20,800,000.",
    },

    // ─── VAT ────────────────────────────────────────────────────────────────
    {
      question: "What is the current standard Value Added Tax (VAT) rate in Nigeria?",
      options: ["5.0%", "7.5%", "10.0%", "15.0%"],
      correctIndex: 1,
      explanation: "The standard VAT rate on standard-rated goods and services in Nigeria remains at 7.5%.",
    },
    {
      question: "Which of the following items is ZERO-RATED for VAT purposes?",
      options: ["Laptops", "Locally produced baby food", "Hotel lodging", "Smartphones"],
      correctIndex: 1,
      explanation: "Locally produced baby food is zero-rated, meaning 0% VAT with input VAT recoverable by businesses.",
    },
    {
      question: "Which category does 'School tuition fees' fall under for VAT?",
      options: ["Standard (7.5%)", "Zero-Rated (0%)", "Exempt", "Reduced (5%)"],
      correctIndex: 2,
      explanation: "School tuition fees are VAT-exempt, meaning no VAT is charged and input VAT is NOT recoverable.",
    },
    {
      question: "What is the key difference between ZERO-RATED and EXEMPT items?",
      options: [
        "There is no difference",
        "Zero-rated allows input VAT recovery; exempt does not",
        "Exempt items have higher rates",
        "Zero-rated items are imported only"
      ],
      correctIndex: 1,
      explanation: "Zero-rated items have 0% VAT but businesses can recover input VAT. Exempt items have no VAT charged AND input VAT cannot be recovered.",
    },
    {
      question: "Which of these is a standard-rated (7.5% VAT) item?",
      options: ["Fresh fruits", "Prescription drugs", "Internet data plans", "Residential rent"],
      correctIndex: 2,
      explanation: "Internet data plans are standard-rated at 7.5% VAT.",
    },
    {
      question: "Are exported goods zero-rated or exempt for VAT?",
      options: ["Exempt", "Zero-Rated", "Standard-rated", "Subject to 15%"],
      correctIndex: 1,
      explanation: "Exported goods and services are zero-rated, encouraging export trade by allowing VAT recovery.",
    },
    {
      question: "Which transport service is VAT-exempt?",
      options: ["Car hire services", "Commercial passenger bus transport", "Domestic flight business class", "Ride-sharing services"],
      correctIndex: 1,
      explanation: "Commercial passenger bus transport is VAT-exempt to keep public transportation affordable.",
    },

    // ─── CIT (Company Income Tax) ───────────────────────────────────────────
    {
      question: "Small businesses are completely exempt from CIT. What is the maximum annual turnover limit?",
      options: ["₦25 million", "₦50 million", "₦100 million", "₦250 million"],
      correctIndex: 2,
      explanation: "Companies with annual turnover not exceeding ₦100 million AND fixed assets under ₦250 million are completely exempt from CIT.",
    },
    {
      question: "What CIT rate applies to medium businesses (turnover ₦100M – ₦500M)?",
      options: ["10%", "20%", "30%", "35%"],
      correctIndex: 1,
      explanation: "Medium companies with turnover between ₦100 million and ₦500 million pay a reduced CIT rate of 20%.",
    },
    {
      question: "What is the CIT rate for large companies with turnover exceeding ₦500 million?",
      options: ["20%", "25%", "30%", "35%"],
      correctIndex: 2,
      explanation: "Large companies with turnover exceeding ₦500 million pay the standard 30% CIT rate.",
    },
    {
      question: "What is the maximum asset value for a company to qualify as a small business for CIT exemption?",
      options: ["₦100 million", "₦250 million", "₦500 million", "₦1 billion"],
      correctIndex: 1,
      explanation: "The fixed asset threshold for small business CIT exemption is ₦250 million net book value.",
    },

    // ─── Administrative / NRS ───────────────────────────────────────────────
    {
      question: "Which agency replaces the Federal Inland Revenue Service (FIRS)?",
      options: ["Joint Tax Board (JTB)", "Nigeria Revenue Service (NRS)", "Federal Tax Commission (FTC)", "National Revenue Administration (NRA)"],
      correctIndex: 1,
      explanation: "The Nigeria Revenue Service (NRS) replaces FIRS as the single collector of all federal revenues.",
    },
    {
      question: "When did the 2025 Nigeria Tax Act reforms officially take effect?",
      options: ["June 2025", "October 2025", "January 2026", "July 2026"],
      correctIndex: 2,
      explanation: "The 2025 NTA reforms officially took effect on January 1, 2026.",
    },
    {
      question: "Who signed the 2025 Nigeria Tax Act into law?",
      options: ["President Goodluck Jonathan", "President Muhammadu Buhari", "President Bola Ahmed Tinubu", "The National Assembly"],
      correctIndex: 2,
      explanation: "President Bola Ahmed Tinubu signed the 2025 Nigeria Tax Act into law in June 2025.",
    },
    {
      question: "What is the primary purpose of the NRS replacing FIRS?",
      options: [
        "To increase tax rates",
        "To modernize and unify revenue collection",
        "To reduce the number of taxpayers",
        "To eliminate all taxes"
      ],
      correctIndex: 1,
      explanation: "The NRS was created to modernize, streamline, and unify revenue collection across all tiers of government.",
    },

    // ─── Filing & Compliance ────────────────────────────────────────────────
    {
      question: "What is the typical annual PAYE filing deadline for individual tax returns in Nigeria?",
      options: ["December 31", "January 31", "March 31", "June 30"],
      correctIndex: 2,
      explanation: "Individual PAYE tax returns are typically due by March 31 of the year following the tax year.",
    },
    {
      question: "Which of the following is a penalty for late tax filing?",
      options: [
        "Free tax audit",
        "Penalty of ₦25,000 for individuals",
        "Tax exemption for one year",
        "Reduced tax rate"
      ],
      correctIndex: 1,
      explanation: "Late filing attracts penalties including ₦25,000 for individual taxpayers and ₦50,000 for companies, plus additional penalties for late payment.",
    },
    {
      question: "What document is required for an employer to process PAYE deductions?",
      options: [
        "Tax Clearance Certificate",
        "Payroll schedule and employee tax cards",
        "Bank statement",
        "Company registration certificate"
      ],
      correctIndex: 1,
      explanation: "Employers need payroll schedules and employee tax identification numbers (TIN) to process correct PAYE deductions.",
    },

    // ─── Capital Gains & Other Taxes ────────────────────────────────────────
    {
      question: "What is the capital gains tax rate on the disposal of assets in Nigeria?",
      options: ["5%", "10%", "15%", "20%"],
      correctIndex: 1,
      explanation: "Capital gains tax in Nigeria is charged at a flat rate of 10% on the net gains from the disposal of assets.",
    },
    {
      question: "Which of the following is exempt from capital gains tax?",
      options: [
        "Sale of a personal car",
        "Gain on sale of shares (subject to conditions)",
        "Sale of imported goods",
        "Rental income"
      ],
      correctIndex: 1,
      explanation: "Gains on the disposal of shares may be exempt under certain conditions, subject to the minimum tax exemption thresholds.",
    },

    // ─── Withholding Tax ────────────────────────────────────────────────────
    {
      question: "What is the withholding tax rate on dividend payments to Nigerian residents?",
      options: ["5%", "10%", "15%", "20%"],
      correctIndex: 1,
      explanation: "Dividends paid to Nigerian residents attract a 10% withholding tax rate, which is a final tax.",
    },
    {
      question: "Is withholding tax on interest income a final tax in Nigeria?",
      options: ["Yes, it is final", "No, it is a credit against PAYE", "Only for companies", "Only for foreign investors"],
      correctIndex: 0,
      explanation: "Withholding tax on interest income for individuals is treated as a final tax. For companies, it is a credit against CIT.",
    },
    {
      question: "What is the withholding tax rate on rent payments?",
      options: ["5%", "10%", "15%", "20%"],
      correctIndex: 1,
      explanation: "Rent payments attract a 10% withholding tax deduction at source.",
    },

    // ─── Stamp Duty ─────────────────────────────────────────────────────────
    {
      question: "What is the stamp duty rate on tenancy agreements in Nigeria?",
      options: ["0.5%", "1%", "1.5%", "2%"],
      correctIndex: 0,
      explanation: "Tenancy agreements attract a 0.5% stamp duty charge on the total rent value.",
    },
    {
      question: "Who is responsible for paying stamp duty on a rental agreement?",
      options: [
        "The tenant only",
        "The landlord only",
        "Both parties share equally",
        "The government pays"
      ],
      correctIndex: 2,
      explanation: "Stamp duty on tenancy agreements is typically shared equally between the landlord and the tenant.",
    },

    // ─── Tax Incentives & Reliefs ───────────────────────────────────────────
    {
      question: "What is the maximum rent relief deduction allowed under the 2025 NTA?",
      options: ["₦200,000", "₦350,000", "₦500,000", "₦750,000"],
      correctIndex: 2,
      explanation: "Rent relief is 20% of rent paid, capped at ₦500,000 per annum.",
    },
    {
      question: "Which type of income is eligible for PIT exemption under the 2025 NTA?",
      options: [
        "Salary income above ₦800,000",
        "Income of ₦800,000 or less annually",
        "Business income",
        "Investment income"
      ],
      correctIndex: 1,
      explanation: "Individuals earning ₦800,000 or less annually are completely exempt from personal income tax.",
    },
    {
      question: "Are pension contributions tax-deductible in Nigeria?",
      options: ["Yes, fully deductible", "No, not deductible", "Only partially", "Only for government workers"],
      correctIndex: 0,
      explanation: "Mandatory employee pension contributions (8% of gross) are fully tax-deductible before computing taxable income.",
    },
    {
      question: "What percentage of rent paid can be claimed as rent relief?",
      options: ["10%", "15%", "20%", "25%"],
      correctIndex: 2,
      explanation: "Employees can claim 20% of rent paid as rent relief, subject to the ₦500,000 annual cap.",
    },

    // ─── Digital Tax & Tech ─────────────────────────────────────────────────
    {
      question: "Are digital services provided by foreign companies subject to Nigerian VAT?",
      options: [
        "No, digital services are exempt",
        "Yes, if provided to Nigerian consumers",
        "Only if the company has a Nigerian office",
        "Only for streaming services"
      ],
      correctIndex: 1,
      explanation: "Digital services (streaming, apps, cloud services) provided to Nigerian consumers are subject to Nigerian VAT at 7.5%.",
    },
    {
      question: "What is the VAT treatment of mobile data plans in Nigeria?",
      options: ["Exempt", "Zero-Rated", "Standard 7.5%", "Reduced 5%"],
      correctIndex: 2,
      explanation: "Mobile data plans and broadband bills are standard-rated at 7.5% VAT.",
    },

    // ─── Penalties & Enforcement ────────────────────────────────────────────
    {
      question: "What is the penalty for failure to deduct withholding tax at source?",
      options: [
        "₦10,000 flat fine",
        "10% of the undeducted amount",
        "No penalty applies",
        "Imprisonment for 5 years"
      ],
      correctIndex: 1,
      explanation: "Failure to deduct WHT at source attracts a penalty of 10% of the amount that should have been deducted, plus interest.",
    },
    {
      question: "Can the NRS conduct a tax audit without prior notice?",
      options: [
        "No, 30 days notice is required",
        "Yes, for suspected fraud or evasion",
        "Only with court order",
        "Only during working hours"
      ],
      correctIndex: 1,
      explanation: "The NRS can conduct surprise audits in cases of suspected fraud, evasion, or when there is evidence of non-compliance.",
    },
    {
      question: "What happens if a company fails to file its CIT return on time?",
      options: [
        "Nothing happens",
        "A penalty of ₦25,000 plus ₦5,000 per month",
        "A penalty of ₦50,000 plus 5% of tax payable",
        "The company is automatically dissolved"
      ],
      correctIndex: 2,
      explanation: "Late CIT filing attracts a penalty of ₦50,000 for the first month plus 5% of the tax liability per month of delay.",
    },

    // ─── Multilateral / International Tax ────────────────────────────────────
    {
      question: "What is the transfer pricing rule under the 2025 NTA?",
      options: [
        "Companies can set any price for related-party transactions",
        "Related-party transactions must follow arm's length principles",
        "Transfer pricing only applies to imports",
        "There are no transfer pricing rules in Nigeria"
      ],
      correctIndex: 1,
      explanation: "The 2025 NTA requires that transactions between related parties follow arm's length principles to prevent profit shifting.",
    },
    {
      question: "Are non-residents earning income from Nigeria subject to tax?",
      options: [
        "No, non-residents are fully exempt",
        "Yes, on income derived from or accrued in Nigeria",
        "Only if they have a Nigerian bank account",
        "Only for business income"
      ],
      correctIndex: 1,
      explanation: "Non-residents are taxable on income derived from or accrued in Nigeria, including employment income for duties performed in Nigeria.",
    },
    {
      question: "What is the withholding tax rate on payments to non-resident companies?",
      options: ["5%", "10%", "15%", "20%"],
      correctIndex: 1,
      explanation: "Payments to non-resident companies generally attract a 10% withholding tax rate, which may be subject to double taxation treaties.",
    },

    // ─── General Knowledge ──────────────────────────────────────────────────
    {
      question: "Which of the following is NOT a tax collected by the NRS?",
      options: ["Company Income Tax", "Personal Income Tax (PAYE)", "Value Added Tax (VAT)", "Personal Income Tax (State-level)"],
      correctIndex: 3,
      explanation: "State-level Personal Income Tax (PAYE) is collected by State Internal Revenue Services (SIRS), not the NRS which handles federal taxes.",
    },
    {
      question: "What is the tax identification number (TIN) used for?",
      options: [
        "Opening a bank account only",
        "Identifying taxpayers for all tax purposes",
        "Registering a business only",
        "Import and export only"
      ],
      correctIndex: 1,
      explanation: "The TIN is a unique identifier assigned to every taxpayer for tracking compliance across all tax types and obligations.",
    },
    {
      question: "How many tax bands exist in the new PAYE progressive system?",
      options: ["3 bands", "4 bands", "5 bands", "6 bands"],
      correctIndex: 2,
      explanation: "There are 5 bands: 0% (up to ₦800K), 15% (₦800K–₦3.8M), 20% (₦3.8M–₦6.8M), 22% (₦6.8M–₦20.8M), and 25% (above ₦20.8M).",
    },
    {
      question: "Which document proves that a company has paid all its taxes?",
      options: [
        "Certificate of Incorporation",
        "Tax Clearance Certificate (TCC)",
        "Annual Return Form",
        "VAT Registration Certificate"
      ],
      correctIndex: 1,
      explanation: "A Tax Clearance Certificate (TCC) is issued annually to companies that have fully complied with their tax obligations.",
    },
    {
      question: "What is the maximum number of months a company can file its accounts late?",
      options: [
        "1 month",
        "3 months",
        "6 months",
        "There is no limit"
      ],
      correctIndex: 2,
      explanation: "Companies must file their audited accounts within 6 months of their financial year-end. Late filing attracts penalties.",
    },
    {
      question: "Is there a tax amnesty or waiver program under the 2025 NTA?",
      options: [
        "No, all taxes must be paid in full",
        "Yes, the Voluntary Assets and Income Declaration Scheme (VAIDS) provides waivers",
        "Only for new companies",
        "Only for individuals"
      ],
      correctIndex: 1,
      explanation: "The VAIDS program allows taxpayers to regularize their tax status with waivers on penalties and interest for voluntary declarations.",
    },
    {
      question: "What is the effective date for the new minimum wage in Nigeria?",
      options: ["January 2025", "April 2025", "July 2025", "January 2026"],
      correctIndex: 2,
      explanation: "The new ₦70,000 minimum wage took effect from July 2025, as signed into law by the President.",
    },
    {
      question: "Are agricultural loans subject to withholding tax in Nigeria?",
      options: [
        "Yes, at 10%",
        "Yes, at 5%",
        "No, agricultural loans are exempt",
        "Only for commercial farmers"
      ],
      correctIndex: 2,
      explanation: "Interest on agricultural loans is exempt from withholding tax to encourage investment in the agricultural sector.",
    },
    {
      question: "What is the VAT treatment of medical consultations?",
      options: ["Standard 7.5%", "Zero-Rated", "Exempt", "Reduced 5%"],
      correctIndex: 2,
      explanation: "Hospital clinical consultations and medical services are VAT-exempt to make healthcare more affordable.",
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

  // 3. Seed Educational Articles (15 articles)
  console.log("📚 Seeding educational articles...");
  const articles = [
    {
      title: "Introduction to the 2025 Nigeria Tax Act reforms",
      summary: "An overview of the landmark reforms restructuring Nigeria's tax brackets, exemptions, and collection agency.",
      content: "Effective January 1, 2026, the 2025 Nigeria Tax Act (NTA) fundamentally restructures the nation's fiscal framework. Signed into law by President Bola Ahmed Tinubu in June 2025, the new reforms target three main goals: relief for low-income earners, administrative efficiency, and simplified business compliance. Key highlights include the transition of the FIRS into the Nigeria Revenue Service (NRS), the raising of the personal income tax threshold to ₦800,000 annually, and tax exemptions for small businesses with annual turnovers of less than ₦100 million.",
      source: "NRS Gazette",
      isFeatured: true,
    },
    {
      title: "Understanding PAYE calculations under the new bands",
      summary: "Learn how to calculate your personal income tax using the progressive annual brackets and mandatory deductions.",
      content: "Under the new 2025 progressive tax bands, personal income tax is calculated annually. The first ₦800,000 is exempt (0%). The next ₦3,000,000 is taxed at 15%. The following ₦3,000,000 at 20%. The next ₦14,000,000 at 22%. Anything above ₦20,800,000 is taxed at 25%. Deductions include 8% pension and rent relief (20% of rent paid, capped at ₦500,000/year).",
      source: "KPMG Advisory",
      isFeatured: false,
    },
    {
      title: "Company Income Tax exemptions for small and micro businesses",
      summary: "How the ₦100 million turnover and ₦250 million asset limits protect small enterprises from taxation.",
      content: "Companies with turnover not exceeding ₦100 million and fixed assets under ₦250 million are completely exempt from CIT. Medium companies (₦100M–₦500M turnover) pay 20%. Large companies (above ₦500M) pay 30%. This exemption covers over 90% of registered SMEs in Nigeria.",
      source: "PwC Nigeria Report",
      isFeatured: false,
    },
    {
      title: "VAT changes and what they mean for consumers",
      summary: "A deep dive into zero-rated, exempt, and standard-rated items under the 2025 NTA.",
      content: "The 2025 NTA maintains the 7.5% standard VAT rate but expands the list of zero-rated items (basic food, medical supplies, educational materials) and exempt items (public transport, healthcare, financial services). Zero-rated items allow input VAT recovery, while exempt items do not. Understanding the difference helps businesses manage their tax obligations effectively.",
      source: "Deloitte Nigeria",
      isFeatured: false,
    },
    {
      title: "Pension reforms under the 2025 NTA",
      summary: "How the mandatory 8% pension contribution and retirement savings work under the new framework.",
      content: "The 2025 NTA reinforces the 8% mandatory employee pension contribution, fully tax-deductible. Employers must remit contributions within 7 working days. The reforms also introduce enhanced penalties for non-compliance and expand coverage to informal sector workers through the Micro Pension Plan.",
      source: "PenCom Advisory",
      isFeatured: false,
    },
    {
      title: "Digital tax compliance for online businesses",
      summary: "What digital service providers need to know about VAT registration, collection, and remittance.",
      content: "Foreign digital service providers supplying to Nigerian consumers must register for VAT and charge 7.5% on subscriptions, app purchases, and streaming services. Nigerian digital businesses must also register and comply. The NRS has introduced simplified registration portals for digital businesses.",
      source: "TechCabal Insights",
      isFeatured: false,
    },
    {
      title: "Capital gains tax explained for asset owners",
      summary: "Understanding the 10% CGT rate, exemptions, and how to calculate gains on property and share disposals.",
      content: "Capital gains tax is 10% on net gains from asset disposal. Key exemptions include gains on the sale of a personal residence (subject to conditions), and certain share disposals. The 2025 NTA clarifies calculation methods for both property and financial asset disposals.",
      source: "FBN Quest Research",
      isFeatured: false,
    },
    {
      title: "Withholding tax: A comprehensive guide for businesses",
      summary: "Everything you need to know about WHT rates, deduction obligations, and credit mechanisms.",
      content: "WHT is deducted at source on dividends (10%), interest (10%), rent (10%), royalties (10%), and contracts (5-10%). For companies, WHT is a credit against CIT. For individuals, it is a final tax. Failure to deduct WHT attracts a 10% penalty on the undeducted amount.",
      source: "Stanbic IBTC Tax Advisory",
      isFeatured: false,
    },
    {
      title: "Tax incentives for agriculture and manufacturing",
      summary: "How the 2025 NTA encourages investment in key sectors through tax holidays and allowances.",
      content: "The 2025 NTA provides tax holidays of 3-5 years for new agricultural investments, capital allowances of up to 100% for manufacturing equipment, and zero-rated VAT on agricultural inputs. These incentives aim to boost food security and industrialization.",
      source: "NIPC Bulletin",
      isFeatured: false,
    },
    {
      title: "Understanding the Tax Clearance Certificate process",
      summary: "Step-by-step guide to obtaining your TCC and why it matters for business operations.",
      content: "A Tax Clearance Certificate (TCC) is required for government contracts, import/export, and banking transactions. Apply through the tax authority with proof of filing returns, evidence of tax payment, and audited accounts. Processing takes 14-30 days. A valid TCC covers the preceding 3 years.",
      source: "NRS Public Notice",
      isFeatured: false,
    },
    {
      title: "Stamp duty obligations for everyday transactions",
      summary: "Which documents attract stamp duty and how the rates work under the Stamp Duty Act.",
      content: "Stamp duty applies to tenancy agreements (0.5%), power of attorney (1.5%), share transfers (0.75%), and insurance policies (varies). Non-stamped documents may be inadmissible in court. The 2025 reforms streamline collection through electronic stamping.",
      source: "Federal Inland Revenue Service Archives",
      isFeatured: false,
    },
    {
      title: "Tax planning strategies for salaried workers",
      summary: "Legal ways to reduce your tax burden through reliefs, allowances, and smart financial planning.",
      content: "Salaried workers can optimize their tax position by maximizing pension contributions (8% deductible), claiming rent relief (20% of rent, capped at ₦500K), using life insurance premium deductions, and taking advantage of the ₦800,000 exemption threshold. Avoiding taxable fringe benefits also helps.",
      source: "ARM Securities Research",
      isFeatured: false,
    },
    {
      title: "Transfer pricing rules for multinational companies",
      summary: "How the arm's length principle prevents profit shifting and ensures fair taxation.",
      content: "The 2025 NTA requires that related-party transactions follow arm's length pricing. Companies must maintain transfer pricing documentation, file annual returns with the NRS, and may face adjustments if prices deviate significantly from market rates. Penalties for non-compliance can be up to 1% of revenue.",
      source: "PwC Transfer Pricing Team",
      isFeatured: false,
    },
    {
      title: "How to register for tax as a new business in Nigeria",
      summary: "Step-by-step guide to obtaining your TIN, VAT registration, and CAC incorporation.",
      content: "New businesses must: (1) Register with CAC for incorporation, (2) Obtain a Tax Identification Number (TIN) from the Joint Tax Board, (3) Register for VAT if annual turnover exceeds ₦25 million, (4) Register for PAYE if hiring employees, (5) Open a business bank account with TIN. The entire process can be completed online through the JTB portal.",
      source: "SMEDAN Guide",
      isFeatured: false,
    },
    {
      title: "Non-resident taxation: What foreign workers and companies need to know",
      summary: "Tax obligations for non-residents earning income from Nigeria.",
      content: "Non-residents earning income from Nigeria are subject to Nigerian tax on income derived from or accrued in Nigeria. This includes employment income for duties performed in Nigeria, business profits through a permanent establishment, and rental income from Nigerian property. WHT at 10% applies as a final tax for most non-resident income types.",
      source: "Baker McKenzie Nigeria",
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
