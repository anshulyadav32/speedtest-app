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
                    child: LayoutBuilder(
                      builder: (context, bodyConstraints) {
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          transitionBuilder: (child, animation) =>
                              FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                          child: _buildBody(
                            service,
                            bodyConstraints.maxHeight,
                          ),
                        );
                      },
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

  Widget _buildBody(SpeedTestService service, double availableHeight) {
    return switch (service.state) {
      TestState.idle => GoButton(
          pulseAnimation: _pulseAnimation,
          availableHeight: availableHeight,
          onTap: service.runTest,
        ),
      TestState.finished => ResultsView(service: service),
      _ => RunningView(service: service),
    };
  }

  AppBar _buildAppBar() {
    final authService = context.read<AuthService?>();
    final user = authService?.currentUser;

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset('assets/logo.svg', height: 28, width: 28),
          const SizedBox(width: 10),
          const Flexible(
            child: Text(
              'NET Speed Test',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                letterSpacing: 2.5,
                color: AppColors.textPrimary,
                fontSize: 17,
              ),
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
            if (user == null) {
              if (mounted) {
                Navigator.of(context).pushNamed('/login');
              }
              return;
            }

            await authService?.signOut();
            if (mounted) {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/home', (route) => false);
            }
          },
          child: Text(
            user == null ? 'SIGN IN' : 'SIGN OUT',
            style: TextStyle(
              color: user == null
                  ? AppColors.textPrimary
                  : const Color(0xFFFF6B6B),
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
