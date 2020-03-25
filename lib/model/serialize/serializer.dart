import 'dart:convert';

import 'package:budgetflow/model/serialize/map_keys.dart';
import 'package:budgetflow/model/serialize/serializable.dart';
import 'package:budgetflow/model/serialize/unserialize/allocationListStrategy.dart';
import 'package:budgetflow/model/serialize/unserialize/allocationStrategy.dart';
import 'package:budgetflow/model/serialize/unserialize/budget_map_strategy.dart';
import 'package:budgetflow/model/serialize/unserialize/budget_type_strategy.dart';
import 'package:budgetflow/model/serialize/unserialize/category_strategy.dart';
import 'package:budgetflow/model/serialize/unserialize/encrypted_strategy.dart';
import 'package:budgetflow/model/serialize/unserialize/history_strategy.dart';
import 'package:budgetflow/model/serialize/unserialize/location_strategy.dart';
import 'package:budgetflow/model/serialize/unserialize/month_strategy.dart';
import 'package:budgetflow/model/serialize/unserialize/password_strategy.dart';
import 'package:budgetflow/model/serialize/unserialize/priority_strategy.dart';
import 'package:budgetflow/model/serialize/unserialize/transaction_list_strategy.dart';
import 'package:budgetflow/model/serialize/unserialize/transaction_strategy.dart';
import 'package:budgetflow/model/serialize/unserializer.dart';

class Serializer implements Serializable {
  static Map<String, Unserializer> strategyMap = {
    passwordKey: PasswordStrategy(),
    encryptedKey: EncryptedStrategy(),
    transactionKey: TransactionStrategy(),
    categoryKey: CategoryStrategy(),
    priorityKey: PriorityStrategy(),
    transactionListKey: TransactionListStrategy(),
    monthKey: MonthStrategy(),
    typeKey: BudgetTypeStrategy(),
    historyKey: HistoryStrategy(),
    locationKey: LocationStrategy(),
    budgetMapKey: BudgetMapStrategy(),
    allocationListKey: AllocationListStrategy(),
    allocationKey: AllocationStrategy(),
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
    if (value != "null" && value != null) {
      bool needsPadding = !(value.contains('{') || value.contains('"'));
      if (needsPadding) {
        return '"$value"';
      }
      return value;
    }
    return "null";
  }

  static dynamic unserialize(String key, dynamic value) {
    _validate(key, value);
    if (value is String) value = jsonDecode(value);
    return strategyMap[key].unserializeValue(value);
  }

  static void _validate(String key, dynamic value) {
    if (!(value is Map || value is String || value == null))
      throw InvalidSerializedValueError();
    if (!strategyMap.containsKey(key)) throw UnknownMapKeyError();
  }
}
