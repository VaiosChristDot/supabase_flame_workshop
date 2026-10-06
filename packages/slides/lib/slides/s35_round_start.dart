import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/code_pane.dart';
import '../widgets/side_bullets.dart';

class RoundStartSlide extends FlutterDeckSlideWidget {
  const RoundStartSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/round-start',
          title: 'Starting a round',
          speakerNotes:
              '- Any lobby client can press start, first event wins\n'
              '- startedAt is three seconds in the future: shared countdown\n'
              '- Clock skew shifts the countdown cosmetically, damage stays '
              'victim-authoritative so nothing breaks',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.split(
      leftBuilder: (context) => const SideBullets(
        items: [
          'Sender picks seed and startedAt = now + 3 s',
          'participants locks in who plays',
          'roundStart is ignored outside the lobby',
          'Clock skew is cosmetic only',
        ],
      ),
      rightBuilder: (context) => const CodePane(
        fileName: 'packages/game/lib/src/game/space_game.dart',
        code: '''
final payload = RoundStartPayload(
  seed: Random().nextInt(1 << 31),
  startedAt: DateTime.now().millisecondsSinceEpoch +
      GameConfig.countdownSeconds * 1000,
  participants: ids,
);
net.send(NetEvent.roundStart, payload.toJson());
_applyRoundStart(payload);

void _onRoundStart(RoundStartPayload payload) {
  if (phase.value != GamePhase.lobby) {
    return;
  }
  _applyRoundStart(payload);
}''',
      ),
    );
  }
}
