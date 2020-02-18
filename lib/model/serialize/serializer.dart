import 'dart:convert';

import 'package:budgetflow/model/serialize/serializable.dart';

class Serializer implements Serializable {
  Map<dynamic, dynamic> pairs;

  Serializer() {
    pairs = new Map();
  }

  void addPair(dynamic key, dynamic value) {
    pairs[key] = value;
  }

  String get serialize {
    String output = '{';
    int i = 0;
    pairs.forEach((dynamic key, dynamic value) {
      String resolvedKey = _resolve(key);
      String resolvedValue = _resolve(value);
      String paddedKey = _padIfNeeded(resolvedKey);
      String paddedValue = _padIfNeeded(resolvedValue);
      output += '$paddedKey:$paddedValue';
      i++;
      if (i != pairs.length) {
        output += ',';
      }
    });
    output += '}';
    return output;
  }

  static String _resolve(dynamic input) {
    if (input is String) return input;
    if (input is Serializable) return input.serialize;
    return input.toString();
  }

  static String _padIfNeeded(String value) {
    bool needsPadding = !(value.contains('{') || value.contains('"'));
    if (needsPadding) {
      return '"$value"';
    }
    return value;
  }

  dynamic unserialize(dynamic input) {
    if (input is String) {
      if (input.contains('{')) {
        input = jsonDecode(input);
      }
    }
  }

  static dynamic _unserializeDecoded(Map input) {
    return null;
  }
}
