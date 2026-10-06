import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/code_pane.dart';
import '../widgets/side_bullets.dart';

class DisconnectsSlide extends FlutterDeckSlideWidget {
  const DisconnectsSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/disconnects',
          title: 'Disconnects and reconnects',
          speakerNotes:
              '- Presence leave fires when a tab closes or a network drops\n'
              '- A leaver counts as a death: the round still ends\n'
              '- The channel resubscribes with a small backoff on errors',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.split(
      leftBuilder: (context) => const SideBullets(
        items: [
          'Presence leave is the disconnect signal',
          'Leaving mid round counts as dying',
          'Reconnect: resubscribe and re-track presence',
          'A reconnecting player rejoins as a spectator',
        ],
      ),
      rightBuilder: (context) => const CodePane(
        fileName: 'packages/game/lib/src/net/net_service.dart',
        code: '''
channel.onPresenceLeave.listen((leave) {
  for (final presence in leave.leftPresences) {
    final id = presence.payload['id'] as String?;
    if (id != null && id != myId) {
      onPeerLeft?.call(id);
    }
  }
});

channel.onStatusChange.listen((change) {
  final status = change.status;
  if (status == RealtimeSubscribeStatus.channelError ||
      status == RealtimeSubscribeStatus.closed) {
    _scheduleReconnect();
  }
});''',
      ),
    );
  }
}
