import 'dart:collection';

import 'package:budgetflow/budget/transaction.dart';

class TransactionList {
	List<Transaction> _transactions;

	TransactionList() {
		_transactions = new List();
	}

	void foreach(f(Transaction t)) {
		
	}
}