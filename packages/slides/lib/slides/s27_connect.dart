import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/code_pane.dart';
import '../widgets/side_bullets.dart';

class ConnectSlide extends FlutterDeckSlideWidget {
  const ConnectSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/connect',
          title: 'Anonymous auth and joining the channel',
          speakerNotes:
              '- Anonymous sign-in gives every browser a stable uuid, which '
              'keys the leaderboard\n'
              '- Each game instance also rolls its own random player id for '
              'players, events, and presence, so two windows on one machine '
              'are two players\n'
              '- self: false means we never receive our own broadcasts\n'
              '- One channel per room',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.split(
      leftBuilder: (context) => const SideBullets(
        items: [
          'signInAnonymously: identity without signup',
          'The auth uuid keys the leaderboard',
          'A random per-instance id keys players and events',
          'self: false drops our own echoes server side',
        ],
      ),
      rightBuilder: (context) => const CodePane(
        fileName: 'packages/game/lib/src/net/net_service.dart',
        code: '''
await Supabase.initialize(
  url: Env.supabaseUrl,
  publishableKey: Env.supabaseKey,
);
await auth.signInAnonymously();

final channel = client.channel(
  'game-arena-\${Env.room}',
  options: const RealtimeChannelConfig(self: false),
);
channel.subscribe();''',
      ),
    );
  }
}
