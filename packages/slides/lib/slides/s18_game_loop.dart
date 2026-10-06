import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/code_pane.dart';
import '../widgets/side_bullets.dart';

class GameLoopSlide extends FlutterDeckSlideWidget {
  const GameLoopSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/game-loop',
          title: 'update and render',
          speakerNotes:
              '- update(dt) advances the simulation each frame\n'
              '- render(canvas) draws the current state\n'
              '- dt keeps physics frame-rate independent',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.split(
      leftBuilder: (context) => const SideBullets(
        items: [
          'update runs every frame with delta time',
          'render paints with the plain Canvas API',
          'Multiply by dt for frame-rate independence',
        ],
      ),
      rightBuilder: (context) => const CodePane(
        fileName: 'packages/game/lib/src/game/components/bullet.dart',
        code: '''
@override
void update(double dt) {
  position.add(velocity * dt);
  _ttl -= dt;
  if (_ttl <= 0) {
    removeFromParent();
  }
}

@override
void render(Canvas canvas) {
  final center = (size / 2).toOffset();
  canvas.drawCircle(center, 2.5, Paint()..color = color);
}''',
      ),
    );
  }
}
