import 'package:budgetflow/model/serialize/map_keys.dart';
import 'package:budgetflow/model/serialize/serializable.dart';
import 'package:budgetflow/model/serialize/serializer.dart';

class BudgetType implements Serializable {
  static const String growthName = 'Growth';
  static const String depletionName = 'Depletion';

  final String name;

  static const BudgetType growth = BudgetType._(growthName);
  static const BudgetType depletion = BudgetType._(depletionName);

  const BudgetType._(this.name);

  String get serialize {
    Serializer serializer = Serializer();
    serializer.addPair(nameKey, name);
    return serializer.serialize;
  }
}
