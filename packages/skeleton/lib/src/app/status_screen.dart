import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../env.dart';

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
              'Skeleton ready. Start with exercise 1 in lib/main.dart.',
              style: TextStyle(color: Colors.white60, fontSize: 16),
            ),
            const SizedBox(height: 32),
            const AuthStatus(),
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
                  : 'No Supabase session yet. Initialize Supabase and sign in '
                        'anonymously, then hot restart.',
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
