import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../env.dart';
import 'arena_payloads.dart';

/// One Realtime channel per room: Presence for who is racing, Broadcast for
/// everything that moves.
class ArenaNet {
  ArenaNet({required this.me});

  final RacerPresence me;

  void Function(List<RacerPresence> racers)? onRacersChanged;
  void Function(KartState state)? onState;
  void Function(ThrowPayload payload)? onThrow;
  void Function(PickupPayload payload)? onPickup;
  void Function()? onHello;
  void Function(List<int> generations)? onBananas;

  RealtimeChannel? _channel;
  bool _disposed = false;
  final _subscriptions = <StreamSubscription<void>>[];

  SupabaseClient get _client => Supabase.instance.client;

  void connect() {
    final channel = _client.channel(
      'banana-arena-${Env.room}',
      options: const RealtimeChannelConfig(self: false),
    );
    _channel = channel;
    _listen(
      ArenaEvent.state,
      (json) => onState?.call(KartState.fromJson(json)),
    );
    _listen(
      ArenaEvent.throwBanana,
      (json) => onThrow?.call(ThrowPayload.fromJson(json)),
    );
    _listen(
      ArenaEvent.pickup,
      (json) => onPickup?.call(PickupPayload.fromJson(json)),
    );
    _listen(ArenaEvent.hello, (_) => onHello?.call());
    _listen(
      ArenaEvent.bananas,
      (json) => onBananas?.call((json['g'] as List).cast<int>()),
    );
    _subscriptions
      ..add(channel.onPresenceSync.listen((_) => _emitRacers()))
      ..add(channel.onPresenceJoin.listen((_) => _emitRacers()))
      ..add(channel.onPresenceLeave.listen((_) => _emitRacers()))
      ..add(
        channel.onStatusChange.listen((change) async {
          if (change.status == RealtimeSubscribeStatus.subscribed) {
            await channel.track(me.toJson());
            // Ask whoever is already here where the bananas are.
            send(ArenaEvent.hello, {});
          } else if (change.status == RealtimeSubscribeStatus.channelError ||
              change.status == RealtimeSubscribeStatus.closed) {
            _scheduleReconnect();
          }
        }),
      );
    channel.subscribe();
  }

  void _listen(
    ArenaEvent event,
    void Function(Map<String, dynamic> json) handler,
  ) {
    _subscriptions.add(
      _channel!.onBroadcast(event: event.name).listen((json) {
        if (json['id'] == me.id) {
          return;
        }
        handler(json);
      }),
    );
  }

  void send(ArenaEvent event, Map<String, dynamic> payload) {
    final channel = _channel;
    if (channel == null) {
      return;
    }
    unawaited(
      channel.sendBroadcastMessage(event: event.name, payload: payload),
    );
  }

  void _emitRacers() {
    final channel = _channel;
    if (channel == null) {
      return;
    }
    final byId = <String, RacerPresence>{};
    for (final state in channel.presenceState()) {
      for (final presence in state.presences) {
        if (RacerPresence.isValid(presence.payload)) {
          final racer = RacerPresence.fromJson(presence.payload);
          byId[racer.id] = racer;
        }
      }
    }
    onRacersChanged?.call(byId.values.toList());
  }

  void _scheduleReconnect() {
    if (_disposed) {
      return;
    }
    Timer(const Duration(seconds: 2), () async {
      if (_disposed) {
        return;
      }
      await _teardownChannel();
      connect();
    });
  }

  Future<void> _teardownChannel() async {
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    _subscriptions.clear();
    final channel = _channel;
    _channel = null;
    if (channel != null) {
      await _client.removeChannel(channel);
    }
  }

  Future<void> dispose() async {
    _disposed = true;
    await _teardownChannel();
  }
}
