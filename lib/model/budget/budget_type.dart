import 'package:budgetflow/model/serialize/serializable.dart';

class BudgetType implements Serializable {
  static const String GROWTH_NAME = 'Growth';
  static const String DEPLETION_NAME = 'Depletion';

  final String name;

  static const BudgetType savingGrowth = BudgetType("Growth");
  static const BudgetType savingDepletion = BudgetType("Depletion");

  const BudgetType(this.name);

  String get serialize => name;

  static BudgetType unserialize(String name) {
    if (name == 'Growth')
      return savingGrowth;
    else
      return savingDepletion;
  }
}
