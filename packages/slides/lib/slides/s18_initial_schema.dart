import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

class InitialSchemaSlide extends FlutterDeckSlideWidget {
  const InitialSchemaSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/initial-schema',
          title: 'Sketch your first schema',
          speakerNotes:
              '- Give everyone a couple of minutes to write down the tables '
              'and columns their game needs\n'
              '- A rough first version is enough, nobody gets it right up '
              'front\n'
              '- Every later change is just another migration file',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.bigFact(
      title: 'Sketch your first schema',
      subtitle:
          'Which tables and columns does your game need? A rough first '
          'version is enough:\n'
          'you can always add more migrations later.',
    );
  }
}
