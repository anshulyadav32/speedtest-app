import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

// ─── Data Models ─────────────────────────────────────────────────────────────

class _Section {
  final String heading;
  final String body;
  const _Section(this.heading, this.body);
}

// ─── Generic Info Page ────────────────────────────────────────────────────────

class InfoPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final List<_Section> sections;

  const InfoPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.sections,
    // kept for backward compat (ignored)
    String? content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildHeader(context),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, i) => _SectionCard(section: sections[i], accent: accentColor),
                childCount: sections.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildHeader(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 180,
      pinned: true,
      backgroundColor: AppColors.background,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                accentColor.withOpacity(0.15),
                AppColors.background,
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 48, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: accentColor.withOpacity(0.3)),
                    ),
                    child: Icon(icon, color: accentColor, size: 24),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AppColors.textSecondary.withOpacity(0.6),
                      fontSize: 12,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final _Section section;
  final Color accent;

  const _SectionCard({required this.section, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 3,
                  height: 16,
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    section.heading,
                    style: TextStyle(
                      color: accent,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              section.body,
              style: TextStyle(
                color: AppColors.textSecondary.withOpacity(0.8),
                fontSize: 14,
                height: 1.7,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Page Content ─────────────────────────────────────────────────────────────

class InfoPages {
  // ── About ──────────────────────────────────────────────────────────────────
  static InfoPage aboutPage() => InfoPage(
        title: 'ABOUT',
        subtitle: 'NET Speed Test — KNOW YOUR CONNECTION',
        icon: Icons.bolt_rounded,
        accentColor: AppColors.accent,
        sections: const [
          _Section(
            'WHAT IS NET Speed Test?',
            'NET Speed Test is a high-fidelity internet speed test application built with Flutter. It provides accurate, real-time measurements of your connection\'s latency, download speed, and upload speed — beautifully visualized.',
          ),
          _Section(
            'HOW IT WORKS',
            'NET Speed Test measures your idle ping by timing round-trips to reference servers. Download and upload speeds are calculated by transferring test payloads and measuring throughput over a consistent duration.',
          ),
          _Section(
            'OUR MISSION',
            'We believe everyone deserves transparent insight into their digital connectivity. NET Speed Test is designed to give you professional-grade network diagnostics in a clean, accessible interface — no clutter, no subscriptions.',
          ),
          _Section(
            'TECHNOLOGY',
            'Built with Flutter for cross-platform performance. Public IP detection via ipify.org. ISP & geolocation via ipapi.co. Local IP detection via WebRTC on web and native network APIs on Android/iOS.',
          ),
        ],
      );

  // ── Privacy Policy ─────────────────────────────────────────────────────────
  static InfoPage privacyPage() => InfoPage(
        title: 'PRIVACY POLICY',
        subtitle: 'LAST UPDATED: APRIL 2025',
        icon: Icons.shield_rounded,
        accentColor: const Color(0xFF00C853),
        sections: const [
          _Section(
            'OUR COMMITMENT',
            'At NET Speed Test, your privacy is a priority. This policy explains what data is processed when you use the app and how it is handled.',
          ),
          _Section(
            '1. DATA WE PROCESS',
            'To perform a speed test, we process your public IP address, ISP name, approximate city/region, and connection metrics (ping, download speed, upload speed). We do not collect your name, email, or any personal identifiers.',
          ),
          _Section(
            '2. HOW DATA IS USED',
            'Network data is used exclusively to calculate your connection speed and display relevant server and location information. No data is stored on our servers after your session ends.',
          ),
          _Section(
            '3. THIRD-PARTY SERVICES',
            'We use ipify.org for public IP detection and ipapi.co for geolocation. These services have their own privacy policies. We do not sell, rent, or share your data with advertisers or data brokers.',
          ),
          _Section(
            '4. LOCAL STORAGE & COOKIES',
            'This application may use browser local storage to remember your display preferences. No tracking cookies or analytics SDKs are used.',
          ),
          _Section(
            '5. YOUR RIGHTS',
            'Since we do not store personal data, there is no profile to delete. If you have questions about data handling, contact us at support@netspeed.app.',
          ),
        ],
      );

  // ── Terms & Conditions ─────────────────────────────────────────────────────
  static InfoPage termsPage() => InfoPage(
        title: 'TERMS & CONDITIONS',
        subtitle: 'LAST UPDATED: APRIL 2025',
        icon: Icons.gavel_rounded,
        accentColor: const Color(0xFFFF6D00),
        sections: const [
          _Section(
            'AGREEMENT',
            'By accessing or using NET Speed Test, you agree to be bound by these Terms. If you do not agree, please discontinue use of the application immediately.',
          ),
          _Section(
            '1. SERVICE USAGE',
            'NET Speed Test is provided "as is" for personal, non-commercial use. Speed measurements are indicative and may be affected by device capabilities, network congestion, and other external factors outside our control.',
          ),
          _Section(
            '2. ACCURACY DISCLAIMER',
            'Results displayed are estimates based on test conditions at the time of measurement. NET Speed Test does not guarantee that results reflect the maximum or average performance of your internet plan.',
          ),
          _Section(
            '3. PROHIBITED CONDUCT',
            'You may not: (a) use automated tools to scrape or stress-test our infrastructure; (b) attempt to reverse-engineer the application; (c) use the service for any unlawful purpose or in violation of any regulations.',
          ),
          _Section(
            '4. LIMITATION OF LIABILITY',
            'To the fullest extent permitted by law, NET Speed Test and its developers shall not be liable for any indirect, incidental, or consequential damages arising from use or inability to use this service.',
          ),
          _Section(
            '5. CHANGES TO TERMS',
            'We reserve the right to modify these Terms at any time. Changes will be reflected by the "Last Updated" date. Continued use of the service after changes constitutes your acceptance of the revised Terms.',
          ),
        ],
      );

  // ── Legacy string constants (kept for backward compat) ────────────────────
  static const String about = '';
  static const String privacyPolicy = '';
  static const String termsConditions = '';
}
