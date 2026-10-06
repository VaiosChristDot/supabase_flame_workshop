import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/code_pane.dart';
import '../widgets/side_bullets.dart';

class FlameIntroSlide extends FlutterDeckSlideWidget {
  const FlameIntroSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/flame-intro',
          title: 'Flame: GameWidget and FlameGame',
          speakerNotes:
              '- FlameGame is the root of the component tree\n'
              '- GameWidget embeds the game loop into any Flutter widget tree\n'
              '- Overlays let us keep menus and HUDs in plain Flutter',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.split(
      leftBuilder: (context) => const SideBullets(
        items: [
          'FlameGame drives update and render',
          'GameWidget mounts it as a widget',
          'Overlays are regular Flutter widgets',
          'The game is just another Flutter view',
        ],
      ),
      rightBuilder: (context) => const CodePane(
        fileName: 'packages/game/lib/src/app/game_app.dart',
        code: '''
class SpaceGame extends FlameGame
    with
        HasKeyboardHandlerComponents,
        HasCollisionDetection {
  // The whole game lives here.
}

GameWidget<SpaceGame>(
  game: game,
  overlayBuilderMap: {
    OverlayIds.lobby: (context, game) =>
        LobbyOverlay(game: game),
    OverlayIds.hud: (context, game) =>
        HudOverlay(game: game),
  },
)''',
      ),
    );
  }
}
