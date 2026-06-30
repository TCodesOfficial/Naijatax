import 'package:flutter/material.dart';

import '../../models/user_model.dart';
import '../../models/tax_profile.dart';
import '../../models/article_model.dart';
import '../../models/forum_model.dart';
import '../../models/quiz_model.dart';
import '../../models/learn_section.dart';

class DevData {
  DevData._();

  // ── User ────────────────────────────────────────────────────────────────
  static final user = UserModel(
    id: 'dev-user-001',
    email: 'adedeji.akinwale@gmail.com',
    phone: '+2348012345678',
    displayName: 'Adedeji Akinwale',
    role: 'USER',
    avatarUrl: 'https://i.pravatar.cc/150?img=32',
    createdAt: DateTime(2025, 1, 15),
  );

  // ── Tax Profile ─────────────────────────────────────────────────────────
  static final taxProfile = TaxProfile(
    monthlyIncome: 850000,
    annualGross: 10200000,
    pensionDeduction: 816000,
    rentRelief: 200000,
    taxableIncome: 9184000,
    computedTax: 2196400,
    netIncome: 7187600,
    isExempt: false,
    citExemption: 'Not Applicable',
    savings: 816000,
    breakdown: [
      TaxBreakdown(bracket: 'First ₦300,000', rate: 0.07, taxableAmount: 300000, tax: 21000),
      TaxBreakdown(bracket: 'Next ₦300,000', rate: 0.11, taxableAmount: 300000, tax: 33000),
      TaxBreakdown(bracket: 'Next ₦400,000', rate: 0.15, taxableAmount: 400000, tax: 60000),
      TaxBreakdown(bracket: 'Next ₦500,000', rate: 0.19, taxableAmount: 500000, tax: 95000),
      TaxBreakdown(bracket: 'Next ₦500,000', rate: 0.21, taxableAmount: 500000, tax: 105000),
      TaxBreakdown(bracket: 'Next ₦800,000', rate: 0.24, taxableAmount: 800000, tax: 192000),
      TaxBreakdown(bracket: 'Above ₦3,300,000', rate: 0.25, taxableAmount: 6384000, tax: 1596000),
    ],
  );

  // ── Articles ────────────────────────────────────────────────────────────
  static final articles = [
    TaxArticle(
      id: 'art-001',
      title: 'FIRS Announces New Compliance Deadline for 2025',
      summary: 'The Federal Inland Revenue Service has extended the tax filing deadline for individual taxpayers under the new NTA 2025 framework.',
      content: 'Full article content here...',
      source: 'FIRS',
      url: 'https://firs.gov.ng/news/deadline-2025',
      isFeatured: true,
      createdAt: DateTime(2025, 6, 15),
    ),
    TaxArticle(
      id: 'art-002',
      title: 'Understanding the New PAYE Brackets',
      summary: 'A comprehensive guide to the updated Pay As You Earn progressive tax brackets under the Nigeria Tax Act 2025.',
      content: 'Full article content here...',
      source: 'Guide',
      isFeatured: true,
      createdAt: DateTime(2025, 6, 10),
    ),
    TaxArticle(
      id: 'art-003',
      title: 'CIT Exemption Threshold Raised for Small Businesses',
      summary: 'Small companies with annual turnover below ₦50M are now exempt from Companies Income Tax under the new reforms.',
      content: 'Full article content here...',
      source: 'Policy Update',
      isFeatured: false,
      createdAt: DateTime(2025, 6, 8),
    ),
    TaxArticle(
      id: 'art-004',
      title: 'VAT on Digital Services: What You Need to Know',
      summary: 'The government has clarified the scope of VAT application on digital and electronic services provided in Nigeria.',
      content: 'Full article content here...',
      source: 'FIRS',
      url: 'https://firs.gov.ng/vat-digital',
      isFeatured: false,
      createdAt: DateTime(2025, 5, 30),
    ),
    TaxArticle(
      id: 'art-005',
      title: 'How to File Your Tax Returns Using the New Portal',
      summary: 'Step-by-step walkthrough of the revamped FIRS online tax filing portal and its new features.',
      content: 'Full article content here...',
      source: 'Guide',
      isFeatured: false,
      createdAt: DateTime(2025, 5, 25),
    ),
  ];

