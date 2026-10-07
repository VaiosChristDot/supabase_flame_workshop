import 'dart:ui';

import 'package:flame/components.dart';

import '../../game_config.dart';

/// A faint grid so movement reads on the black floor, plus the white wall.
class Arena extends Component {
  static const _gridStep = 60.0;

  @override
  int get priority => 0;

  @override
  void render(Canvas canvas) {
    const half = GameConfig.worldRadius;
    final grid = Paint()
      ..color = const Color(0x14FFFFFF)
      ..strokeWidth = 1;
    for (var x = -half; x <= half; x += _gridStep) {
      canvas.drawLine(Offset(x, -half), Offset(x, half), grid);
    }
    for (var y = -half; y <= half; y += _gridStep) {
      canvas.drawLine(Offset(-half, y), Offset(half, y), grid);
    }
    canvas.drawRect(
      Rect.fromLTRB(-half, -half, half, half),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..color = const Color(0xFFFFFFFF),
    );
  }
}
