import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/side_bullets.dart';

class TypedV3Slide extends FlutterDeckSlideWidget {
  const TypedV3Slide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/typed-v3',
          title: 'Toward a typesafe Supabase v3',
          steps: 4,
          speakerNotes:
              '- Say this up front: we are on a prerelease of the Dart '
              'client today, not the stable release\n'
              '- Supabase v3 for Dart is typesafe from the ground up\n'
              '- Tables and columns become Dart types, so the compiler '
              'checks queries and streams\n'
              '- A generator reads your database schema and writes those '
              'types for you\n'
              '- It is on pub.dev as 3.0.0-dev.9 and the workshop already '
              'resolves it, so there is nothing extra to install\n'
              '- Fresh off the press, so expect the odd rough edge; typed '
              'Broadcast and Presence are the next step',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => const SideBullets(
        useSteps: true,
        items: [
          'Supabase v3 for Dart is typesafe from the ground up',
          'Tables and columns become Dart types, so the compiler checks '
              'your queries and streams',
          'A generator reads your database schema and writes those types',
          'On pub.dev today as the 3.0.0-dev.9 prerelease',
        ],
      ),
    );
  }
}
