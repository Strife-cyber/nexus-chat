import 'dart:convert';
import 'package:crypto/crypto.dart';

String hashString(String input) {
  /// Hashes a string
  final saltedInput = '${input}2500*dark';
  final bytes = utf8.encode(saltedInput);
  final digest = sha256.convert(bytes);
  return digest.toString();
}
