import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/code_pane.dart';
import '../widgets/side_bullets.dart';

class ComponentsSlide extends FlutterDeckSlideWidget {
  const ComponentsSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/components',
          title: 'The Flame component system',
          speakerNotes:
              '- Everything in the world is a Component\n'
              '- Components form a tree under game.world\n'
              '- Each component owns its own behavior',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.split(
      leftBuilder: (context) => const SideBullets(
        items: [
          'World holds the game scene',
          'PositionComponent has position, size, angle',
          'Components nest: the player owns its name tag',
          'add() and removeFromParent() manage the tree',
        ],
      ),
      rightBuilder: (context) => const CodePane(
        fileName: 'packages/game/lib/src/game/space_game.dart',
        code: '''
world.add(Starfield());
world.add(AsteroidField(seed: payload.seed));

final ship = PlayerShip(
  playerId: id,
  playerName: name,
  shipColor: color,
  position: spawn,
);
world.add(ship);''',
      ),
    );
  }
}
