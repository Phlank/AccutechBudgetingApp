import 'dart:convert';
import 'dart:math';

import 'package:budgetflow/model/serialize/map_keys.dart';
import 'package:budgetflow/model/serialize/serializable.dart';
import 'package:budgetflow/model/serialize/serializer.dart';

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
    Serializer serializer = Serializer();
    serializer.addPair(KEY_IV, iv);
    serializer.addPair(KEY_CIPHER, cipher);
    return serializer.serialize;
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
