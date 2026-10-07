import 'package:flutter/material.dart';

class GameConfig {
  static const worldRadius = 900.0;

  static const playerMaxSpeed = 240.0;
  static const playerAcceleration = 320.0;
  static const playerBrake = 480.0;
  static const playerDrag = 0.6;
  static const playerRotationSpeed = 3.5;
  static const playerMaxHp = 100.0;
  static const playerRadius = 14.0;

  static const fireCooldown = 0.25;
  static const bulletSpeed = 420.0;
  static const bulletTtl = 1.4;
  static const bulletDamage = 15.0;
  static const obstacleBumpDamage = 5.0;

  static const stateSyncInterval = 0.05;
  static const keepaliveInterval = 1.0;
  static const remoteLerpFactorPerSecond = 12.0;
  static const remoteTeleportDistance = 200.0;

  static const obstacleCount = 60;
  static const spawnRadius = 600.0;

  static const countdownSeconds = 3;
  static const roundOverSeconds = 6;

  static const kartAcceleration = 900.0;
  static const bananaCount = 25;
  static const bananaRadius = 10.0;
  static const bananaThrowSpeed = 560.0;
  static const bananaFlightSeconds = 0.9;
  static const spinOutSeconds = 1.6;

  static const neonColors = [
    Color(0xFF00F0FF),
    Color(0xFFFF2BD6),
    Color(0xFF39FF14),
    Color(0xFFFF6B1A),
    Color(0xFF9D4BFF),
    Color(0xFFFF3B5C),
  ];

  static const playerColors = [
    Color(0xFF4FC3F7),
    Color(0xFFFF8A65),
    Color(0xFFAED581),
    Color(0xFFBA68C8),
    Color(0xFFFFD54F),
    Color(0xFFF06292),
    Color(0xFF4DB6AC),
    Color(0xFF90A4AE),
  ];
}
