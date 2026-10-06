import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

class DemoSlide extends FlutterDeckSlideWidget {
  const DemoSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/demo',
          title: 'Demo time',
          speakerNotes:
              '- Everyone joins the same room\n'
              '- Split big audiences across rooms with the room value in env.dart\n'
              '- Play a full round together',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.bigFact(
      title: 'Demo time',
      subtitle: 'Everyone into the arena. Last player standing wins.',
    );
  }
}
