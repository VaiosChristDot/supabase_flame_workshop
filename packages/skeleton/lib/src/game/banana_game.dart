import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';

import '../db/player_stats.dart';
import '../env.dart';
import '../game_config.dart';
import '../net/arena_net.dart';
import '../net/arena_payloads.dart';
import 'components/arena.dart';
import 'components/banana.dart';
import 'components/kart.dart';
import 'components/obstacle.dart';

/// A shared arena: drive with WASD, collect bananas, throw them with Space.
///
/// Every client builds the same obstacles and banana spots from the room
/// name, so only movement, throws and pickups travel over Realtime.
class BananaGame extends FlameGame with HasKeyboardHandlerComponents {
  BananaGame({
    required this.playerId,
    required this.playerName,
    required this.stats,
  }) : colorIndex = Random().nextInt(GameConfig.neonColors.length),
       super(
         camera: CameraComponent.withFixedResolution(width: 960, height: 540),
       ) {
    net = ArenaNet(
      me: RacerPresence(id: playerId, name: playerName, colorIndex: colorIndex),
    );
  }

  final String playerId;
  final String playerName;
  final int colorIndex;
  final PlayerStats stats;
  late final ArenaNet net;

  final racersOnline = ValueNotifier<int>(1);
  final obstacles = <Rect>[];
  final bananas = <Banana>[];
  final _generations = List.filled(GameConfig.bananaCount, 0);
  final remotes = <String, RemoteKart>{};
  late final PlayerKart player;

  late final int _seed = Env.room.codeUnits.fold(
    17,
    (hash, unit) => (hash * 31 + unit) & 0x7FFFFFFF,
  );
  double _sinceFlush = 0;

  Color get playerColor => GameConfig.neonColors[colorIndex];

  ValueListenable<int> get bananasHeld => stats.owned;

  @override
  Color backgroundColor() => const Color(0xFF000000);

  @override
  Future<void> onLoad() async {
    world.add(Arena());
    _placeObstacles();
    for (var i = 0; i < GameConfig.bananaCount; i++) {
      final banana = Banana(position: _bananaSpot(i, 0));
      bananas.add(banana);
      world.add(banana);
    }
    player = PlayerKart(
      id: playerId,
      name: playerName,
      color: playerColor,
      position: randomFreeSpot(Random()),
    );
    world.add(player);
    camera.follow(player);

    await stats.join(playerName);
    net
      ..onRacersChanged = _onRacersChanged
      ..onState = _onState
      ..onThrow = _onThrow
      ..onPickup = _onPickup
      ..onHello = _onHello
      ..onBananas = _onBananas
      ..connect();
  }

  void _onState(KartState state) => remotes[state.id]?.applyState(state);

  void _onPickup(PickupPayload pickup) =>
      _setGeneration(pickup.index, pickup.generation);

  void _onHello() => net.send(ArenaEvent.bananas, {'g': _generations});

  void _onBananas(List<int> generations) {
    for (var i = 0; i < generations.length && i < bananas.length; i++) {
      _setGeneration(i, generations[i]);
    }
  }

  @override
  void onRemove() {
    unawaited(stats.flush());
    unawaited(net.dispose());
    super.onRemove();
  }

  @override
  void update(double dt) {
    super.update(dt);
    for (var i = 0; i < bananas.length; i++) {
      if (player.collects(bananas[i])) {
        final generation = _generations[i] + 1;
        _setGeneration(i, generation);
        stats.collect();
        net.send(
          ArenaEvent.pickup,
          PickupPayload(index: i, generation: generation).toJson(),
        );
      }
    }
    _sinceFlush += dt;
    if (_sinceFlush >= 1) {
      _sinceFlush = 0;
      unawaited(stats.flush());
    }
  }

  Iterable<Kart> get karts sync* {
    yield player;
    yield* remotes.values;
  }

  void sendState(KartState state) => net.send(ArenaEvent.state, state.toJson());

  void throwBanana() {
    if (bananasHeld.value == 0 || player.isSpinning) {
      return;
    }
    stats.spend();
    final facing = player.facing;
    final payload = ThrowPayload(
      id: playerId,
      x: player.position.x + facing.x * (Kart.radius + 12),
      y: player.position.y + facing.y * (Kart.radius + 12),
      vx: facing.x * GameConfig.bananaThrowSpeed + player.velocity.x * 0.5,
      vy: facing.y * GameConfig.bananaThrowSpeed + player.velocity.y * 0.5,
    );
    net.send(ArenaEvent.throwBanana, payload.toJson());
    _onThrow(payload);
  }

