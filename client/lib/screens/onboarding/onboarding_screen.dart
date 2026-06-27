import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<OnboardingData> _slides = [
    const OnboardingData(
      title: 'Nigeria Tax Act 2025',
      description: 'Navigate the new PAYE and Corporate Tax reforms with our up-to-date calculation guides.',
      icon: Icons.gavel,
    ),
    const OnboardingData(
      title: 'AI Tax Assistant',
      description: 'Upload your bank statement and chat with our AI to instantly identify deductions and exemptions.',
      icon: Icons.chat_bubble_outline,
    ),
    const OnboardingData(
      title: 'Community Forum',
      description: 'Join discussions with other tax payers and professionals to share answers to complex tax questions.',
      icon: Icons.people_outline,
    ),
  ];

  void _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.onboardedKey, true);
    if (mounted) {
      context.go('/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _finishOnboarding,
                child: const Text('Skip'),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (idx) => setState(() => _currentIndex = idx),
                itemCount: _slides.length,
                itemBuilder: (context, idx) {
                  final slide = _slides[idx];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          slide.icon,
                          size: 100,
                          color: theme.colorScheme.primary,
                        ).animate().scale(delay: 200.ms, duration: 400.ms, curve: Curves.easeOutBack),
                        const SizedBox(height: 40),
                        Text(
                          slide.title,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineLarge?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ).animate().fade(delay: 200.ms).slideY(begin: 0.2, end: 0.0),
                        const SizedBox(height: 16),
                        Text(
                          slide.description,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ).animate().fade(delay: 400.ms),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: List.generate(
                      _slides.length,
                      (idx) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentIndex == idx ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentIndex == idx ? theme.colorScheme.primary : theme.colorScheme.outlineVariant,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      if (_currentIndex < _slides.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      } else {
                        _finishOnboarding();
                      }
                    },
                    child: Icon(_currentIndex == _slides.length - 1 ? Icons.done : Icons.navigate_next),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final IconData icon;

  const OnboardingData({
    required this.title,
    required this.description,
    required this.icon,
  });
}
