import 'dart:convert';

import 'package:budgetflow/model/crypt/password.dart';
import 'package:steel_crypt/steel_crypt.dart';

class SteelPassword implements Password {
  static const String SERIALIZED_SALT = "salt";
  static const String SERIALIZED_HASH = "hash";
  static const String ALGORITHM = "scrypt";
  static const int KEY_LENGTH = 32;

  String _secret;
  String _hash;
  String _salt;
  PassCrypt _passCrypt;

  SteelPassword(String secret) {
    _passCrypt = new PassCrypt(ALGORITHM);
    int diffTo32 = KEY_LENGTH - secret.length;
    _salt = CryptKey().genDart(diffTo32).substring(0, diffTo32);
    _hash = _passCrypt.hashPass(_salt, secret);
    _secret = secret;
  }

  // This needs to exist so we have something to call verify() on.
  // Without this function, we have to work with the bare bone libraries, and
  // that's just nasty. When verify() is called, it should make all other
  // functions usable because it takes secret and salt as params.
  static Password fromHashAndSalt(String hash, String salt) {
    SteelPassword pw = new SteelPassword("");
    pw._hash = hash;
    pw._salt = salt;
    pw._secret = "";
    return pw;
  }

  bool verify(String secret, String salt) {
    bool success = _passCrypt.checkPassKey(salt, secret, _hash);
    if (success) {
      _secret = secret;
      _salt = salt;
      _passCrypt = new PassCrypt(ALGORITHM);
    }
    return success;
  }

  String getHash() {
    return _hash;
  }

  String getSecret() {
    return _secret;
  }

  String getSalt() {
    return _salt;
  }

  static Password unserialize(String serialized) {
    Map map = jsonDecode(serialized);
    SteelPassword password = new SteelPassword("");
    password._salt = map[SERIALIZED_SALT];
    password._hash = map[SERIALIZED_HASH];
    return password;
  }

  String serialize() {
    String output = "{\"salt\":\"" + _salt + "\",\"hash\":\"" + _hash + "\"}";
    return output;
  }
}
