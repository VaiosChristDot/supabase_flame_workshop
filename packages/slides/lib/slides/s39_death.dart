import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/code_pane.dart';
import '../widgets/side_bullets.dart';

class DeathSlide extends FlutterDeckSlideWidget {
  const DeathSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/death',
          title: 'Death and spectating',
          speakerNotes:
              '- The victim broadcasts its own death, then switches to '
              'spectating\n'
              '- The camera simply follows another player\n'
              '- Tab through remaining players',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.split(
      leftBuilder: (context) => const SideBullets(
        items: [
          'Victim broadcasts death with the killer id',
          'Everyone removes the player and plays an explosion',
          'Dead players spectate: camera.follow(target)',
        ],
      ),
      rightBuilder: (context) => const CodePane(
        fileName: 'packages/game/lib/src/game/space_game.dart',
        code: '''
void onLocalDeath(String? killerId) {
  net.send(
    NetEvent.death,
    DeathPayload(id: myId, killerId: killerId).toJson(),
  );
  round?.alive.remove(myId);
  world.add(Explosion(position: ship.position.clone(), ...));
  ship.removeFromParent();
  _setPhase(GamePhase.spectating);
  _spectateByIndex(0);
  _checkRoundEnd();
}''',
      ),
    );
  }
}
