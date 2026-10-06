import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/exercise_panel.dart';

class ExerciseWorldSlide extends FlutterDeckSlideWidget {
  const ExerciseWorldSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/exercise-3',
          title: 'Exercise 3: A seeded world',
          speakerNotes:
              '- Budget about 15 minutes\n'
              '- Determinism check: restart with the same seed and compare '
              'screens with a neighbor',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => const ExercisePanel(
        number: 3,
        title: 'A world from one integer',
        tasks: [
          'An obstacle field from Random(seed): polar placement, randomized '
              'shapes',
          'Keep the spawn ring clear with rejection sampling',
          'Circle hitboxes: bullets stop, players bounce with bump damage',
        ],
        doneWhen:
            'The same seed produces the same world on every restart, and on '
            'your neighbor\'s machine.',
      ),
    );
  }
}
