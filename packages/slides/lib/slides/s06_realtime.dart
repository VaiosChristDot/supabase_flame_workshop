import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/side_bullets.dart';

class RealtimeSlide extends FlutterDeckSlideWidget {
  const RealtimeSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/realtime',
          title: 'Supabase Realtime',
          steps: 4,
          speakerNotes:
              '- Channels are named message buses over one WebSocket\n'
              '- Broadcast: fire-and-forget messages to everyone else\n'
              '- Presence: a shared, self-healing roster\n'
              '- Postgres Changes exists too, we use it for the leaderboard',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => const SideBullets(
        useSteps: true,
        items: [
          'Channel: a named bus on one WebSocket connection',
          'Broadcast: low-latency events to every subscriber',
          'Presence: who is here, with a payload per client',
          'Postgres Changes: stream database rows as they change',
        ],
      ),
    );
  }
}
