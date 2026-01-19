import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 40,
    this.showWordmark = false,
  });

  final double size;
  final bool showWordmark;

  @override
  Widget build(BuildContext context) {
    final mark = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(size * 0.28),
        border: Border.all(color: AppColors.navySoft.withValues(alpha: 0.25)),
      ),
      child: Center(
        child: SizedBox(
          width: size * 0.60,
          height: size * 0.60,
          child: CustomPaint(
            painter: _DotsPainter(),
          ),
        ),
      ),
    );

    if (!showWordmark) return mark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        mark,
        const SizedBox(width: 10),
        Text(
          'Connecting Dots',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
        ),
      ],
    );
  }
}

class _DotsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final dotPaint = Paint()..color = AppColors.textOnDark;
    final linePaint = Paint()
      ..color = AppColors.accentSoft.withValues(alpha: 0.85)
      ..strokeWidth = size.shortestSide * 0.08
      ..strokeCap = StrokeCap.round;

    final p1 = Offset(size.width * 0.20, size.height * 0.35);
    final p2 = Offset(size.width * 0.55, size.height * 0.25);
    final p3 = Offset(size.width * 0.70, size.height * 0.62);
    final p4 = Offset(size.width * 0.35, size.height * 0.75);

    canvas.drawLine(p1, p2, linePaint);
    canvas.drawLine(p2, p3, linePaint);
    canvas.drawLine(p3, p4, linePaint);

    final r = size.shortestSide * 0.11;
    canvas.drawCircle(p1, r, dotPaint);
    canvas.drawCircle(p2, r, dotPaint);
    canvas.drawCircle(p3, r, dotPaint);
    canvas.drawCircle(p4, r, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
