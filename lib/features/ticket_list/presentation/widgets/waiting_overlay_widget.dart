// ---------------------------------------------------------------------------
// Waiting Overlay
// ---------------------------------------------------------------------------
import 'package:bullatech/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class WaitingOverlay extends StatelessWidget {
  final Animation<double> pulseAnim;
  final Animation<double> ringAnim;
  const WaitingOverlay(
      {super.key, required this.pulseAnim, required this.ringAnim});

  @override
  Widget build(final BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: 240,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: AnimatedBuilder(
                animation: Listenable.merge([pulseAnim, ringAnim]),
                builder: (final _, final __) => CustomPaint(
                  painter: _RadarPainter(
                    ringProgress: ringAnim.value,
                    pulseOpacity: pulseAnim.value,
                  ),
                  child: Center(
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.surfaceMaps,
                        border:
                            Border.all(color: AppColors.borderMaps, width: 1.5),
                      ),
                      child: const Icon(Icons.local_shipping_rounded,
                          color: AppColors.info, size: 24),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.surfaceMaps.withOpacity(0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Ready to go',
                style: TextStyle(
                  color: AppColors.textPrimaryMaps,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RadarPainter extends CustomPainter {
  final double ringProgress;
  final double pulseOpacity;
  _RadarPainter({required this.ringProgress, required this.pulseOpacity});

  @override
  void paint(final Canvas canvas, final Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxR = size.width / 2;
    for (final f in [0.55, 0.78, 1.0]) {
      canvas.drawCircle(
          center,
          maxR * f,
          Paint()
            ..color = AppColors.info.withOpacity(0.08)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1);
    }
    canvas.drawCircle(
        center,
        maxR * ringProgress,
        Paint()
          ..color = AppColors.info.withOpacity((1 - ringProgress) * 0.4)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5);
    canvas.drawCircle(
        center,
        28,
        Paint()
          ..color = AppColors.info.withOpacity(pulseOpacity * 0.15)
          ..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(final _RadarPainter old) =>
      old.ringProgress != ringProgress || old.pulseOpacity != pulseOpacity;
}
