import 'dart:convert';
import 'dart:typed_data';

import 'package:budgetflow/model/budget_control.dart';
import 'package:budgetflow/model/crypt/password.dart';
import 'package:budgetflow/model/serialize/map_keys.dart';
import 'package:budgetflow/model/serialize/serializer.dart';
import 'package:steel_crypt/PointyCastleN/api.dart';
import 'package:steel_crypt/PointyCastleN/export.dart';

import 'encrypted.dart';

class SteelPassword implements Password {
  static const String PASSWORD_PATH = "password";
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

  String get serialize {
    Serializer serializer = Serializer();
    serializer.addPair(KEY_SALT, _salt);
    serializer.addPair(KEY_HASH, _hash);
    return serializer.serialize;
  }

  static Password unserialize(String serialized) {
    Map map = jsonDecode(serialized);
    return SteelPassword.fromHashAndSalt(map[KEY_HASH], map[KEY_SALT]);
  }

  static Future<Password> load() async {
    String s = await BudgetControl.fileIO.readFile(PASSWORD_PATH);
    return unserialize(s);
  }

  @override
  void save() {
    BudgetControl.fileIO.writeFile(PASSWORD_PATH, serialize);
  }
}
