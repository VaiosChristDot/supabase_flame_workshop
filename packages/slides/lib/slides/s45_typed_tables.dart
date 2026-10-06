import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/code_pane.dart';
import '../widgets/side_bullets.dart';

class TypedTablesSlide extends FlutterDeckSlideWidget {
  const TypedTablesSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/typed-tables',
          title: 'Typed table access',
          speakerNotes:
              '- supabase_typegen turns the schema into extension types\n'
              '- Zero-cost wrappers over the decoded JSON\n'
              '- Filters are compile-time checked against column types\n'
              '- The winner records a win through the typed builder',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.split(
      leftBuilder: (context) => const SideBullets(
        items: [
          'Generated: ScoresRow, ScoresInsert, ScoresUpdate',
          'Scores.wins is a PostgrestColumn<ScoresRow, int>',
          'Filters check column types at compile time',
          'No raw Map<String, dynamic> in sight',
        ],
      ),
      rightBuilder: (context) => const CodePane(
        fileName: 'packages/game/lib/src/db/score_service.dart',
        code: '''
final existing = await client
    .table(Scores.table)
    .select()
    .where(Scores.id.eq(id))
    .maybeSingle();

await client.table(Scores.table).upsert(
  ScoresInsert(
    id: id,
    name: name,
    wins: (existing?.wins ?? 0) + 1,
    updatedAt: DateTime.now(),
  ),
);''',
      ),
    );
  }
}
