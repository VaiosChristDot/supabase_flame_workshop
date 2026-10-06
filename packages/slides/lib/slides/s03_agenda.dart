import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/side_bullets.dart';

class AgendaSlide extends FlutterDeckSlideWidget {
  const AgendaSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/agenda',
          title: 'Agenda',
          steps: 7,
          speakerNotes:
              '- Walk through the plan for the session\n'
              '- This is a workshop: nine build-time exercises, marked by '
              'the green slides\n'
              '- Everyone leaves with a running multiplayer game',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => const SideBullets(
        useSteps: true,
        items: [
          'Set up your Supabase project, meet the typesafe v3',
          'Move a player with Flame: components, input, camera',
          'Deterministic worlds from one shared seed',
          'Sync players at 20 Hz with Supabase Broadcast',
          'Lobbies and disconnects with Presence',
          'Rounds, combat, and picking a winner',
          'A typed leaderboard, then play a full round',
        ],
      ),
    );
  }
}
