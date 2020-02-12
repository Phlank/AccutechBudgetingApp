import 'dart:convert';
import 'dart:math';

class Encrypted {
  final String iv, cipher;

  Encrypted(this.iv, this.cipher);

  static Encrypted unserialize(String serialized) {
    Map map = jsonDecode(serialized);
    String iv = map["iv"];
    String cipher = map["cipher"];
    return new Encrypted(iv, cipher);
  }

  String serialize() {
    String output = '{"iv":"' + iv + '","cipher":"' + cipher + '"}';
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
