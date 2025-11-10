import 'dart:math';

String generateCustomToken() {
  // Custom character set (no ambiguous characters like 0, O, 1, l, I)
  const chars = '23456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghjkmnpqrstuvwxyz';
  final random = Random.secure();
  return String.fromCharCodes(Iterable.generate(
    8, 
    (_) => chars.codeUnitAt(random.nextInt(chars.length))
  ));
}