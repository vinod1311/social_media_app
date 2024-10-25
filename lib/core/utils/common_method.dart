import 'dart:math';

final List<String> adjectives = [
  'Cool', 'Quick', 'Happy', 'Bright', 'Smart', 'Clever', 'Bold', 'Brave', 'Swift'
];

final List<String> nouns = [
  'Lion', 'Tiger', 'Eagle', 'Falcon', 'Shark', 'Panther', 'Wolf', 'Bear', 'Hawk'
];

String generateRandomUsername() {
  final random = Random();
  final adjective = adjectives[random.nextInt(adjectives.length)];
  final noun = nouns[random.nextInt(nouns.length)];
  final number = random.nextInt(1000);

  return '$adjective$noun$number';
}