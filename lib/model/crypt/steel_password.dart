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

  SteelPassword() {
    _secret = "";
    _hash = "";
    _salt = "";
    _passCrypt = new PassCrypt(_ALGORITHM);
  }

  SteelPassword.fromSecret(String secret) {
    _passCrypt = new PassCrypt(_ALGORITHM);
    int diffTo32 = _KEY_LENGTH - secret.length;
    _salt = CryptKey().genDart(diffTo32).substring(0, diffTo32);
    _hash = _passCrypt.hashPass(_salt, secret);
    _secret = secret;
  }

  SteelPassword.fromHashAndSalt(String hash, String salt) {
    _hash = hash;
    _salt = salt;
    _passCrypt = new PassCrypt(_ALGORITHM);
  }

  @override
  Future<bool> verify(String secret) {
    Future<bool> success = Future(() {
      return _passCrypt.checkPassKey(_salt, secret, _hash);
    });
    success.then((bool verified) {
      if (verified) _secret = secret;
    });
    return success;
  }

  String get hash => _hash;

  String get secret => _secret;

  String get salt => _salt;

  @override
  String serialize() {
    String output = '{"salt":"' + _salt + '","hash":"' + _hash + '"}';
    return output;
  }

  static Password unserialize(String serialized) {
    Map map = jsonDecode(serialized);
    SteelPassword password = new SteelPassword();
    password._salt = map[_SERIALIZED_SALT];
    password._hash = map[_SERIALIZED_HASH];
    return password;
  }

  static Future<Password> load() async{
    String s = await BudgetControl.fileIO.readFile(PASSWORD_PATH);
    return unserialize(s);
  }

  @override
  void save() {
    BudgetControl.fileIO.writeFile(PASSWORD_PATH, serialize());
  }
}
