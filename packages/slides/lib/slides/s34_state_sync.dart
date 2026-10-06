import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/code_pane.dart';
import '../widgets/side_bullets.dart';

class StateSyncSlide extends FlutterDeckSlideWidget {
  const StateSyncSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/state-sync',
          title: 'Broadcasting player state at 20 Hz',
          speakerNotes:
              '- 60 broadcasts per second per player would flood the channel\n'
              '- 20 Hz plus interpolation looks like 60 FPS\n'
              '- Idle players stop transmitting, one keepalive per second\n'
              '- Hosted Realtime rate limits: split big rooms with the room '
              'value in env.dart',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.split(
      leftBuilder: (context) => const SideBullets(
        items: [
          'Throttle: one state packet per 50 ms',
          'Skip sends while idle, 1 Hz keepalive',
          'Watch hosted rate limits: split rooms per channel',
        ],
      ),
      rightBuilder: (context) => const CodePane(
        fileName: 'packages/game/lib/src/game/components/player_ship.dart',
        highlightedLines: [2, 3, 4, 5],
        code: '''
void _broadcastState(double dt) {
  _sinceSync += dt;
  if (_sinceSync < GameConfig.stateSyncInterval) {
    return;
  }
  _sinceSync = 0;
  final moved = position.distanceTo(_lastSentPosition) > 0.5;
  if (!moved && _sinceSend < GameConfig.keepaliveInterval) {
    return;
  }
  gameRef.net.send(
    NetEvent.state,
    ShipStatePayload(...).toJson(),
  );
}''',
      ),
    );
  }
}
