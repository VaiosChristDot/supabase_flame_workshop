import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/exercise_panel.dart';

class ExerciseMoveSlide extends FlutterDeckSlideWidget {
  const ExerciseMoveSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/exercise-2',
          title: 'Exercise 2: Move your player',
          speakerNotes:
              '- Budget about 20 minutes\n'
              '- The reference player lives in components/player_ship.dart\n'
              '- Nudge people toward dt everywhere in the physics',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => const ExercisePanel(
        number: 2,
        title: 'Move your player',
        tasks: [
          'A FlameGame in a GameWidget, with a background behind everything',
          'A player component: a simple shape, acceleration, turning, drag, '
              'speed cap',
          'Keyboard flags through KeyboardHandler, the space bar fires bullets',
          'Camera: fixed 960 by 540 resolution, following your player',
        ],
        doneWhen: 'You can move around the world and shoot.',
      ),
    );
  }
}
