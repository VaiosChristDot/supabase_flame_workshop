import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/code_pane.dart';
import '../widgets/side_bullets.dart';

class CameraSlide extends FlutterDeckSlideWidget {
  const CameraSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/camera',
          title: 'Camera and world',
          speakerNotes:
              '- Fixed resolution keeps the field of view identical for all\n'
              '- camera.follow tracks the local player\n'
              '- Bounds stop the camera at the world edge',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.split(
      leftBuilder: (context) => const SideBullets(
        items: [
          'Fixed resolution: fair play on any screen',
          'Follow the local player, or a spectate target',
          'Camera bounds clamp at the world edge',
        ],
      ),
      rightBuilder: (context) => const CodePane(
        fileName: 'packages/game/lib/src/game/space_game.dart',
        code: '''
SpaceGame(...)
  : super(
      camera: CameraComponent.withFixedResolution(
        width: 960,
        height: 540,
      ),
    );

camera.follow(ship, snap: true);
camera.setBounds(
  Rectangle.fromRect(...),
  considerViewport: true,
);''',
      ),
    );
  }
}
