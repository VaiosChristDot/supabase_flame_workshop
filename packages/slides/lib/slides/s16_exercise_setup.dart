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
              '- Budget about 20 minutes, this one walks through every '
              'setup slide so far\n'
              '- Everybody works inside packages/skeleton\n'
              '- Walk around and unblock people\n'
              '- If the GitHub integration is unavailable, supabase link and '
              'supabase db push apply the migration by hand\n'
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
          'Fork and clone the repository, then run dart pub get',
          'Install the Supabase CLI and run supabase login',
          'Connect your fork with the GitHub integration, which applies the '
              'scores migration',
          'Fill your project URL and publishable key into lib/src/env.dart',
          'Run packages/skeleton with flutter run -d chrome',
        ],
        doneWhen: 'The status screen turns green with your user id.',
      ),
    );
  }
}
