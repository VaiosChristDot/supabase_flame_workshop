import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/exercise_panel.dart';

class ExerciseConnectSlide extends FlutterDeckSlideWidget {
  const ExerciseConnectSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/exercise-4',
          title: 'Exercise 4: Get connected',
          speakerNotes:
              '- Budget about 15 minutes\n'
              '- Everyone should use their own project, so no channel '
              'collisions between attendees\n'
              '- Two Chrome windows of the same app are two players',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => const ExercisePanel(
        number: 4,
        title: 'Get connected',
        tasks: [
          'Join a channel with RealtimeChannelConfig(self: false)',
          'A NetEvent enum plus payload models for state and shoot',
          'A per-instance player id, separate from the auth uuid',
          'Open two windows and log what the other one sends',
        ],
        doneWhen: 'Window A moves, window B logs the state payloads.',
      ),
    );
  }
}
