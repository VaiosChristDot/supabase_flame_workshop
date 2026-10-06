import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/code_pane.dart';
import '../widgets/side_bullets.dart';

class ShootingSlide extends FlutterDeckSlideWidget {
  const ShootingSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/shooting',
          title: 'Shooting across the network',
          speakerNotes:
              '- One shoot event, then every client simulates the bullet\n'
              '- Straight line plus time to live: fully deterministic\n'
              '- bulletId lets a later hit event remove the exact bullet',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.split(
      leftBuilder: (context) => const SideBullets(
        items: [
          'Broadcast origin and direction once',
          'Everyone simulates the same trajectory',
          'bulletId = ownerId + counter',
          'No per-frame bullet sync needed',
        ],
      ),
      rightBuilder: (context) => const CodePane(
        fileName: 'packages/game/lib/src/game/space_game.dart',
        code: '''
final bulletId = '\$myId-\${_bulletCounter++}';
final start = ship.position +
    direction * (GameConfig.shipRadius + 8);
_spawnBullet(bulletId: bulletId, ownerId: myId, ...);
net.send(
  NetEvent.shoot,
  ShootPayload(
    id: myId,
    bulletId: bulletId,
    x: start.x,
    y: start.y,
    dx: direction.x,
    dy: direction.y,
  ).toJson(),
);''',
      ),
    );
  }
}
