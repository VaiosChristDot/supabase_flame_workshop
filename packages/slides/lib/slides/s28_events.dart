import 'package:flutter/widgets.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/code_pane.dart';
import '../widgets/side_bullets.dart';

class EventsSlide extends FlutterDeckSlideWidget {
  const EventsSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/events',
          title: 'Events and typed payload models',
          speakerNotes:
              '- Five events cover the whole game\n'
              '- Typed model classes wrap the JSON at the boundary\n'
              '- The event enum name is the wire name',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.split(
      leftBuilder: (context) => const SideBullets(
        items: [
          'state: player position at 20 Hz',
          'shoot, hit, death: the combat loop',
          'roundStart: seed and start time',
          'Typed models at the JSON boundary',
        ],
      ),
      rightBuilder: (context) => const CodePane(
        fileName: 'packages/game/lib/src/net/net_events.dart',
        code: '''
enum NetEvent { state, shoot, hit, death, roundStart }

class ShipStatePayload {
  const ShipStatePayload({
    required this.id,
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.rotation,
    required this.hp,
  });

  factory ShipStatePayload.fromJson(
    Map<String, dynamic> json,
  ) => ...;
  Map<String, dynamic> toJson() => ...;
}''',
      ),
    );
  }
}
