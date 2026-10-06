import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/exercise_panel.dart';

class ExerciseLeaderboardSlide extends FlutterDeckSlideWidget {
  const ExerciseLeaderboardSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/exercise-9',
          title: 'Exercise 9: Leaderboard',
          speakerNotes:
              '- Budget about 15 minutes\n'
              '- The generated schema file ships in the repository if '
              'typegen gives anyone trouble\n'
              '- Row level security only lets you write your own row',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => const ExercisePanel(
        number: 9,
        title: 'The typed leaderboard',
        tasks: [
          'Regenerate the typed schema with supabase gen types --lang dart',
          'The winner upserts wins through the typed builder',
          'Stream the top ten into the lobby with the typed stream',
        ],
        doneWhen:
            'Win a round and watch your name climb the lobby leaderboard.',
      ),
    );
  }
}
