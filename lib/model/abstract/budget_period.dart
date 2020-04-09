import 'package:budgetflow/model/data_types/allocation_list.dart';
import 'package:budgetflow/model/data_types/transaction_list.dart';

abstract class BudgetPeriod {
  Future<AllocationList> get allotted;

  Future<AllocationList> get actual;

  Future<AllocationList> get target;

  Future<TransactionList> get transactions;

  bool timeIsInMonth(DateTime input);
}
