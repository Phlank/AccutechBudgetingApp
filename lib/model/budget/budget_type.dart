import 'package:budgetflow/model/serialize/map_keys.dart';
import 'package:budgetflow/model/serialize/serializable.dart';
import 'package:budgetflow/model/serialize/serializer.dart';

class BudgetType implements Serializable {
  static const String GROWTH_NAME = 'Growth';
  static const String DEPLETION_NAME = 'Depletion';

  final String name;

  static const BudgetType growth = BudgetType("Growth");
  static const BudgetType depletion = BudgetType("Depletion");

  const BudgetType(this.name);

  String get serialize {
    Serializer serializer = Serializer();
    serializer.addPair(KEY_NAME, name);
    return serializer.serialize;
  }
}
