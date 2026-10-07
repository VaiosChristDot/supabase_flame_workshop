import 'dart:math';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../db/player_stats.dart';
import '../game/banana_game.dart';

const _yellow = Color(0xFFFFE600);

class GameScreen extends StatefulWidget {
  const GameScreen({required this.playerName, super.key});

  final String playerName;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final BananaGame game;

  @override
  void initState() {
    super.initState();
    final client = Supabase.instance.client;
    final random = Random();
    game = BananaGame(
      // Without a session the game still runs; it just saves nothing.
      playerId:
          client.auth.currentUser?.id ??
          [for (var i = 0; i < 16; i++) random.nextInt(16).toRadixString(16)]
              .join(),
      playerName: widget.playerName,
      stats: PlayerStats(client),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          GameWidget(game: game),
          Positioned(top: 16, left: 16, child: Hud(game: game)),
          Positioned(
            top: 16,
            right: 16,
            child: IconButton(
              tooltip: 'Leave',
              color: Colors.white70,
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 16,
            child: Text(
              'WASD to drive  ·  SPACE to throw a banana',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white38, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class Hud extends StatelessWidget {
  const Hud({required this.game, super.key});

  final BananaGame game;

  static TextStyle _glow(Color color, double size) => TextStyle(
    color: color,
    fontSize: size,
    fontWeight: FontWeight.w700,
    shadows: [Shadow(color: color, blurRadius: 12)],
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(game.playerName, style: _glow(game.playerColor, 22)),
        const SizedBox(height: 4),
        ValueListenableBuilder<int>(
          valueListenable: game.bananasHeld,
          builder: (context, count, _) =>
              Text('BANANAS  $count', style: _glow(_yellow, 16)),
        ),
        const SizedBox(height: 4),
        ValueListenableBuilder<int>(
          valueListenable: game.racersOnline,
          builder: (context, count, _) => Text(
            '$count ONLINE',
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ),
      ],
    );
  }
}
