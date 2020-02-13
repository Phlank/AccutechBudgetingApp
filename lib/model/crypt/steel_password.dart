import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:budgetflow/model/budget_control.dart';
import 'package:budgetflow/model/crypt/password.dart';
import 'package:steel_crypt/PointyCastleN/api.dart';
import 'package:steel_crypt/PointyCastleN/export.dart';

import 'encrypted.dart';

class SteelPassword implements Password {
  static const String PASSWORD_PATH = "password";
  static const String _SALT_KEY = "salt";
  static const String _HASH_KEY = "hash";
  static const String _ALGORITHM = "scrypt";
  static const int _KEY_LENGTH = 32;
  static const int _SCRYPT_N = 4096;
  static const int _SCRYPT_r = 16;
  static const int _SCRYPT_p = 1;

  String _secret;
  String _hash;
  String _salt;
  KeyDerivator _keyDerivator;

  SteelPassword() {
    _secret = "";
    _hash = "";
    _salt = "";
    _keyDerivator = KeyDerivator(_ALGORITHM);
  }

  SteelPassword.fromSecret(String secret) {
    _secret = secret;
    _salt = _generateSalt(secret);
    _keyDerivator = _generateKeyDerivator(_salt);
    _hash = _generateHash(_secret, _keyDerivator);
  }

  static String _generateSalt(String secret) {
    int diff = _KEY_LENGTH - secret.length;
    return generateRandom(diff);
  }

  static KeyDerivator _generateKeyDerivator(String salt) {
    Uint8List saltBytes = Uint8List.fromList(salt.codeUnits);
    ScryptParameters params = ScryptParameters(
        _SCRYPT_N, _SCRYPT_r, _SCRYPT_p, _KEY_LENGTH, saltBytes);
    KeyDerivator output = KeyDerivator(_ALGORITHM);
    output.init(params);
    return output;
  }

  static String _generateHash(String secret, KeyDerivator keyDerivator) {
    List<int> secretBytes = Uint8List.fromList(utf8.encode(secret));
    return base64.encode(keyDerivator.process(secretBytes));
  }

  SteelPassword.fromHashAndSalt(String hash, String salt) {
    _hash = hash;
    _salt = salt;
    _keyDerivator = KeyDerivator(_ALGORITHM);
  }

  @override
  Future<bool> verify(String secret) {
    Future<bool> success = Future(() {
      KeyDerivator inputKeyDerivator = _generateKeyDerivator(_salt);
      String inputHash = _generateHash(secret, inputKeyDerivator);
      return inputHash == _hash;
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
    String output = '{"$_SALT_KEY":"$_salt","$_HASH_KEY":"$_hash"}';
    return output;
  }

  static Password unserialize(String serialized) {
    Map map = jsonDecode(serialized);
    SteelPassword password = new SteelPassword();
    password._salt = map[_SALT_KEY];
    password._hash = map[_HASH_KEY];
    return password;
  }

  static Future<Password> load() async {
    String s = await BudgetControl.fileIO.readFile(PASSWORD_PATH);
    return unserialize(s);
  }

  @override
  void save() {
    BudgetControl.fileIO.writeFile(PASSWORD_PATH, serialize());
  }
}
