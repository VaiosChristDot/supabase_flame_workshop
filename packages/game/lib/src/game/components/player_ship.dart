import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';

import '../../game_config.dart';
import '../../net/net_events.dart';
import '../../net/payloads/hit_payload.dart';
import '../../net/payloads/ship_state_payload.dart';
import '../game_phase.dart';
import '../space_game.dart';
import 'asteroid.dart';
import 'bullet.dart';
import 'ship_base.dart';
import 'storm_zone.dart';

class PlayerShip extends ShipBase
    with HasGameRef<SpaceGame>, KeyboardHandler, CollisionCallbacks {
  PlayerShip({
    required super.playerId,
    required super.playerName,
    required super.shipColor,
    required super.position,
    super.angle,
  });

  final velocity = Vector2.zero();

  bool _thrust = false;
  bool _brake = false;
  bool _left = false;
  bool _right = false;
  bool _fire = false;

  double _fireCooldown = 0;
  double _sinceSync = 0;
  double _sinceSend = 0;
  final _lastSentPosition = Vector2.zero();
  double _lastSentAngle = 0;

  @override
  void onLoad() {
    super.onLoad();
    add(CircleHitbox());
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _thrust =
        keysPressed.contains(LogicalKeyboardKey.arrowUp) ||
        keysPressed.contains(LogicalKeyboardKey.keyW);
    _brake =
        keysPressed.contains(LogicalKeyboardKey.arrowDown) ||
        keysPressed.contains(LogicalKeyboardKey.keyS);
    _left =
        keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
        keysPressed.contains(LogicalKeyboardKey.keyA);
    _right =
        keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
        keysPressed.contains(LogicalKeyboardKey.keyD);
    _fire = keysPressed.contains(LogicalKeyboardKey.space);
    return true;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (gameRef.phase.value != GamePhase.playing) {
      return;
    }
    _integrate(dt);
    _applyZoneDamage(dt);
    _handleFire(dt);
    _broadcastState(dt);
  }

  void _integrate(double dt) {
    final turn = (_right ? 1 : 0) - (_left ? 1 : 0);
    angle += turn * GameConfig.shipRotationSpeed * dt;
    if (_thrust) {
      velocity.add(direction * GameConfig.shipAcceleration * dt);
    }
    if (_brake) {
      final speed = velocity.length;
      if (speed > 0) {
        velocity.scale(
          (speed - GameConfig.shipBrake * dt).clamp(0, speed) / speed,
        );
      }
    }
    velocity.scale(1 - GameConfig.shipDrag * dt);
    if (velocity.length > GameConfig.shipMaxSpeed) {
      velocity.scaleTo(GameConfig.shipMaxSpeed);
    }
    position.add(velocity * dt);
    if (position.length > GameConfig.worldRadius) {
      position.scaleTo(GameConfig.worldRadius);
      velocity.scale(0.4);
    }
  }

  void _applyZoneDamage(double dt) {
    final round = gameRef.round;
    if (round == null) {
      return;
    }
    final radius = StormZone.radiusAt(
      round.startedAt,
      DateTime.now().millisecondsSinceEpoch,
    );
    if (position.length > radius) {
      applyDamage(GameConfig.zoneDamagePerSecond * dt, killerId: null);
    }
  }

  void _handleFire(double dt) {
    _fireCooldown -= dt;
    if (_fire && _fireCooldown <= 0) {
      _fireCooldown = GameConfig.fireCooldown;
      gameRef.fireLocalBullet();
    }
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
        (angle - _lastSentAngle).abs() > 0.01;
    if (!moved && _sinceSend < GameConfig.keepaliveInterval) {
      return;
    }
    _sinceSend = 0;
    _lastSentPosition.setFrom(position);
    _lastSentAngle = angle;
    gameRef.net.send(
      NetEvent.state,
      ShipStatePayload(
        id: playerId,
        x: position.x,
        y: position.y,
        vx: velocity.x,
        vy: velocity.y,
        rotation: angle,
        hp: hp,
      ).toJson(),
    );
  }

  void applyDamage(double amount, {required String? killerId}) {
    if (hp <= 0) {
      return;
    }
    hp -= amount;
    flash();
    gameRef.hpNotifier.value = hp;
    if (hp <= 0) {
      gameRef.onLocalDeath(killerId);
    }
  }

  @override
  void onCollisionStart(
    List<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Bullet && other.ownerId != playerId) {
      other.removeFromParent();
      if (hp <= 0) {
        return;
      }
      applyDamage(GameConfig.bulletDamage, killerId: other.ownerId);
      gameRef.net.send(
        NetEvent.hit,
        HitPayload(
          id: playerId,
          shooterId: other.ownerId,
          bulletId: other.bulletId,
          hp: hp,
        ).toJson(),
      );
    } else if (other is Asteroid) {
      final normal = (position - other.position)..normalize();
      velocity.reflect(normal);
      velocity.scale(0.8);
      position.add(normal * 4);
      applyDamage(GameConfig.asteroidBumpDamage, killerId: null);
    }
  }
}
