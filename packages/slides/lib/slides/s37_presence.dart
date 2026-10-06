import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/code_pane.dart';
import '../widgets/side_bullets.dart';

class PresenceSlide extends FlutterDeckSlideWidget {
  const PresenceSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/presence',
          title: 'A lobby with Presence',
          speakerNotes:
              '- track() takes JSON, so we hand it a typed LobbyPresence '
              'and call toJson\n'
              '- The roster comes back through LobbyPresence.fromJson, so '
              'the rest of the game never touches raw maps\n'
              '- presenceState() is the merged roster, always consistent\n'
              '- Presence doubles as match discovery: in-match players carry '
              'seed and startedAt, so late joiners can spectate',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.split(
      leftBuilder: (context) => const SideBullets(
        items: [
          'track() publishes a typed LobbyPresence as JSON',
          'sync, join, leave keep the roster fresh',
          'In-match players advertise seed and startedAt',
          'Late joiners bootstrap straight into spectating',
        ],
      ),
      rightBuilder: (context) => const CodePane(
        fileName: 'packages/game/lib/src/net/net_service.dart',
        code: '''
final me = LobbyPresence(
  id: myId,
  name: myName,
  colorIndex: myColorIndex,
  phase: phase.value.name,
  seed: round?.seed,
  startedAt: round?.startedAt,
);
await channel.track(me.toJson());

channel.onPresenceSync.listen((_) {
  final roster = [
    for (final state in channel.presenceState())
      for (final presence in state.presences)
        LobbyPresence.fromJson(presence.payload),
  ];
});''',
      ),
    );
  }
}
