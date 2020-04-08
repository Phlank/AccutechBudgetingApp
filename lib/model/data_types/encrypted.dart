import 'dart:convert';
import 'dart:math';

import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/abstract/serializable.dart';
import 'package:budgetflow/model/utils/serializer.dart';

class Encrypted implements Serializable {
  final String iv, cipher;

  Encrypted(this.iv, this.cipher);

  String get serialize {
    Serializer serializer = Serializer();
    serializer.addPair(ivKey, iv);
    serializer.addPair(cipherKey, cipher);
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
