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

  static Password fromSecret(String secret) {
    SteelPassword pw = new SteelPassword();
    pw._passCrypt = new PassCrypt(_ALGORITHM);
    int diffTo32 = _KEY_LENGTH - secret.length;
    pw._salt = CryptKey().genDart(diffTo32).substring(0, diffTo32);
    pw._hash = pw._passCrypt.hashPass(pw._salt, secret);
    pw._secret = secret;
    return pw;
  }

  static Password fromHashAndSalt(String hash, String salt) {
    SteelPassword pw = new SteelPassword();
    pw._hash = hash;
    pw._salt = salt;
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
