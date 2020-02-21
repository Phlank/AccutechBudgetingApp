import 'package:budgetflow/model/budget/budget_type.dart';
import 'package:budgetflow/model/serialize/map_keys.dart';
import 'package:budgetflow/model/serialize/unserializer.dart';

class BudgetTypeStrategy implements Unserializer {
  @override
  unserializeValue(Map value) {
    if (value[KEY_NAME] == BudgetType.GROWTH_NAME) return BudgetType.growth;
    return BudgetType.depletion;
  }
}
