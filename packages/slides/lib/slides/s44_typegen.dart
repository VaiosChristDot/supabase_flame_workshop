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
              '- supabase_typegen is already a dev dependency of the '
              'skeleton\n'
              '- It reads the schema through the Supabase CLI, which is why '
              'we installed it and ran supabase login earlier\n'
              '- project-ref is the id in your project URL, no database '
              'password is needed\n'
              '- The import flag makes the generated file use '
              'supabase_flutter instead of the plain postgrest package\n'
              '- Running a local stack instead? Swap project-ref for local\n'
              '- Regenerate after every migration and commit the file',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.split(
      leftBuilder: (context) => const SideBullets(
        items: [
          'supabase_typegen reads your schema through the Supabase CLI',
          'One Dart file out: rows, inserts, updates, columns',
          'Works against a hosted project or the local stack',
          'Regenerate after every migration',
        ],
      ),
      rightBuilder: (context) => const CodePane(
        fileName: 'generate.sh',
        code: '''
cd packages/skeleton

# From your hosted project
dart run supabase_typegen \\
  --project-ref your-ref \\
  --output lib/src/db/supabase_schema.g.dart \\
  --import package:supabase_flutter/supabase_flutter.dart

# Or from the local stack after supabase start
dart run supabase_typegen --local \\
  --output lib/src/db/supabase_schema.g.dart \\
  --import package:supabase_flutter/supabase_flutter.dart''',
      ),
    );
  }
}
