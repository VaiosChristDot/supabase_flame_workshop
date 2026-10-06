import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

class CreditsSlide extends FlutterDeckSlideWidget {
  const CreditsSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/credits',
          title: 'Supabase credits',
          speakerNotes:
              '- Hand out the credits codes\n'
              '- The code does not expire today: they can redeem it later\n'
              '- For the workshop a free project is more than enough',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.bigFact(
      title: 'Supabase credits, on us',
      subtitle:
          'Everyone gets a credits code today. Feel free to save it for your '
          'next big idea:\n'
          'for this workshop, a free project at database.new is all we need.',
    );
  }
}
