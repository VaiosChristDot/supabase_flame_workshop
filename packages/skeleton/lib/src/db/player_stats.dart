// The typed table access API is still experimental.
// ignore_for_file: experimental_member_use

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_schema.g.dart';

/// The local racer's row in `players`. Counts change locally right away and
/// are written back by [flush], so a burst of pickups costs one request.
class PlayerStats {
  PlayerStats(this._client);

  final SupabaseClient _client;

  final owned = ValueNotifier<int>(0);
  int _collected = 0;
  int _slipped = 0;
  bool _dirty = false;
  bool _saving = false;

  String? get _userId => _client.auth.currentUser?.id;

  /// Creates the row on first play, or renames it and restores its counts.
  Future<void> join(String name) async {
    final id = _userId;
    if (id == null) {
      return;
    }
    try {
      final rows = await _client
          .table(Players.table)
          .upsert(
            PlayersInsert(id: id, name: name, updatedAt: DateTime.now()),
            defaultToNull: false,
          )
          .select();
      final row = rows.single;
      owned.value = row.bananasOwned;
      _collected = row.bananasCollected;
      _slipped = row.timesSlipped;
    } on Exception catch (error) {
      debugPrint('Could not join as a player: $error');
    }
  }

  void collect() {
    owned.value++;
    _collected++;
    _dirty = true;
  }

  void spend() {
    owned.value--;
    _dirty = true;
  }

  void slip() {
    _slipped++;
    _dirty = true;
  }

  Future<void> flush() async {
    final id = _userId;
    if (id == null || !_dirty || _saving) {
      return;
    }
    _dirty = false;
    _saving = true;
    try {
      await _client
          .table(Players.table)
          .update(
            PlayersUpdate(
              bananasOwned: owned.value,
              bananasCollected: _collected,
              timesSlipped: _slipped,
              updatedAt: DateTime.now(),
            ),
          )
          .where(Players.id.eq(id));
    } on Exception catch (error) {
      _dirty = true;
      debugPrint('Could not save player stats: $error');
    } finally {
      _saving = false;
    }
  }
}
