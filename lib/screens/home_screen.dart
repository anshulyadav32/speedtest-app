import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../services/speed_test_service.dart';
import '../widgets/gauge.dart';
import '../widgets/metric_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            SvgPicture.asset(
              'assets/logo.svg',
              height: 32,
              width: 32,
            ),
            const SizedBox(width: 10),
            Text(
              'NETSPEED',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
                color: Colors.white.withOpacity(0.9),
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () {}, child: const Text('APPS')),
          TextButton(onPressed: () {}, child: const Text('ANALYSIS')),
          const SizedBox(width: 10),
        ],
      ),
      body: Consumer<SpeedTestService>(
        builder: (context, service, child) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: _buildBody(service),
          );
        },
      ),
    );
  }

  Widget _buildBody(SpeedTestService service) {
    if (service.state == TestState.idle) {
      return _buildIdleState(context, service);
    } else if (service.state == TestState.finished) {
      return _buildFinishedState(context, service);
    } else {
      return _buildRunningState(context, service);
    }
  }

  Widget _buildIdleState(BuildContext context, SpeedTestService service) {
    return Center(
      key: const ValueKey('idle'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/logo.svg',
            height: 120,
            width: 120,
          ),
          const SizedBox(height: 40),
          ScaleTransition(
            scale: _pulseAnimation,
            child: GestureDetector(
              onTap: () => service.runTest(),
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF00E5FF), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00E5FF).withOpacity(0.2),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF00E5FF).withOpacity(0.05),
                    ),
                    child: const Center(
                      child: Text(
                        'GO',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF00E5FF),
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 60),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF16162D),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.router, size: 16, color: Color(0xFF00E5FF)),
                const SizedBox(width: 8),
                const Text(
                  'San Francisco, CA - Cloudflare',
                  style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRunningState(BuildContext context, SpeedTestService service) {
    return Column(
      key: const ValueKey('running'),
      children: [
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: MetricCard(
                  label: 'Ping',
                  value: service.ping == 0 ? '--' : service.ping.toString(),
                  unit: 'ms',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MetricCard(
                  label: 'Download',
                  value: service.downloadSpeed.toStringAsFixed(2),
                  unit: 'Mbps',
                  isHighlight: service.state == TestState.download,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MetricCard(
                  label: 'Upload',
                  value: service.uploadSpeed.toStringAsFixed(2),
                  unit: 'Mbps',
                  isHighlight: service.state == TestState.upload,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        SpeedGauge(speed: service.currentLiveSpeed),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: LinearProgressIndicator(
            value: service.progress,
            backgroundColor: Colors.white12,
            valueColor: const AlwaysStoppedAnimation(Color(0xFF00E5FF)),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildFinishedState(BuildContext context, SpeedTestService service) {
    return Center(
      key: const ValueKey('finished'),
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: const Color(0xFF16162D),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 40)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'TEST COMPLETED',
              style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1.5, color: Colors.white54),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildFinalItem('DOWNLOAD', service.downloadSpeed),
                _buildFinalItem('UPLOAD', service.uploadSpeed),
              ],
            ),
            const SizedBox(height: 32),
            const Divider(color: Colors.white10),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => service.reset(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00E5FF),
                foregroundColor: const Color(0xFF0B0B1A),
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text('TEST AGAIN', style: TextStyle(fontWeight: FontWeight.w900)),
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildFinalItem(String label, double value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.white54)),
        const SizedBox(height: 8),
        Text(
          value.toStringAsFixed(2),
          style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: Color(0xFF00E5FF)),
        ),
        const Text('Mbps', style: TextStyle(fontSize: 12, color: Colors.white54)),
      ],
    );
  }
}
