import 'dart:collection';

import 'package:budgetflow/budget/transaction.dart';

class TransactionList {
	List<Transaction> _transactions;

	TransactionList() {
		_transactions = new List();
	}

	void add(Transaction t) {
		_transactions.add(t);
	}

	int length() {
		return _transactions.length;
	}

	void removeAt(int index) {
		_transactions.removeAt(index);
	}

	String serialize() {
		String output = "{";
		for(int i = 0; i < _transactions.length; i++) {
			output += "\"" + i.toString() + "\":\"[";
			output += "\"";
		}
		return output;
	}

	static TransactionList fromSerialized(String serialized) {

	}
}