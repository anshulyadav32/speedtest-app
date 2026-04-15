import 'dart:math';
import 'package:flutter/material.dart';

class SpeedGauge extends StatelessWidget {
  final double speed;
  final double maxSpeed;

  const SpeedGauge({
    super.key,
    required this.speed,
    this.maxSpeed = 100.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 320,
          height: 220,
          child: CustomPaint(
            painter: GaugePainter(
              speed: speed,
              maxSpeed: maxSpeed,
              accentColor: const Color(0xFF00E5FF),
              glowColor: const Color(0xFF00E5FF).withOpacity(0.5),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: const Alignment(0, 0.4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        speed.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Montserrat',
                          letterSpacing: -2,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Mbps',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.5),
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class GaugePainter extends CustomPainter {
  final double speed;
  final double maxSpeed;
  final Color accentColor;
  final Color glowColor;

  GaugePainter({
    required this.speed,
    required this.maxSpeed,
    required this.accentColor,
    required this.glowColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    final Offset center = Offset(size.width / 2, size.height - 20);
    final Rect arcRect = Rect.fromCircle(center: center, radius: radius - 30);
    
    // 1. Background arc track
    final Paint trackPaint = Paint()
      ..color = const Color(0xFF16162D).withOpacity(0.5)
      ..strokeWidth = 24
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(arcRect, pi, pi, false, trackPaint);

    // 2. Subtle outer glow for the active part
    final double sweepAngle = (speed / maxSpeed).clamp(0.0, 1.0) * pi;
    
    if (speed > 0.1) {
      final Paint glowPaint = Paint()
        ..color = glowColor
        ..strokeWidth = 32
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);

      canvas.drawArc(arcRect, pi, sweepAngle, false, glowPaint);
    }

    // 3. Active progress arc
    final Paint progressPaint = Paint()
      ..shader = LinearGradient(
        colors: [const Color(0xFF0066FF), accentColor, Colors.white],
        stops: const [0.0, 0.8, 1.0],
      ).createShader(arcRect)
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(arcRect, pi, sweepAngle, false, progressPaint);

    // 4. Scale markers
    final Paint markerPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..strokeWidth = 2;

    for (int i = 0; i <= 10; i++) {
      final double angle = pi + (i / 10) * pi;
      final double innerR = radius - 55;
      final double outerR = radius - 45;
      
      canvas.drawLine(
        Offset(center.dx + innerR * cos(angle), center.dy + innerR * sin(angle)),
        Offset(center.dx + outerR * cos(angle), center.dy + outerR * sin(angle)),
        markerPaint..color = (i / 10 * maxSpeed <= speed) ? accentColor : Colors.white.withOpacity(0.2),
      );
    }

    // 5. High-fidelity Needle
    final double needleAngle = pi + sweepAngle;
    
    // Needle shadow
    final Paint shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..strokeWidth = 4
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    
    canvas.drawLine(
      center,
      Offset(center.dx + (radius - 40) * cos(needleAngle) + 2, center.dy + (radius - 40) * sin(needleAngle) + 2),
      shadowPaint,
    );

    // Needle body
    final Paint needlePaint = Paint()
      ..color = accentColor
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final Offset needleEnd = Offset(
      center.dx + (radius - 40) * cos(needleAngle),
      center.dy + (radius - 40) * sin(needleAngle),
    );

    canvas.drawLine(center, needleEnd, needlePaint);
    
    // Center hub
    canvas.drawCircle(center, 12, Paint()..color = const Color(0xFF16162D));
    canvas.drawCircle(center, 8, Paint()..color = accentColor);
    canvas.drawCircle(center, 4, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant GaugePainter oldDelegate) {
    return true;
  }
}
