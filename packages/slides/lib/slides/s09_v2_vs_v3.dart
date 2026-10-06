import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/code_pane.dart';

class V2VersusV3Slide extends FlutterDeckSlideWidget {
  const V2VersusV3Slide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/v2-vs-v3',
          title: 'v2 versus v3',
          speakerNotes:
              '- Same query, twice: today with v2, then with the v3 '
              'prerelease\n'
              '- v2: column names and filters are strings, rows are maps, '
              'every read is a hopeful cast\n'
              '- The winz typo compiles fine on v2 and fails at runtime\n'
              '- v3: columns are typed tokens, rows are typed, the typo does '
              'not compile',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.split(
      leftBuilder: (context) => const LabeledCode(
        label: 'Today: v2, stringly typed',
        code: '''
final rows = await supabase
    .from('scores')
    .select()
    .eq('id', id);

final wins =
    rows.first['wins'] as int;

await supabase.from('scores').upsert({
  'id': id,
  'name': name,
  'winz': wins + 1,
});''',
      ),
      rightBuilder: (context) => const LabeledCode(
        label: 'Now: v3, typed end to end',
        code: '''
final row = await supabase
    .table(Scores.table)
    .select()
    .where(Scores.id.eq(id))
    .maybeSingle();

await supabase.table(Scores.table).upsert(
  ScoresInsert(
    id: id,
    name: name,
    wins: (row?.wins ?? 0) + 1,
  ),
);''',
      ),
    );
  }
}

class LabeledCode extends StatelessWidget {
  const LabeledCode({required this.label, required this.code, super.key});

  final String label;
  final String code;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label, style: FlutterDeckTheme.of(context).textTheme.title),
        Flexible(child: CodePane(code: code)),
      ],
    );
  }
}
