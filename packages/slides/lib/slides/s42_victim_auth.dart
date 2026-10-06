import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/code_pane.dart';
import '../widgets/side_bullets.dart';

class VictimAuthSlide extends FlutterDeckSlideWidget {
  const VictimAuthSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/victim-auth',
          title: 'Victim-authoritative damage',
          speakerNotes:
              '- The shooter never decides damage\n'
              '- The victim detects the hit on its own player and broadcasts '
              'the result\n'
              '- No conflicts: every player has exactly one authority',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.split(
      leftBuilder: (context) => const SideBullets(
        items: [
          'Each client owns its player and nothing else',
          'The victim applies damage locally',
          'hit carries the new hp, others just display it',
          'One authority per player, zero conflicts',
        ],
      ),
      rightBuilder: (context) => const CodePane(
        fileName: 'packages/game/lib/src/game/components/player_ship.dart',
        code: '''
@override
void onCollisionStart(
  List<Vector2> points,
  PositionComponent other,
) {
  if (other is Bullet && other.ownerId != playerId) {
    other.removeFromParent();
    hp -= GameConfig.bulletDamage;
    gameRef.net.send(
      NetEvent.hit,
      HitPayload(
        id: playerId,
        shooterId: other.ownerId,
        bulletId: other.bulletId,
        hp: hp,
      ).toJson(),
    );
  }
}''',
      ),
    );
  }
}
