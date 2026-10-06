import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/particles.dart';

class Explosion extends ParticleEmitterComponent {
  Explosion({required Vector2 position, required Color color})
    : super(
        position: position,
        priority: 15,
        emitter: ParticleEmitter(
          maxParticles: 24,
          bursts: const [EmitterBurst(0, 24)],
          lifespan: (0.9, 0.9),
          speed: (40, 180),
          size: (4, 8),
          opacityOverLife: ParticleCurve(1, 0),
          colorOverLife: ColorRamp.solid(color),
        ),
        renderer: CircleParticleRenderer(),
      );
}
