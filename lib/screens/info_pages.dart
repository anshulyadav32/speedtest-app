import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class InfoPage extends StatelessWidget {
  final String title;
  final String content;

  const InfoPage({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            color: AppColors.textPrimary,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Text(
          content,
          style: TextStyle(
            color: AppColors.textSecondary.withOpacity(0.8),
            fontSize: 14,
            height: 1.6,
          ),
        ),
      ),
    );
  }
}

class InfoPages {
  static const String about = """
NETSPEED is a high-fidelity speed test application built with Flutter. It provides accurate measurements of your internet connection's ping, download, and upload speeds.

Designed for performance and aesthetics, NETSPEED replicates the experience of professional network diagnostic tools with a modern, reactive interface.

Our mission is to provide users with transparent and reliable network insights, helping them understand their digital connectivity better.
""";

  static const String privacyPolicy = """
Last Updated: April 2024

At NETSPEED, we take your privacy seriously. This policy explains how we handle your data.

1. DATA COLLECTION
We do not collect personal identification information. We only process network data (IP address, ISP, and connection metrics) necessary to perform the speed test.

2. USAGE
Network data is used solely to calculate your connection speed and provide you with local server information.

3. THIRD PARTIES
We do not sell or share your data with third parties. All tests are performed directly between your device and our testing infrastructure.

4. COOKIES
This web application may use local storage to remember your preferences but does not use tracking cookies.
""";

  static const String termsConditions = """
Last Updated: April 2024

By using NETSPEED, you agree to the following terms:

1. SERVICE USAGE
NETSPEED is provided "as is" for personal, non-commercial use. We do not guarantee 100% accuracy of measurements as they can be affected by various external factors.

2. PROHIBITED ACTIONS
Users may not attempt to reverse engineer, scrape, or perform automated tests against our infrastructure without explicit permission.

3. LIMITATION OF LIABILITY
NETSPEED shall not be liable for any damages arising from the use or inability to use this service.

4. CHANGES
We reserve the right to modify these terms at any time. Continued use of the service constitutes acceptance of the new terms.
""";
}
