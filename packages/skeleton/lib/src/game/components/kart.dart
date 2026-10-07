import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/painting.dart' show Shadow, TextStyle;
import 'package:flutter/services.dart';

import '../../game_config.dart';
import '../../net/arena_payloads.dart';
import '../banana_game.dart';
import '../neon.dart';
import 'banana.dart';

abstract class Kart extends PositionComponent {
  Kart({
    required this.id,
    required this.name,
    required this.color,
    required super.position,
  }) : super(anchor: Anchor.center, priority: 10);

  static const radius = GameConfig.playerRadius;

  final String id;
  final String name;
  final Color color;
  final velocity = Vector2.zero();
  double heading = -pi / 2;

  late final _label = TextPaint(
    style: TextStyle(
      color: color,
      fontSize: 11,
      fontWeight: FontWeight.w600,
      shadows: [Shadow(color: color, blurRadius: 8)],
    ),
  );

  static final _body = Path()
    ..moveTo(radius, 0)
    ..lineTo(-radius * 0.8, -radius * 0.75)
    ..lineTo(-radius * 0.4, 0)
    ..lineTo(-radius * 0.8, radius * 0.75)
    ..close();

  bool get isSpinning;

  bool touches(Vector2 point, double otherRadius) =>
      position.distanceTo(point) < radius + otherRadius;

  @override
  void render(Canvas canvas) {
    canvas
      ..save()
      ..rotate(heading);
    Neon.stroke(canvas, _body, color);
    canvas.restore();
    _label.render(
      canvas,
      name,
      Vector2(0, -radius - 6),
      anchor: Anchor.bottomCenter,
    );
  }
}

/// The kart this client drives, and the only one it simulates.
class PlayerKart extends Kart with HasGameRef<BananaGame>, KeyboardHandler {
  PlayerKart({
    required super.id,
    required super.name,
    required super.color,
    required super.position,
  });

  final _input = Vector2.zero();
  double _spinTime = 0;
  double _sinceSync = 0;
  double _sinceSend = 0;
  final _lastSentPosition = Vector2.zero();
  double _lastSentHeading = 0;

  @override
  bool get isSpinning => _spinTime > 0;

  Vector2 get facing => Vector2(cos(heading), sin(heading));

  void spinOut() => _spinTime = GameConfig.spinOutSeconds;

  bool collects(Banana banana) =>
      !isSpinning && touches(banana.position, GameConfig.bananaRadius);

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    int held(LogicalKeyboardKey key) => keysPressed.contains(key) ? 1 : 0;
    _input.setValues(
      (held(LogicalKeyboardKey.keyD) - held(LogicalKeyboardKey.keyA))
          .toDouble(),
      (held(LogicalKeyboardKey.keyS) - held(LogicalKeyboardKey.keyW))
          .toDouble(),
    );
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.space) {
      gameRef.throwBanana();
    }
    return true;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isSpinning) {
      _spinTime -= dt;
      heading += 14 * dt;
      velocity.scale(pow(0.15, dt).toDouble());
    } else {
      final steer = _input.isZero() ? Vector2.zero() : _input.normalized();
      final delta = steer * GameConfig.playerMaxSpeed - velocity;
      final maxStep = GameConfig.kartAcceleration * dt;
      if (delta.length > maxStep) {
        delta.scaleTo(maxStep);
      }
      velocity.add(delta);
      if (velocity.length2 > 100) {
        heading = atan2(velocity.y, velocity.x);
      }
    }
    position.addScaled(velocity, dt);
    gameRef.resolveCollisions(position, velocity, Kart.radius);
    _broadcastState(dt);
  }

  void _broadcastState(double dt) {
    _sinceSync += dt;
    _sinceSend += dt;
    if (_sinceSync < GameConfig.stateSyncInterval) {
      return;
    }
    _sinceSync = 0;
    final moved =
        position.distanceTo(_lastSentPosition) > 0.5 ||
        (heading - _lastSentHeading).abs() > 0.01;
    if (!moved && _sinceSend < GameConfig.keepaliveInterval) {
      return;
    }
    _sinceSend = 0;
    _lastSentPosition.setFrom(position);
    _lastSentHeading = heading;
    gameRef.sendState(
      KartState(
        id: id,
        x: position.x,
        y: position.y,
        vx: velocity.x,
        vy: velocity.y,
        heading: heading,
        spinning: isSpinning,
      ),
    );
  }
}

/// Another racer, drawn where their client says they are.
class RemoteKart extends Kart {
  RemoteKart({required super.id, required super.name, required super.color})
    : super(position: Vector2.zero());

  final _target = Vector2.zero();
  bool _spinning = false;
  bool _hasState = false;

  @override
  bool get isSpinning => _spinning;

  void applyState(KartState state) {
    _target.setValues(state.x, state.y);
    velocity.setValues(state.vx, state.vy);
    heading = state.heading;
    _spinning = state.spinning;
    if (!_hasState ||
        position.distanceTo(_target) > GameConfig.remoteTeleportDistance) {
      position.setFrom(_target);
    }
    _hasState = true;
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Keep moving between updates, then ease toward where they should be.
    _target.addScaled(velocity, dt);
    final t = 1 - exp(-GameConfig.remoteLerpFactorPerSecond * dt);
    position.add((_target - position)..scale(t));
    if (_spinning) {
      heading += 14 * dt;
    }
  }

  @override
  void render(Canvas canvas) {
    if (_hasState) {
      super.render(canvas);
    }
  }
}