  // ── Economic Metrics ────────────────────────────────────────────────────
  static const metrics = {
    'inflationRate': 22.5,
    'cpiChange': 1.8,
    'exchangeRate': 1550.0,
    'gstRevenue': 8.2e12,
    'taxToGdpRatio': 6.1,
  };

  // ── Forum Topics ────────────────────────────────────────────────────────
  static final topics = [
    ForumTopic(
      id: 'top-001',
      title: 'How is rent relief calculated under NTA 2025?',
      content: 'I saw the new rent relief provision but I am confused about the cap. Can someone explain how it works for someone earning ₦500k monthly?',
      tags: ['PAYE', 'Rent Relief', 'NTA 2025'],
      user: ForumUser(id: 'dev-user-001', email: 'adedeji.akinwale@gmail.com'),
      replyCount: 8,
      upVotes: 15,
      downVotes: 0,
      createdAt: DateTime(2025, 6, 12),
    ),
    ForumTopic(
      id: 'top-002',
      title: 'Are freelancers required to register for VAT?',
      content: 'I work as a freelance developer serving international clients. Do I need to register for VAT in Nigeria?',
      tags: ['VAT', 'Freelancers'],
      user: ForumUser(id: 'user-002', email: 'chika.o@gmail.com'),
      replyCount: 12,
      upVotes: 24,
      downVotes: 1,
      createdAt: DateTime(2025, 6, 10),
    ),
    ForumTopic(
      id: 'top-003',
      title: 'CIT exemption for startups — eligible criteria?',
      content: 'What are the exact criteria for startups to qualify for the CIT exemption? My fintech startup just incorporated last year.',
      tags: ['CIT', 'Startups'],
      user: ForumUser(id: 'user-003', email: 'emeka.n@outlook.com'),
      replyCount: 5,
      upVotes: 9,
      downVotes: 0,
      createdAt: DateTime(2025, 6, 8),
    ),
    ForumTopic(
      id: 'top-004',
      title: 'Best practices for keeping tax records as a small business',
      content: 'I run a small retail business in Lagos. What records should I keep and for how long to stay compliant?',
      tags: ['Records', 'Small Business'],
      user: ForumUser(id: 'user-004', email: 'fatima.k@yahoo.com'),
      replyCount: 15,
      upVotes: 30,
      downVotes: 0,
      createdAt: DateTime(2025, 6, 5),
    ),
    ForumTopic(
      id: 'top-005',
      title: 'Difference between PAYE and direct assessment?',
      content: 'I am confused about when PAYE applies versus when I need to do a direct assessment. Can someone clarify?',
      tags: ['PAYE', 'Assessment'],
      user: ForumUser(id: 'user-005', email: 'tunde.b@gmail.com'),
      replyCount: 7,
      upVotes: 11,
      downVotes: 0,
      createdAt: DateTime(2025, 6, 1),
    ),
  ];

