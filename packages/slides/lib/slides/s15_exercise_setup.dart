import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/exercise_panel.dart';

class ExerciseSetupSlide extends FlutterDeckSlideWidget {
  const ExerciseSetupSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/exercise-1',
          title: 'Exercise 1: Get set up',
          speakerNotes:
              '- Budget about 15 minutes\n'
              '- Everybody works inside packages/skeleton\n'
              '- Walk around and unblock people\n'
              '- Common snags: anonymous sign-ins not enabled, or env.dart '
              'still pointing at the local stack',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => const ExercisePanel(
        number: 1,
        title: 'Get set up',
        tasks: [
          'Create your free Supabase project and enable anonymous sign-ins',
          'Install the Supabase CLI and run supabase login',
          'Apply the scores migration to your project',
          'Fill in lib/src/env.dart and run packages/skeleton with flutter run',
          'main.dart: Supabase.initialize, then signInAnonymously',
        ],
        doneWhen: 'The status screen turns green with your user id.',
      ),
    );
  }
}
