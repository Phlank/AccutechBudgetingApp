import 'dart:convert';

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
    String output = "{\"iv\":\"" + iv + "\",\"cipher\":\"" + cipher + "\"}";
    return output;
  }
}
