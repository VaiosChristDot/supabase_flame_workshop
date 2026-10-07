import 'dart:ui';

import 'package:flame/components.dart';

class Obstacle extends PositionComponent {
  Obstacle({required this.rect})
    : super(
        position: Vector2(rect.left, rect.top),
        size: Vector2(rect.width, rect.height),
        priority: 1,
      );

  /// The obstacle's bounds in world space, used for collisions.
  final Rect rect;

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Offset.zero & size.toSize(),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFFFFFFFF),
    );
  }
}
