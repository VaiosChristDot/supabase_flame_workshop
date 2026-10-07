import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../env.dart';
import '../game/random_username.dart';
import 'game_screen.dart';

const _green = Color(0xFF3ECF8E);

User? _signedInUser() {
  try {
    return Supabase.instance.client.auth.currentUser;
  } catch (_) {
    return null;
  }
}

class StatusScreen extends StatelessWidget {
  const StatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Multiplayer Game',
              style: Theme.of(context).textTheme.displaySmall
                  ?.copyWith(fontWeight: FontWeight.w700, letterSpacing: -1),
            ),
            const SizedBox(height: 8),
            const Text(
              'Skeleton ready. Fill in lib/src/env.dart to connect.',
              style: TextStyle(color: Colors.white60, fontSize: 16),
            ),
            const SizedBox(height: 32),
            const AuthStatus(),
            const SizedBox(height: 24),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: _green,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 18,
                ),
              ),
              icon: const Icon(Icons.sports_esports),
              label: const Text('Play', style: TextStyle(fontSize: 16)),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => GameScreen(playerName: randomUsername()),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const EnvRow(label: 'SUPABASE_URL', value: Env.supabaseUrl),
            const EnvRow(label: 'ROOM', value: Env.room),
          ],
        ),
      ),
    );
  }
}

class AuthStatus extends StatelessWidget {
  const AuthStatus({super.key});

  @override
  Widget build(BuildContext context) {
    final user = _signedInUser();
    final connected = user != null;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border.all(
          color: connected ? _green : Colors.white24,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(16),
        color: connected ? _green.withValues(alpha: 0.06) : Colors.transparent,
      ),
      child: Row(
        children: [
          Icon(
            connected ? Icons.check_circle : Icons.link_off,
            color: connected ? _green : Colors.white38,
            size: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              connected
                  ? 'Signed in anonymously as ${user.id}'
                  : 'No Supabase session yet. Check lib/src/env.dart and that '
                        'anonymous sign-ins are enabled, then hot restart.',
              style: TextStyle(
                color: connected ? _green : Colors.white70,
                fontSize: 16,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EnvRow extends StatelessWidget {
  const EnvRow({required this.label, required this.value, super.key});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white38,
                fontSize: 14,
                fontFamily: 'monospace',
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
