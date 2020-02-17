import 'dart:convert';
import 'dart:math';

import 'package:budgetflow/model/file_io/serializable.dart';

class Encrypted implements Serializable {
  static const String _IV_KEY = 'iv';
  static const String _CIPHER_KEY = 'cipher';
  final String iv, cipher;

  Encrypted(this.iv, this.cipher);

  static Encrypted unserialize(String serialized) {
    Map map = jsonDecode(serialized);
    String iv = map[_IV_KEY];
    String cipher = map[_CIPHER_KEY];
    return new Encrypted(iv, cipher);
  }

  String get serialize {
    String output = '{"$_IV_KEY":"$iv","$_CIPHER_KEY":"$cipher"}';
    return output;
  }
}

String generateRandom(int length) {
  String output;
  Random random = Random.secure();
  var randBytes;
  randBytes = List<int>.generate(length, (i) => random.nextInt(256));
  output = base64Url.encode(randBytes);
  output = output.substring(0, length);
  return output;
}
