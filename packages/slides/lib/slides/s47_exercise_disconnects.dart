import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/exercise_panel.dart';

class ExerciseDisconnectsSlide extends FlutterDeckSlideWidget {
  const ExerciseDisconnectsSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/exercise-8',
          title: 'Exercise 8: Disconnects',
          speakerNotes:
              '- Budget about 15 minutes\n'
              '- Presence leave is the only disconnect signal we need\n'
              '- Test the disconnect path by closing a window mid round',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => const ExercisePanel(
        number: 8,
        title: 'Disconnects and reconnects',
        tasks: [
          'A presence leave removes the player and counts as a death',
          'The round still ends when the last opponent leaves',
          'Resubscribe and re-track presence after a channel error',
          'A reconnecting player rejoins as a spectator',
        ],
        doneWhen:
            'Closing a window mid round ends the round cleanly in every '
            'other window.',
      ),
    );
  }
}
