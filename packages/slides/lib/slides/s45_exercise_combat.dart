import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/exercise_panel.dart';

class ExerciseCombatSlide extends FlutterDeckSlideWidget {
  const ExerciseCombatSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/exercise-7',
          title: 'Exercise 7: Combat',
          speakerNotes:
              '- Budget about 25 minutes, this is the big one\n'
              '- Remind: only the victim applies damage to itself\n'
              '- Winner check runs on every death and every leave',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => const ExercisePanel(
        number: 7,
        title: 'Combat',
        tasks: [
          'The victim applies bullet damage and broadcasts hit',
          'On zero health: broadcast death, explode, switch to spectating',
          'Track the alive set from deaths and presence leaves',
          'When one player remains, show the winner in every window',
        ],
        doneWhen:
            'A full round plays out and both windows agree on the winner.',
      ),
    );
  }
}