  // ── Quiz Questions ──────────────────────────────────────────────────────
  static final quizQuestions = [
    QuizQuestion(
      id: 'q-001',
      question: 'What is the minimum taxable income threshold under NTA 2025?',
      options: ['₦300,000', '₦500,000', '₦800,000', '₦1,000,000'],
      correctIndex: 0,
      explanation: 'The first ₦300,000 of taxable income is taxed at 7% under the new progressive brackets.',
    ),
    QuizQuestion(
      id: 'q-002',
      question: 'What is the highest PAYE tax rate under the new NTA 2025?',
      options: ['20%', '22%', '24%', '25%'],
      correctIndex: 3,
      explanation: 'The top marginal rate is 25% for taxable income above ₦3,300,000 per annum.',
    ),
    QuizQuestion(
      id: 'q-003',
      question: 'Which body is responsible for collecting VAT in Nigeria?',
      options: ['CBN', 'FIRS', 'NNPC', 'NAFDAC'],
      correctIndex: 1,
      explanation: 'The Federal Inland Revenue Service (FIRS) is responsible for VAT collection nationwide.',
    ),
    QuizQuestion(
      id: 'q-004',
      question: 'What is the standard VAT rate in Nigeria?',
      options: ['5%', '7.5%', '10%', '12.5%'],
      correctIndex: 1,
      explanation: 'Nigeria charges a flat 7.5% Value Added Tax on most goods and services.',
    ),
    QuizQuestion(
      id: 'q-005',
      question: 'Who is exempt from Companies Income Tax under NTA 2025?',
      options: [
        'Companies with turnover above ₦100M',
        'Small companies with turnover below ₦50M',
        'All tech startups',
        'Foreign companies operating in Nigeria',
      ],
      correctIndex: 1,
      explanation: 'Small companies with annual turnover below ₦50 million are exempt from CIT.',
    ),
  ];

  // ── Quiz Scores ─────────────────────────────────────────────────────────
  static final quizScores = [
    QuizScore(id: 'qs-001', score: 4, totalQuestions: 5, createdAt: DateTime(2025, 6, 14)),
    QuizScore(id: 'qs-002', score: 3, totalQuestions: 5, createdAt: DateTime(2025, 6, 10)),
    QuizScore(id: 'qs-003', score: 5, totalQuestions: 5, createdAt: DateTime(2025, 6, 5)),
  ];

  // ── Tax Category Results (for dashboard tiles) ──────────────────────────

  /// PAYE: effective tax rate (computedTax / annualGross)
  static double get payeRate =>
      taxProfile.annualGross > 0 ? taxProfile.computedTax / taxProfile.annualGross : 0;

  /// VAT: monthly VAT on estimated spending (7.5% of 40% of income)
  static double get vatPayable => taxProfile.monthlyIncome * 0.40 * 0.075;
  static double get vatMaxRef => 50000.0; // reference max for progress

  /// CIT: corporate tax — not applicable for individual, show exemption status
  static double get citRatio => taxProfile.citExemption == 'EXEMPT' ? 0.0 : 0.75;

  /// Net Income: percentage of gross kept after tax
  static double get netIncomeRatio =>
      taxProfile.annualGross > 0 ? taxProfile.netIncome / taxProfile.annualGross : 0;

  /// Pension: deduction as percentage of gross
  static double get pensionRatio =>
      taxProfile.annualGross > 0 ? taxProfile.pensionDeduction / taxProfile.annualGross : 0;

  /// Relief: rent relief as percentage of max relief (₦200,000 is the cap)
  static double get reliefRatio => taxProfile.rentRelief / 200000;

