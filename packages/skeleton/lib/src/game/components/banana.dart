import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';

import '../../game_config.dart';
import '../banana_game.dart';
import '../neon.dart';

const _yellow = Color(0xFFFFE600);

final _shape = Path()
  ..addArc(
    Rect.fromCircle(
      center: const Offset(0, -GameConfig.bananaRadius * 0.6),
      radius: GameConfig.bananaRadius,
    ),
    pi * 0.15,
    pi * 0.7,
  );

void _drawBanana(Canvas canvas) {
  Neon.stroke(canvas, _shape, _yellow, width: 4, fill: false);
}

/// A banana lying in the arena, waiting to be picked up.
class Banana extends PositionComponent {
  Banana({required super.position}) : super(anchor: Anchor.center, priority: 5);

  double _time = Random().nextDouble() * 10;

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;
    angle = sin(_time * 2) * 0.3;
    scale.setAll(1 + sin(_time * 4) * 0.08);
  }

  @override
  void render(Canvas canvas) => _drawBanana(canvas);
}

/// A banana in flight. Every client simulates every throw; the first kart it
/// reaches, other than the thrower's, takes it, and only the client driving
/// that kart spins out.
class ThrownBanana extends PositionComponent with HasGameRef<BananaGame> {
  ThrownBanana({
    required this.ownerId,
    required super.position,
    required this.velocity,
  }) : super(anchor: Anchor.center, priority: 6);

  final String ownerId;
  final Vector2 velocity;
  double _life = GameConfig.bananaFlightSeconds;

  @override
  void update(double dt) {
    super.update(dt);
    _life -= dt;
    angle += 14 * dt;
    position.addScaled(velocity, dt);
    if (_life <= 0 ||
        gameRef.hitsObstacle(position, GameConfig.bananaRadius * 0.5)) {
      removeFromParent();
      return;
    }
    for (final kart in gameRef.karts) {
      if (kart.id == ownerId ||
          kart.isSpinning ||
          !kart.touches(position, GameConfig.bananaRadius)) {
        continue;
      }
      if (kart == gameRef.player) {
        gameRef.slip();
      }
      removeFromParent();
      return;
    }
  }

  @override
  void render(Canvas canvas) => _drawBanana(canvas);
}
