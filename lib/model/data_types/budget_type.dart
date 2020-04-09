import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/abstract/serializable.dart';
import 'package:budgetflow/model/utils/serializer.dart';

class BudgetType implements Serializable {
  static const String growthName = 'Growth';
  static const String depletionName = 'Depletion';

  final String name;

  static const BudgetType growth = BudgetType._(growthName);
  static const BudgetType depletion = BudgetType._(depletionName);

  const BudgetType._(this.name);

  /// Returns the value side of a key-value pair used in storing this object as a JSON object.
  /// Returns the value side of a key-value pair used in storing this object as a JSON object.
  String get serialize {
    Serializer serializer = Serializer();
    serializer.addPair(nameKey, name);
    return serializer.serialize;
  }
}