  /// Each client decides for itself whether it slipped.
  void slip() {
    player.spinOut();
    stats.slip();
  }

  void _onThrow(ThrowPayload payload) {
    world.add(
      ThrownBanana(
        ownerId: payload.id,
        position: Vector2(payload.x, payload.y),
        velocity: Vector2(payload.vx, payload.vy),
      ),
    );
  }

  void _onRacersChanged(List<RacerPresence> racers) {
    racersOnline.value = racers.length;
    final others = {
      for (final racer in racers)
        if (racer.id != playerId) racer.id: racer,
    };
    remotes.removeWhere((id, kart) {
      if (others.containsKey(id)) {
        return false;
      }
      kart.removeFromParent();
      return true;
    });
    for (final racer in others.values) {
      if (remotes.containsKey(racer.id)) {
        continue;
      }
      final kart = RemoteKart(
        id: racer.id,
        name: racer.name,
        color: GameConfig
            .neonColors[racer.colorIndex % GameConfig.neonColors.length],
      );
      remotes[racer.id] = kart;
      world.add(kart);
    }
  }

  void _setGeneration(int index, int generation) {
    if (index < 0 ||
        index >= bananas.length ||
        generation <= _generations[index]) {
      return;
    }
    _generations[index] = generation;
    bananas[index].position = _bananaSpot(index, generation);
  }

  Vector2 _bananaSpot(int index, int generation) =>
      randomFreeSpot(Random(_seed + index * 7919 + generation * 104729));

  void _placeObstacles() {
    final random = Random(_seed);
    const half = GameConfig.worldRadius - 60;
    for (var i = 0; i < GameConfig.obstacleCount; i++) {
      final center = Vector2(
        (random.nextDouble() * 2 - 1) * half,
        (random.nextDouble() * 2 - 1) * half,
      );
      final width = 30 + random.nextDouble() * 90;
      final height = 30 + random.nextDouble() * 90;
      // Keep the middle of the arena open.
      if (center.length < 160) {
        continue;
      }
      final rect = Rect.fromCenter(
        center: center.toOffset(),
        width: width,
        height: height,
      );
      obstacles.add(rect);
      world.add(Obstacle(rect: rect));
    }
  }

  Vector2 randomFreeSpot(Random random) {
    const half = GameConfig.worldRadius - 40;
    var spot = Vector2.zero();
    for (var attempt = 0; attempt < 50; attempt++) {
      spot = Vector2(
        (random.nextDouble() * 2 - 1) * half,
        (random.nextDouble() * 2 - 1) * half,
      );
      if (!hitsObstacle(spot, 30)) {
        break;
      }
    }
    return spot;
  }

  bool hitsObstacle(Vector2 point, double radius) {
    if (point.x.abs() > GameConfig.worldRadius - radius ||
        point.y.abs() > GameConfig.worldRadius - radius) {
      return true;
    }
    return obstacles.any(
      (rect) => rect.inflate(radius).contains(point.toOffset()),
    );
  }

  /// Pushes a circle out of every obstacle and the arena wall, and removes
  /// the part of its velocity that drives into them, so it slides along.
  void resolveCollisions(Vector2 position, Vector2 velocity, double radius) {
    for (final rect in obstacles) {
      final dx = position.x - position.x.clamp(rect.left, rect.right);
      final dy = position.y - position.y.clamp(rect.top, rect.bottom);
      final distanceSquared = dx * dx + dy * dy;
      if (distanceSquared >= radius * radius) {
        continue;
      }
      final Vector2 normal;
      double depth;
      if (distanceSquared == 0) {
        // The center is inside the rect: leave through the nearest side.
        final exits = {
          Vector2(-1, 0): position.x - rect.left,
          Vector2(1, 0): rect.right - position.x,
          Vector2(0, -1): position.y - rect.top,
          Vector2(0, 1): rect.bottom - position.y,
        }.entries.reduce((a, b) => a.value < b.value ? a : b);
        normal = exits.key;
        depth = exits.value + radius;
      } else {
        final distance = sqrt(distanceSquared);
        normal = Vector2(dx / distance, dy / distance);
        depth = radius - distance;
      }
      position.addScaled(normal, depth);
      final into = velocity.dot(normal);
      if (into < 0) {
        velocity.addScaled(normal, -into);
      }
    }
    const limit = GameConfig.worldRadius - Kart.radius;
    if (position.x.abs() > limit) {
      position.x = position.x.clamp(-limit, limit);
      velocity.x = 0;
    }
    if (position.y.abs() > limit) {
      position.y = position.y.clamp(-limit, limit);
      velocity.y = 0;
    }
  }
}
