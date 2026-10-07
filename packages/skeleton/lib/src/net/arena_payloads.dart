enum ArenaEvent { state, throwBanana, pickup, hello, bananas }

/// What each racer shares through Presence.
class RacerPresence {
  const RacerPresence({
    required this.id,
    required this.name,
    required this.colorIndex,
  });

  factory RacerPresence.fromJson(Map<String, dynamic> json) {
    return RacerPresence(
      id: json['id'] as String,
      name: json['name'] as String,
      colorIndex: json['color'] as int,
    );
  }

  static bool isValid(Map<String, dynamic> json) =>
      json['id'] is String && json['name'] is String && json['color'] is int;

  final String id;
  final String name;
  final int colorIndex;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'color': colorIndex,
  };
}

class KartState {
  const KartState({
    required this.id,
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.heading,
    required this.spinning,
  });

  factory KartState.fromJson(Map<String, dynamic> json) {
    return KartState(
      id: json['id'] as String,
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      vx: (json['vx'] as num).toDouble(),
      vy: (json['vy'] as num).toDouble(),
      heading: (json['h'] as num).toDouble(),
      spinning: json['spin'] as bool,
    );
  }

  final String id;
  final double x;
  final double y;
  final double vx;
  final double vy;
  final double heading;
  final bool spinning;

  Map<String, dynamic> toJson() => {
    'id': id,
    'x': x,
    'y': y,
    'vx': vx,
    'vy': vy,
    'h': heading,
    'spin': spinning,
  };
}

class ThrowPayload {
  const ThrowPayload({
    required this.id,
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
  });

  factory ThrowPayload.fromJson(Map<String, dynamic> json) {
    return ThrowPayload(
      id: json['id'] as String,
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      vx: (json['vx'] as num).toDouble(),
      vy: (json['vy'] as num).toDouble(),
    );
  }

  final String id;
  final double x;
  final double y;
  final double vx;
  final double vy;

  Map<String, dynamic> toJson() => {
    'id': id,
    'x': x,
    'y': y,
    'vx': vx,
    'vy': vy,
  };
}

/// Banana [index] has been picked up [generation] times. Each generation has
/// a fixed spot, so every client moves it to the same place.
class PickupPayload {
  const PickupPayload({required this.index, required this.generation});

  factory PickupPayload.fromJson(Map<String, dynamic> json) {
    return PickupPayload(index: json['i'] as int, generation: json['g'] as int);
  }

  final int index;
  final int generation;

  Map<String, dynamic> toJson() => {'i': index, 'g': generation};
}