  // ── Learn Sections (NTA 2025 Reform Content) ──────────────────────────
  static final learnSections = [
    LearnSection(
      title: 'Overview of the NTA 2025',
      icon: Icons.gavel_outlined,
      summary:
          'The 2025 Nigeria Tax Act (NTA) is a landmark legislation signed into law by President Bola Ahmed Tinubu in June 2025, effective January 1, 2026. It fundamentally restructures Nigeria\'s fiscal framework with three core goals: relief for low-income earners, administrative efficiency, and simplified business compliance.',
      highlights: [
        'FIRS transitions into the Nigeria Revenue Service (NRS) as the modernized single collector for all federal revenues',
        'Personal income tax threshold raised to ₦800,000 annually, exempting minimum wage earners from PAYE',
        'Small businesses with turnover below ₦100 million are completely exempt from Company Income Tax',
        'New progressive tax bands replace the old system for individual taxpayers',
        'Enhanced digital filing portal for streamlined tax compliance',
      ],
    ),
    LearnSection(
      title: 'PAYE Brackets & Income Tax',
      icon: Icons.receipt_long_outlined,
      summary:
          'Under the new progressive tax bands, personal income tax is calculated annually. The system provides significant relief for low and middle-income earners while maintaining a fair top marginal rate for high earners.',
      highlights: [
        'First ₦800,000: Exempt (0% rate) — up from ₦300,000 under the old system',
        'Next ₦3,000,000: Taxed at 15%',
        'Next ₦3,000,000: Taxed at 20%',
        'Next ₦14,000,000: Taxed at 22%',
        'Above ₦20,800,000: Top rate of 25%',
        'Mandatory 8% employee pension contribution (tax-deductible)',
        'Rent relief: 20% of rent paid, capped at ₦500,000 per year',
      ],
      linkRoute: '/calculator/nta-brackets',
      linkLabel: 'View Tax Brackets',
    ),
    LearnSection(
      title: 'VAT Changes & Categories',
      icon: Icons.shopping_cart_outlined,
      summary:
          'The standard VAT rate remains at 7.5%, but the reforms clarify the scope of VAT application, especially for digital services. Essential goods and services are zero-rated or exempt to protect low-income households.',
      highlights: [
        'Standard rate: 7.5% on standard-rated goods and services',
        'Zero-rated (0%): Basic food items (bread, rice, fresh produce), exported goods, solar panels, educational textbooks',
        'Exempt: School tuition, medical services, residential rent, public transport, financial services',
        'Digital services: Clear scope for VAT on electronic and digital services provided in Nigeria',
        '50+ items classified under the new VAT framework',
      ],
      linkRoute: '/calculator',
      linkLabel: 'Check VAT Items',
    ),
    LearnSection(
      title: 'Company Income Tax (CIT)',
      icon: Icons.business_outlined,
      summary:
          'The reforms provide complete tax relief to micro and small businesses to foster economic growth. The CIT structure is now tiered based on company size, protecting over 90% of registered SMEs in Nigeria.',
      highlights: [
        'Small companies (turnover ≤ ₦100M, assets ≤ ₦250M): Completely exempt from CIT',
        'Medium companies (turnover ₦100M–₦500M): Reduced rate of 20%',
        'Large companies (turnover > ₦500M): Standard rate of 30%',
        'Exemption covers over 90% of registered SMEs in Nigeria',
        'Fixed assets threshold: ₦250 million net book value',
      ],
    ),
    LearnSection(
      title: 'Tax Filing & Compliance',
      icon: Icons.assignment_outlined,
      summary:
          'The new reforms introduce a revamped digital filing portal and updated compliance deadlines. The Nigeria Revenue Service (NRS) provides modernized tools for seamless tax filing.',
      highlights: [
        'New FIRS/NRS online tax filing portal with enhanced features',
        'Extended compliance deadline for individual taxpayers under the NTA 2025 framework',
        'Digital-first approach: File returns, track refunds, and manage compliance online',
        'Penalties for non-compliance updated to reflect new thresholds',
        'Tax clearance certificates now issued digitally',
      ],
    ),
    LearnSection(
      title: 'Key Contacts & Resources',
      icon: Icons.contact_phone_outlined,
      summary:
          'Access official resources and get help with your tax questions. Our AI Assistant is trained on the NTA 2025 reforms and can answer common tax questions instantly.',
      highlights: [
        'Nigeria Revenue Service (NRS): Official successor to FIRS for federal tax collection',
        'AI Tax Assistant: Ask questions about NTA 2025 reforms anytime (in-app)',
        'Community Forum: Discuss tax topics with other taxpayers and experts',
        'Tax Practitioners: Consult a certified professional for complex tax matters',
      ],
      linkRoute: '/chat',
      linkLabel: 'Ask AI Assistant',
    ),
  ];
}
