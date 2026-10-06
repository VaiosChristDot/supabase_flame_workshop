import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/code_pane.dart';
import '../widgets/side_bullets.dart';

class PlayerSlide extends FlutterDeckSlideWidget {
  const PlayerSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/player',
          title: 'Building the player',
          speakerNotes:
              '- The player accelerates along its facing direction\n'
              '- Drag and a speed cap keep it controllable\n'
              '- The same base class renders local and remote players',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.split(
      leftBuilder: (context) => const SideBullets(
        items: [
          'Velocity integration in update',
          'Accelerate along the facing direction, drag against motion',
          'Speed cap keeps the game fair',
        ],
      ),
      rightBuilder: (context) => const CodePane(
        fileName: 'packages/game/lib/src/game/components/player_ship.dart',
        code: '''
void _integrate(double dt) {
  final turn = (_right ? 1 : 0) - (_left ? 1 : 0);
  angle += turn * GameConfig.shipRotationSpeed * dt;
  if (_thrust) {
    velocity.add(
      direction * GameConfig.shipAcceleration * dt,
    );
  }
  velocity.scale(1 - GameConfig.shipDrag * dt);
  if (velocity.length > GameConfig.shipMaxSpeed) {
    velocity.scaleTo(GameConfig.shipMaxSpeed);
  }
  position.add(velocity * dt);
}''',
      ),
    );
  }
}
