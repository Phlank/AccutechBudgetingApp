import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/abstract/unserializer.dart';
import 'package:budgetflow/model/data_types/budget_type.dart';

class BudgetTypeStrategy implements Unserializer {
  @override
  unserializeValue(Map value) {
    return BudgetType.parseName(value[nameKey]);
  }
}
