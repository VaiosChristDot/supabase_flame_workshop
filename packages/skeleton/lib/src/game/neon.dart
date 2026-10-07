import 'dart:ui';

/// Draws shapes as glowing neon tubes on a dark background.
abstract final class Neon {
  static const _white = Color(0xFFFFFFFF);

  static void stroke(
    Canvas canvas,
    Path path,
    Color color, {
    double width = 2.5,
    bool fill = true,
  }) {
    if (fill) {
      canvas.drawPath(path, Paint()..color = color.withValues(alpha: 0.15));
    }
    canvas
      ..drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = width * 4
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..color = color.withValues(alpha: 0.6)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
      )
      ..drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = width
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..color = color,
      )
      ..drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = width * 0.4
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..color = Color.lerp(color, _white, 0.7)!,
      );
  }
}
