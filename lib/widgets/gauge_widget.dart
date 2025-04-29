import 'dart:math';
import 'package:flutter/material.dart';

class GaugeWidget extends StatelessWidget {
  final String title;
  final double value;
  final String unit;
  final double minValue;
  final double maxValue;
  final List<Color> gradient;

  const GaugeWidget({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
    required this.minValue,
    required this.maxValue,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 150,
              width: 150,
              child: CustomPaint(
                painter: GaugePainter(
                  value: value,
                  minValue: minValue,
                  maxValue: maxValue,
                  gradient: gradient,
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        value.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        unit,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GaugePainter extends CustomPainter {
  final double value;
  final double minValue;
  final double maxValue;
  final List<Color> gradient;

  GaugePainter({
    required this.value,
    required this.minValue,
    required this.maxValue,
    required this.gradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) * 0.8 / 2;

    final rect = Rect.fromCircle(center: center, radius: radius);

    // Determine the position of value within range
    final valueRatio = (value - minValue) / (maxValue - minValue);
    final valueRadians = pi +
        valueRatio * pi; // start from left (180°), sweep up to right (360°)

    // Background track
    final trackPaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect,
      pi, // start at 180°
      pi, // end at 360°
      false,
      trackPaint,
    );

    // Value indicator with gradient
    final gradientPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        colors: gradient,
        startAngle: pi,
        endAngle: 2 * pi,
        tileMode: TileMode.clamp,
      ).createShader(rect);

    canvas.drawArc(
      rect,
      pi, // start at 180°
      pi * valueRatio, // sweep based on value
      false,
      gradientPaint,
    );

    // Draw ticks
    final tickPaint = Paint()
      ..color = Colors.grey[600]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (int i = 0; i <= 10; i++) {
      final angle = pi + (i / 10) * pi;
      final outerPoint = Offset(
        center.dx + cos(angle) * (radius + 5),
        center.dy + sin(angle) * (radius + 5),
      );
      final innerPoint = Offset(
        center.dx + cos(angle) * (radius - 5),
        center.dy + sin(angle) * (radius - 5),
      );

      if (i % 5 == 0) {
        // Major tick
        tickPaint.strokeWidth = 2;
        canvas.drawLine(innerPoint, outerPoint, tickPaint);

        // Label
        final tickValue = minValue + (i / 10) * (maxValue - minValue);
        final textPainter = TextPainter(
          text: TextSpan(
            text: tickValue.toInt().toString(),
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 10,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();

        final textPoint = Offset(
          center.dx + cos(angle) * (radius + 15) - textPainter.width / 2,
          center.dy + sin(angle) * (radius + 15) - textPainter.height / 2,
        );

        textPainter.paint(canvas, textPoint);
      } else {
        // Minor tick
        tickPaint.strokeWidth = 1;
        canvas.drawLine(
          Offset(
            center.dx + cos(angle) * radius,
            center.dy + sin(angle) * radius,
          ),
          outerPoint,
          tickPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(GaugePainter oldDelegate) {
    return oldDelegate.value != value;
  }
}
