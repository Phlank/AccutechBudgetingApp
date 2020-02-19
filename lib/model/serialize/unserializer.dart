import 'dart:convert';

import 'package:budgetflow/model/serialize/map_keys.dart';
import 'package:budgetflow/model/serialize/unserialize/encrypted_strategy.dart';
import 'package:budgetflow/model/serialize/unserialize/password_strategy.dart';

abstract class Unserializer {
  static Map<String, Unserializer> strategyMap = {
    KEY_PASSWORD: PasswordStrategy(),
    KEY_ENCRYPTED: EncryptedStrategy()
  };

  static dynamic unserialize(String key, dynamic value) {
    _validate(key, value);
    if (value is String) value = jsonDecode(value);
    return strategyMap[key].unserializeValue(value);
  }

  static void _validate(String key, dynamic value) {
    if (!(value is Map || value is String)) throw InvalidSerializedValueError();
    if (!strategyMap.containsKey(key)) throw UnknownMapKeyError();
  }

  dynamic unserializeValue(dynamic value);
}

class InvalidSerializedValueError extends Error {}

class UnknownMapKeyError extends Error {}
