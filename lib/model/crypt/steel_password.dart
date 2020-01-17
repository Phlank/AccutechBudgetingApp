import 'dart:convert';

import 'package:budgetflow/model/budget_control.dart';
import 'package:budgetflow/model/crypt/password.dart';
import 'package:steel_crypt/steel_crypt.dart';

class SteelPassword implements Password {
  static const String PASSWORD_PATH = "password";
  static const String _SERIALIZED_SALT = "salt";
  static const String _SERIALIZED_HASH = "hash";
  static const String _ALGORITHM = "scrypt";
  static const int _KEY_LENGTH = 32;

  String _secret;
  String _hash;
  String _salt;
  PassCrypt _passCrypt;

  SteelPassword(String secret) {
    _passCrypt = new PassCrypt(_ALGORITHM);
    int diffTo32 = _KEY_LENGTH - secret.length;
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

  @override
  bool verify(String secret) {
    bool success = _passCrypt.checkPassKey(_salt, secret, _hash);
    if (success) {
      _secret = secret;
      _passCrypt = new PassCrypt(_ALGORITHM);
    }
    return success;
  }

  @override
  String getHash() {
    return _hash;
  }

  @override
  String getSecret() {
    return _secret;
  }

  @override
  String getSalt() {
    return _salt;
  }

  static Password unserialize(String serialized) {
    Map map = jsonDecode(serialized);
    SteelPassword password = new SteelPassword("");
    password._salt = map[_SERIALIZED_SALT];
    password._hash = map[_SERIALIZED_HASH];
    return password;
  }

  @override
  String serialize() {
    String output = '{"salt":"' + _salt + '","hash":"' + _hash + '"}';
    return output;
  }

  static Password load() {
    Password pw;
    BudgetControl.fileIO.readFile(PASSWORD_PATH).then((String content) {
      pw = SteelPassword.unserialize(content);
    });
    return pw;
  }

  @override
  void save() {
    BudgetControl.fileIO.writeFile(PASSWORD_PATH, serialize());
  }
}
