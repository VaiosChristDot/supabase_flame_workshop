import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

class PhasesSlide extends FlutterDeckSlideWidget {
  const PhasesSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/phases',
          title: 'The phase state machine',
          speakerNotes:
              '- One ValueNotifier drives which overlay is shown\n'
              '- countdown flips to playing on the shared start timestamp\n'
              '- Death moves you to spectating, not out of the match',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => const Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PhaseChip(label: 'lobby'),
            PhaseArrow(label: 'roundStart'),
            PhaseChip(label: 'countdown'),
            PhaseArrow(label: 'startedAt'),
            PhaseChip(label: 'playing'),
            PhaseArrow(label: 'hp <= 0'),
            PhaseChip(label: 'spectating'),
            PhaseArrow(label: 'alive <= 1'),
            PhaseChip(label: 'roundOver'),
          ],
        ),
      ),
    );
  }
}

class PhaseChip extends StatelessWidget {
  const PhaseChip({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF3ECF8E), width: 2),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        label,
        style: FlutterDeckTheme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}

class PhaseArrow extends StatelessWidget {
  const PhaseArrow({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: FlutterDeckTheme.of(context).textTheme.bodySmall),
          const Icon(Icons.arrow_forward, size: 28),
        ],
      ),
    );
  }
}
