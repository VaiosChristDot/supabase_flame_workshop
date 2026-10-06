import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/exercise_panel.dart';

class ExerciseLobbySlide extends FlutterDeckSlideWidget {
  const ExerciseLobbySlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/exercise-6',
          title: 'Exercise 6: The lobby',
          speakerNotes:
              '- Budget about 20 minutes\n'
              '- The countdown comes from startedAt, not from a timer race\n'
              '- Compare the worlds between windows to prove the seed '
              'works',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => const ExercisePanel(
        number: 6,
        title: 'The lobby and a shared round',
        tasks: [
          'Track presence with id, name, color, and phase',
          'A lobby overlay with the live roster and a start button',
          'Broadcast roundStart with seed, startedAt, and participants',
          'Count down into an identical world in every window',
        ],
        doneWhen: 'Both windows count down together into the same world.',
      ),
    );
  }
}
