import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

class ArchitectureSlide extends FlutterDeckSlideWidget {
  const ArchitectureSlide()
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/architecture',
          title: 'Architecture',
          speakerNotes:
              '- Peer-authoritative: every client simulates its own player\n'
              '- One shared Realtime channel relays all events\n'
              '- The database only stores what should outlive a session',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (context) => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ArchitectureBox(label: 'Client A\nowns player A'),
                ArchitectureBox(label: 'Client B\nowns player B'),
                ArchitectureBox(label: 'Client C\nowns player C'),
              ],
            ),
            SizedBox(height: 24),
            Icon(Icons.swap_vert, size: 64),
            SizedBox(height: 24),
            ArchitectureBox(
              label: 'Supabase Realtime channel\nBroadcast events + Presence roster',
              wide: true,
            ),
            SizedBox(height: 24),
            Icon(Icons.arrow_downward, size: 48),
            SizedBox(height: 24),
            ArchitectureBox(
              label: 'Postgres\npersistent game data',
              wide: true,
            ),
          ],
        ),
      ),
    );
  }
}

class ArchitectureBox extends StatelessWidget {
  const ArchitectureBox({required this.label, this.wide = false, super.key});

  final String label;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: wide ? 640 : 280,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF3ECF8E), width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: FlutterDeckTheme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
