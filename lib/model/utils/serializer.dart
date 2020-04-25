import 'dart:convert';

import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/abstract/serializable.dart';
import 'package:budgetflow/model/abstract/unserializer.dart';
import 'package:budgetflow/model/implementations/unserialize/account_list_strategy.dart';
import 'package:budgetflow/model/implementations/unserialize/account_strategy.dart';
import 'package:budgetflow/model/implementations/unserialize/achievement_list_strategy.dart';
import 'package:budgetflow/model/implementations/unserialize/achievement_strategy.dart';
import 'package:budgetflow/model/implementations/unserialize/allocation_list_strategy.dart';
import 'package:budgetflow/model/implementations/unserialize/allocation_strategy.dart';
import 'package:budgetflow/model/implementations/unserialize/budget_type_strategy.dart';
import 'package:budgetflow/model/implementations/unserialize/category_strategy.dart';
import 'package:budgetflow/model/implementations/unserialize/encrypted_strategy.dart';
import 'package:budgetflow/model/implementations/unserialize/history_strategy.dart';
import 'package:budgetflow/model/implementations/unserialize/location_strategy.dart';
import 'package:budgetflow/model/implementations/unserialize/method_list_strategy.dart';
import 'package:budgetflow/model/implementations/unserialize/method_strategy.dart';
import 'package:budgetflow/model/implementations/unserialize/month_strategy.dart';
import 'package:budgetflow/model/implementations/unserialize/password_strategy.dart';
import 'package:budgetflow/model/implementations/unserialize/priority_strategy.dart';
import 'package:budgetflow/model/implementations/unserialize/transaction_list_strategy.dart';
import 'package:budgetflow/model/implementations/unserialize/transaction_strategy.dart';

/// The serializer class has helper methods to aid in serializing and a universal unserialize method.
///
/// JSON serialization is built into Dart, but it makes use of the Reflections
/// library. Unfortunately, the Reflections library is not supported in Flutter
/// due to the massive growth in app size that would result in using it.
/// There were other options for implementing serialization into the codebase
/// via automatic code generation, but they didn't quite fit our needs.
///
/// JSON strings are output from this class with [serialize], and prior to this,
/// JSON pairs can be added through [addPair]. The output strings appear as
/// follows, without the whitespace formatting:
/// ```
/// {
///   "key1":"reflected value 1",
///   "key2":"reflected value 2",
///   "key3":{
///             "subKey1":"sub reflected value 1",
///          },
///   ...
/// }
/// ```
/// For each type of object that needs to be unserialized, there is an
/// unserializer strategy. Each of these can be found in the [strategyMap].
class Serializer implements Serializable {
  /// Map of keys to the objects they indicate need unserialized. Used by [unserialize].
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
    allocationListKey: AllocationListStrategy(),
    allocationKey: AllocationStrategy(),
    methodKey: MethodStrategy(),
    accountKey: AccountStrategy(),
    methodListKey: MethodListStrategy(),
    accountListKey: AccountListStrategy(),
    achievementKey: AchievementStrategy(),
    achievementListKey: AchievementListStrategy(),
  };

  Map<dynamic, dynamic> pairs;

  Serializer() {
    pairs = new Map();
  }

  /// Adds a pair for serialization of an object.
  ///
  /// [key] options are defined in lib/global/strings. If [value] is a [String],
  /// the raw string is reflected in the output serialization. If [value] is a
  /// [Serializable], then the result of [value.serialize] is reflected in the
  /// output serialization. If [value] is neither of these things,
  /// [value.toString] is reflected in the output serialization.
  ///
  /// Output raw text from [serialize] will look like:
  /// ```
  /// "[key]":"[reflected value]"
  /// ```
  void addPair(dynamic key, dynamic value) {
    pairs[key] = value;
  }

  /// Returns the value side of a key-value pair used in storing this object as a JSON object.
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

  /// Returns an object from its serialization.
  ///
  /// The given [value] based on the type of object required, denoted by [key].
  /// [value] must be a [Map], [String], or `null`, otherwise an [InvalidSerializedValueError] will be thrown.
  /// [key] must be a key in [strategyMap], otherwise an [UnknownMapKeyError] will be thrown.
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
