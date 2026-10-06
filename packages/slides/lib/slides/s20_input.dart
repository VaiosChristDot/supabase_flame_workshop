import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/code_pane.dart';
import '../widgets/side_bullets.dart';

class InputSlide extends FlutterDeckSlideWidget {
  const InputSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/input',
          title: 'Keyboard input',
          speakerNotes:
              '- KeyboardHandler mixin receives key events\n'
              '- keysPressed carries the full current set, so we derive flags\n'
              '- update() consumes the flags every frame',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.split(
      leftBuilder: (context) => const SideBullets(
        items: [
          'HasKeyboardHandlerComponents on the game',
          'KeyboardHandler on the player',
          'Flags, not events, drive the physics',
        ],
      ),
      rightBuilder: (context) => const CodePane(
        fileName: 'packages/game/lib/src/game/components/player_ship.dart',
        code: '''
@override
bool onKeyEvent(
  KeyEvent event,
  Set<LogicalKeyboardKey> keysPressed,
) {
  _thrust =
      keysPressed.contains(LogicalKeyboardKey.arrowUp) ||
      keysPressed.contains(LogicalKeyboardKey.keyW);
  _left =
      keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
      keysPressed.contains(LogicalKeyboardKey.keyA);
  _fire = keysPressed.contains(LogicalKeyboardKey.space);
  return true;
}''',
      ),
    );
  }
}
