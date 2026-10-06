import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/code_pane.dart';
import '../widgets/side_bullets.dart';

class TypedStreamSlide extends FlutterDeckSlideWidget {
  const TypedStreamSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/typed-stream',
          title: 'A typed live leaderboard',
          speakerNotes:
              '- The lobby leaderboard is a typed Postgres Changes stream\n'
              '- Stream<List<ScoresRow>> straight into a StreamBuilder\n'
              '- Typed Broadcast and Presence are what comes next in v3',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.split(
      leftBuilder: (context) => const SideBullets(
        items: [
          'stream(primaryKey: [Scores.id])',
          'Rows arrive as List<ScoresRow>',
          'The lobby updates live as wins land',
          'Next up in v3: typed Broadcast and Presence',
        ],
      ),
      rightBuilder: (context) => const CodePane(
        fileName: 'packages/game/lib/src/db/score_service.dart',
        code: '''
Stream<List<ScoresRow>> topScores({int limit = 10}) {
  return client
      .table(Scores.table)
      .stream(primaryKey: [Scores.id])
      .order(Scores.wins)
      .limit(limit);
}

StreamBuilder<List<ScoresRow>>(
  stream: scoreService.topScores(),
  builder: (context, snapshot) {
    final scores = snapshot.data ?? const [];
    // Render the top players.
  },
)''',
      ),
    );
  }
}
