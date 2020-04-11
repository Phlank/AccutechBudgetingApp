import 'dart:convert';
import 'dart:typed_data';

import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/abstract/password.dart';
import 'package:budgetflow/model/budget_control.dart';
import 'package:budgetflow/model/utils/serializer.dart';
import 'package:steel_crypt/PointyCastleN/api.dart';
import 'package:steel_crypt/PointyCastleN/export.dart';

import '../data_types/encrypted.dart';

class SteelPassword implements Password {
  static const String _algorithm = 'scrypt';
  static const int _keyLength = 32;
  static const int _scryptN = 4096;
  static const int _scryptR = 16;
  static const int _scryptP = 1;

  String _secret;
  String _hash;
  String _salt;
  KeyDerivator _keyDerivator;

  SteelPassword() {
    _secret = "";
    _hash = "";
    _salt = "";
    _keyDerivator = KeyDerivator(_algorithm);
  }

  SteelPassword.fromSecret(String secret) {
    _secret = secret;
    _salt = _generateSalt(secret);
    _keyDerivator = _generateKeyDerivator(_salt);
    _hash = _generateHash(_secret, _keyDerivator);
  }

  static String _generateSalt(String secret) {
    int diff = _keyLength - secret.length;
    return generateRandom(diff);
  }

  static KeyDerivator _generateKeyDerivator(String salt) {
    Uint8List saltBytes = Uint8List.fromList(salt.codeUnits);
    ScryptParameters params =
        ScryptParameters(_scryptN, _scryptR, _scryptP, _keyLength, saltBytes);
    KeyDerivator output = KeyDerivator(_algorithm);
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
    _keyDerivator = KeyDerivator(_algorithm);
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
    success.catchError((error) {
      return false;
    });
    return success;
  }

  String get hash => _hash;

  String get secret => _secret;

  String get salt => _salt;

  /// Returns the value side of a key-value pair used in storing this object as a JSON object.
  /// Returns the value side of a key-value pair used in storing this object as a JSON object.
  String get serialize {
    Serializer serializer = Serializer();
    serializer.addPair(saltKey, _salt);
    serializer.addPair(hashKey, _hash);
    return serializer.serialize;
  }

  static Future<Password> load() async {
    String s = await BudgetControl.fileIO.readFile(passwordFilepath);
    return Serializer.unserialize(passwordKey, s);
  }

  @override
  void save() {
    BudgetControl.fileIO.writeFile(passwordFilepath, serialize);
  }
}
