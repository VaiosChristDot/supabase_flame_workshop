import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/code_pane.dart';
import '../widgets/side_bullets.dart';

class RunTheGameSlide extends FlutterDeckSlideWidget {
  const RunTheGameSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/run-the-game',
          title: 'Running the skeleton',
          speakerNotes:
              '- The project URL and the publishable key are on the project '
              'API settings page\n'
              '- The key is publishable on purpose, it ships in the client '
              'and row level security guards the data\n'
              '- Both values go into lib/src/env.dart as the default values, '
              'replacing the local stack ones\n'
              '- Run it straight with flutter run from packages/skeleton, no '
              'extra tooling needed\n'
              '- Run the command twice to play against yourself\n'
              '- The room default decides who meets whom, split the room '
              'into groups to stay under the Realtime limits\n'
              '- Prefer a local stack? supabase start and leave the file as '
              'it is, the defaults already point there',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.split(
      leftBuilder: (context) => const SideBullets(
        items: [
          'Copy the project URL and publishable key from the API settings',
          'Fill both into lib/src/env.dart in the skeleton',
          'The room value decides which room you join',
          'Run it with flutter run, twice to play against yourself',
        ],
      ),
      rightBuilder: (context) => const CodePane(
        fileName: 'packages/skeleton/lib/src/env.dart',
        code: '''
class Env {
  static const supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://your-ref.supabase.co',
  );

  static const supabaseKey = String.fromEnvironment(
    'SUPABASE_KEY',
    defaultValue: 'sb_publishable_...',
  );

  static const room = String.fromEnvironment(
    'ROOM',
    defaultValue: 'main',
  );
}

// Then, from packages/skeleton:
//   flutter run -d chrome''',
      ),
    );
  }
}
