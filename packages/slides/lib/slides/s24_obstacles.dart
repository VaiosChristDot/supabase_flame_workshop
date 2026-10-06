import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/code_pane.dart';
import '../widgets/side_bullets.dart';

class ObstaclesSlide extends FlutterDeckSlideWidget {
  const ObstaclesSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/obstacles',
          title: 'A world from one integer',
          speakerNotes:
              '- Random(seed) is deterministic across platforms\n'
              '- Same iteration order means identical worlds\n'
              '- Rejection sampling keeps spawn slots clear',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.split(
      leftBuilder: (context) => const SideBullets(
        items: [
          'Random(seed) yields the same sequence everywhere',
          'Fixed iteration order, no local state',
          'Reject positions near the spawn ring',
        ],
      ),
      rightBuilder: (context) => const CodePane(
        fileName: 'packages/game/lib/src/game/components/asteroid_field.dart',
        code: '''
final random = Random(seed);
while (placed < GameConfig.asteroidCount) {
  final distance = 150 +
      random.nextDouble() * (GameConfig.worldRadius - 180);
  final direction = random.nextDouble() * 2 * pi;
  if ((distance - GameConfig.spawnRadius).abs() < 80) {
    continue;
  }
  final radius = 16 + random.nextDouble() * 32;
  add(Asteroid(position: position, radius: radius, ...));
  placed++;
}''',
      ),
    );
  }
}
