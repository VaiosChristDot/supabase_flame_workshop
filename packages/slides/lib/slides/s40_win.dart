import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/code_pane.dart';
import '../widgets/side_bullets.dart';

class WinSlide extends FlutterDeckSlideWidget {
  const WinSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/win',
          title: 'Detecting the winner without a server',
          speakerNotes:
              '- Every client sees the same event stream\n'
              '- alive = participants minus deaths minus leavers\n'
              '- All clients reach the same verdict independently\n'
              '- Zero alive is a draw',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.split(
      leftBuilder: (context) => const SideBullets(
        items: [
          'roundStart locks the participant list',
          'death events and presence leaves reduce alive',
          'alive <= 1 ends the round on every client',
          'Same inputs, same verdict, no referee',
        ],
      ),
      rightBuilder: (context) => const CodePane(
        fileName: 'packages/game/lib/src/game/space_game.dart',
        code: '''
void _checkRoundEnd() {
  final activeRound = round;
  if (activeRound == null) {
    return;
  }
  if (activeRound.alive.length > 1) {
    return;
  }
  final winnerId = activeRound.alive.length == 1
      ? activeRound.alive.first
      : null;
  _endRound(winnerId);
}''',
      ),
    );
  }
}
