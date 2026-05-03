import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class AppFooter extends StatelessWidget {
  final VoidCallback? onAboutTap;
  final VoidCallback? onPrivacyTap;
  final VoidCallback? onTermsTap;

  const AppFooter({
    super.key,
    this.onAboutTap,
    this.onPrivacyTap,
    this.onTermsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(
        children: [
          const Divider(color: Colors.white12),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _FooterLink(label: 'ABOUT', onTap: onAboutTap),
              _buildDot(),
              _FooterLink(label: 'PRIVACY POLICY', onTap: onPrivacyTap),
              _buildDot(),
              _FooterLink(label: 'TERMS & CONDITIONS', onTap: onTermsTap),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '© 2024 NET Speed Test. ALL RIGHTS RESERVED.',
            style: TextStyle(
              color: AppColors.textSecondary.withOpacity(0.5),
              fontSize: 10,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      width: 3,
      height: 3,
      decoration: const BoxDecoration(
        color: Colors.white24,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _FooterLink({required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}
