import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/theme_colors.dart';

class MobileLandingScreen extends StatelessWidget {
  const MobileLandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary,
              Color(0xFF001F6B),
              Color(0xFF001453),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                const Spacer(flex: 2),

                // Logo
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet_outlined,
                    size: 44,
                    color: Colors.white,
                  ),
                ).animate().scale(
                      delay: 200.ms,
                      duration: 500.ms,
                      begin: const Offset(0.8, 0.8),
                      end: const Offset(1, 1),
                      curve: Curves.easeOutBack,
                    ),

                const SizedBox(height: 28),

                // App name
                Text(
                  AppConstants.appShortName,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.72,
                  ),
                ).animate().fadeIn(delay: 300.ms, duration: 500.ms).slideY(
                      begin: 0.3,
                      end: 0,
                      delay: 300.ms,
                      duration: 500.ms,
                      curve: Curves.easeOut,
                    ),

                const SizedBox(height: 8),

                // Tagline
                Text(
                  'Understand Your Taxes.\nMaster Your Finances.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withValues(alpha: 0.8),
                    height: 1.5,
                  ),
                ).animate().fadeIn(delay: 450.ms, duration: 500.ms).slideY(
                      begin: 0.3,
                      end: 0,
                      delay: 450.ms,
                      duration: 500.ms,
                      curve: Curves.easeOut,
                    ),

                const Spacer(flex: 3),

                // Feature highlights
                _FeatureItem(
                  icon: Icons.calculate_outlined,
                  label: 'Instant Tax Calculations',
                  delay: 550,
                ),
                const SizedBox(height: 16),
                _FeatureItem(
                  icon: Icons.psychology_outlined,
                  label: 'AI-Powered Tax Assistant',
                  delay: 650,
                ),
                const SizedBox(height: 16),
                _FeatureItem(
                  icon: Icons.school_outlined,
                  label: 'Learn Nigerian Tax Law',
                  delay: 750,
                ),

                const Spacer(flex: 3),

                // Get Started button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => context.go('/register'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      textStyle: GoogleFonts.inter(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: const Text('Get Started'),
                  ),
                ).animate().fadeIn(delay: 850.ms, duration: 500.ms).slideY(
                      begin: 0.4,
                      end: 0,
                      delay: 850.ms,
                      duration: 500.ms,
                      curve: Curves.easeOut,
                    ),

                const SizedBox(height: 16),

                // Sign In link
                TextButton(
                  onPressed: () => context.go('/login'),
                  child: Text(
                    'I already have an account',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ).animate().fadeIn(delay: 950.ms, duration: 500.ms),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int delay;

  const _FeatureItem({
    required this.icon,
    required this.label,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        const SizedBox(width: 16),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
      ],
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: delay), duration: 400.ms)
        .slideX(
          begin: -0.2,
          end: 0,
          delay: Duration(milliseconds: delay),
          duration: 400.ms,
          curve: Curves.easeOut,
        );
  }
}
