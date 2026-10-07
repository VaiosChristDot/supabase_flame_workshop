import 'dart:math';

const _adjectives = [
  'Neon',
  'Turbo',
  'Pixel',
  'Cosmic',
  'Laser',
  'Hyper',
  'Retro',
  'Nitro',
  'Electric',
  'Midnight',
];

const _nouns = [
  'Monkey',
  'Gorilla',
  'Lemur',
  'Racer',
  'Comet',
  'Falcon',
  'Panda',
  'Tiger',
];

String randomUsername([Random? random]) {
  final rng = random ?? Random();
  final adjective = _adjectives[rng.nextInt(_adjectives.length)];
  final noun = _nouns[rng.nextInt(_nouns.length)];
  return '$adjective$noun${10 + rng.nextInt(90)}';
}
