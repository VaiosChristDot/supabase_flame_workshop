import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

class SharedSeedSlide extends FlutterDeckSlideWidget {
  const SharedSeedSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/shared-seed',
          title: 'Deterministic shared-seed worlds',
          speakerNotes:
              '- The key trick of this workshop\n'
              '- Broadcast one integer, every client builds the same world\n'
              '- Obstacles, spawn slots, and the round clock are derived, '
              'never synced',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.bigFact(
      title: '{seed, startedAt}',
      subtitle:
          'Broadcast two numbers, and every client generates an identical '
          'world, identical spawn slots, and an identical round clock. '
          'Nothing else to sync.',
    );
  }
}
