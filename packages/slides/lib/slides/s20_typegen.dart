import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/code_pane.dart';
import '../widgets/side_bullets.dart';

class TypegenSlide extends FlutterDeckSlideWidget {
  const TypegenSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/typegen',
          title: 'Generating types with the Supabase CLI',
          speakerNotes:
              '- supabase gen types now has a dart language, on a recent '
              'CLI, 2.120 has it\n'
              '- Run it from the Dart project that should receive the '
              'types, it uses the supabase_typegen dev dependency of that '
              'project, which the skeleton already has\n'
              '- project-id is the id in your project URL, and supabase '
              'login from earlier is all the access it needs\n'
              '- The CLI prints the types, so redirect them into a file, '
              'supabase_typegen writes lib/supabase_schema.g.dart by itself\n'
              '- Running a local stack instead? Swap project-id for local\n'
              '- On an older CLI, call supabase_typegen directly, it '
              'produces the same file\n'
              '- Regenerate after every migration and commit the file',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.split(
      leftBuilder: (context) => const SideBullets(
        items: [
          'supabase gen types reads your schema and prints Dart',
          'One file out: rows, inserts, updates, columns',
          'Works against a hosted project or the local stack',
          'supabase_typegen does the same without a recent CLI',
          'Regenerate after every migration',
        ],
      ),
      rightBuilder: (context) => const CodePane(
        fileName: 'generate.sh',
        code: '''
cd packages/skeleton

# With the Supabase CLI, from your hosted project
supabase gen types --lang dart \\
  --project-id your-ref \\
  > lib/supabase_schema.g.dart

# Or from the local stack after supabase start
supabase gen types --lang dart --local \\
  > lib/supabase_schema.g.dart

# Alternative: supabase_typegen directly,
# which writes lib/supabase_schema.g.dart by default
dart run supabase_typegen --project-ref your-ref''',
      ),
    );
  }
}
