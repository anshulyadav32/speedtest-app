import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../services/speed_test_service.dart';
import '../services/auth_service.dart';
import '../widgets/common/info_bar.dart';
import '../widgets/common/footer.dart';
import '../widgets/idle/go_button.dart';
import '../widgets/running/running_view.dart';
import '../widgets/results/results_view.dart';
import 'info_pages.dart';

/// Thin coordinator: owns the pulse animation and delegates each
/// screen state to its own dedicated widget.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Only repeat animation if NOT in a test environment to prevent pumpAndSettle timeouts
    if (kIsWeb || !const bool.fromEnvironment('FLUTTER_TEST')) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _navigateToInfo(InfoPage page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, animation, __) => page,
        transitionsBuilder: (_, animation, __, child) => FadeTransition(
          opacity: animation,
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Consumer<SpeedTestService>(
        builder: (context, service, _) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                children: [
                  InfoBar(details: service.details),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      transitionBuilder: (child, animation) =>
                          FadeTransition(opacity: animation, child: child),
                      child: _buildBody(service),
                    ),
                  ),
                  AppFooter(
                    onAboutTap: () => _navigateToInfo(InfoPages.aboutPage()),
                    onPrivacyTap: () =>
                        _navigateToInfo(InfoPages.privacyPage()),
                    onTermsTap: () => _navigateToInfo(InfoPages.termsPage()),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(SpeedTestService service) {
    return switch (service.state) {
      TestState.idle => GoButton(
          pulseAnimation: _pulseAnimation,
          onTap: service.runTest,
        ),
      TestState.finished => ResultsView(service: service),
      _ => RunningView(service: service),
    };
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Row(
        children: [
          SvgPicture.asset('assets/logo.svg', height: 28, width: 28),
          const SizedBox(width: 10),
          const Text(
            'NET Speed Test',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              letterSpacing: 2.5,
              color: AppColors.textPrimary,
              fontSize: 17,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {},
          child: const Text('APPS',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        ),
        TextButton(
          onPressed: () {},
          child: const Text('ANALYSIS',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        ),
        TextButton(
          onPressed: () async {
            await context.read<AuthService>().signOut();
            if (mounted) {
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
            }
          },
          child: const Text('SIGN OUT',
              style: TextStyle(color: Color(0xFFFF6B6B), fontSize: 12)),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
