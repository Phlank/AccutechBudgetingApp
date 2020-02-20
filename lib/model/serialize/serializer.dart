import 'dart:convert';

import 'package:budgetflow/model/serialize/map_keys.dart';
import 'package:budgetflow/model/serialize/serializable.dart';
import 'package:budgetflow/model/serialize/unserialize/budget_type_strategy.dart';
import 'package:budgetflow/model/serialize/unserialize/category_strategy.dart';
import 'package:budgetflow/model/serialize/unserialize/encrypted_strategy.dart';
import 'package:budgetflow/model/serialize/unserialize/month_strategy.dart';
import 'package:budgetflow/model/serialize/unserialize/password_strategy.dart';
import 'package:budgetflow/model/serialize/unserialize/priority_strategy.dart';
import 'package:budgetflow/model/serialize/unserialize/transaction_list_strategy.dart';
import 'package:budgetflow/model/serialize/unserialize/transaction_strategy.dart';
import 'package:budgetflow/model/serialize/unserializer.dart';

class Serializer implements Serializable {
  static Map<String, Unserializer> strategyMap = {
    KEY_PASSWORD: PasswordStrategy(),
    KEY_ENCRYPTED: EncryptedStrategy(),
    KEY_TRANSACTION: TransactionStrategy(),
    KEY_CATEGORY: CategoryStrategy(),
    KEY_PRIORITY: PriorityStrategy(),
    KEY_TRANSACTION_LIST: TransactionListStrategy(),
    KEY_MONTH: MonthStrategy(),
    KEY_TYPE: BudgetTypeStrategy()
  };

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

  static dynamic unserialize(String key, dynamic value) {
    _validate(key, value);
    if (value is String) value = jsonDecode(value);
    return strategyMap[key].unserializeValue(value);
  }

  static void _validate(String key, dynamic value) {
    if (!(value is Map || value is String)) throw InvalidSerializedValueError();
    if (!strategyMap.containsKey(key)) throw UnknownMapKeyError();
  }
}
