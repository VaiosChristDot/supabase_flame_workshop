import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/code_pane.dart';
import '../widgets/side_bullets.dart';

class SkeletonSlide extends FlutterDeckSlideWidget {
  const SkeletonSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/skeleton',
          title: 'The skeleton',
          speakerNotes:
              '- Everybody starts from the same place, nobody hand writes a '
              'pubspec today\n'
              '- flame and the v3 prerelease of supabase_flutter are '
              'already resolved\n'
              '- The status screen turns green once exercise 1 is done\n'
              '- packages/game is the finished reference, one directory over',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.split(
      leftBuilder: (context) => const SideBullets(
        items: [
          'Start from packages/skeleton',
          'flame and the typesafe v3 prerelease already resolved',
          'Configuration and tuning constants handed to you',
          'Everything else is what you build',
        ],
      ),
      rightBuilder: (context) => const CodePane(
        fileName: 'packages/skeleton',
        code: '''
skeleton/
  pubspec.yaml    flame, supabase_flutter 3.0.0-dev.9
  web/            scaffolding for -d chrome
  lib/
    main.dart     exercise 1 starts here
    src/
      env.dart          url, key, room: fill in
      game_config.dart  tuning constants
      app/              placeholder shell

\$ cd packages/skeleton && flutter run -d chrome''',
      ),
    );
  }
}
