import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/code_pane.dart';
import '../widgets/side_bullets.dart';

class DeadReckoningSlide extends FlutterDeckSlideWidget {
  const DeadReckoningSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/dead-reckoning',
          title: 'Dead reckoning: smooth remote players',
          speakerNotes:
              '- Between packets, keep moving the player by its last velocity\n'
              '- Ease the rendered position toward the advancing target\n'
              '- Teleport when the error is too large, for example after a '
              'tab was backgrounded',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.split(
      leftBuilder: (context) => const SideBullets(
        items: [
          'Advance target and render position by velocity',
          'Ease toward the target: min(1, dt * 12)',
          'Teleport past a 200 pixel error',
          '20 Hz in, 60 FPS out',
        ],
      ),
      rightBuilder: (context) => const CodePane(
        fileName: 'packages/game/lib/src/game/components/remote_ship.dart',
        code: '''
@override
void update(double dt) {
  super.update(dt);
  _target.add(velocity * dt);
  position.add(velocity * dt);
  final factor =
      min(1.0, dt * GameConfig.remoteLerpFactorPerSecond);
  position.add((_target - position) * factor);
  angle +=
      (_targetAngle - angle).toNormalizedAngle() * factor;
}''',
      ),
    );
  }
}
