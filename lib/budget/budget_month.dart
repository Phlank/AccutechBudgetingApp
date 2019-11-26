import 'package:budgetflow/budget/budget_category.dart';
import 'package:budgetflow/budget/transaction_month.dart';

class BudgetMonth {

    Map<BudgetCategory, double> _allottedSpending, _actualSpending;
    TransactionMonth transactions;

    double getSpending(BudgetCategory category) {
        return _actualSpending[category];
    }

    double getAllotment(BudgetCategory category) {
        return _allottedSpending[category];
    }

}