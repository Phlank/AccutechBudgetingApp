import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/abstract/serializable.dart';
import 'package:budgetflow/model/utils/serializer.dart';

/// A specification of how to create and change a budget within the [PriorityBudgetFactory].
class BudgetType implements Serializable {
  static const String growthName = 'Growth';
  static const String depletionName = 'Depletion';

  final String name;

  static const BudgetType growth = BudgetType._(growthName);
  static const BudgetType depletion = BudgetType._(depletionName);

  const BudgetType._(this.name);

  /// Returns a BudgetType given a specified [name].
  ///
  /// Valid inputs for [name] are `'Growth'` and `'Depletion'`. If [name] does
  /// not match either of these, an [_InvalidNameError] is thrown.
  static BudgetType parseName(String name) {
    if (name == growthName) return growth;
    if (name == depletionName) return depletion;
    throw _InvalidNameError();
  }

  /// Returns the value side of a key-value pair used in storing this object as a JSON object.
  String get serialize {
    Serializer serializer = Serializer();
    serializer.addPair(nameKey, name);
    return serializer.serialize;
  }
}

class _InvalidNameError extends Error {}
