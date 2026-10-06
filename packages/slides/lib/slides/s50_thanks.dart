import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

class ThanksSlide extends FlutterDeckSlideWidget {
  const ThanksSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/thanks',
          title: 'Thanks',
          speakerNotes:
              '- Share the repository link\n'
              '- Point at flame-engine.org and supabase.com/docs\n'
              '- Questions',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.title(
      title: 'Thank you!',
      subtitle:
          'github.com/spydon/supabase_flame_workshop\n'
          'flame-engine.org\n'
          'supabase.com',
    );
  }
}
