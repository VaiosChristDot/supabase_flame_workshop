import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

class QuestionsSlide extends FlutterDeckSlideWidget {
  const QuestionsSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/questions',
          title: 'Your questions lead the way',
          speakerNotes:
              '- From here there are no more prepared slides, everyone '
              'builds their own game\n'
              '- When somebody asks a question, answer it for the whole '
              'room, the others are likely to hit the same thing\n'
              '- Live code the answer in the skeleton or show it in '
              'packages/game\n'
              '- Keep walking around between questions',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.bigFact(
      title: 'Your questions lead the way',
      subtitle:
          'From here we keep building our games. Ask whenever you get '
          'stuck:\n'
          'I will explain the answer to everybody.',
    );
  }
}
