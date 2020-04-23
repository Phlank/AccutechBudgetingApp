import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/data_types/account.dart';
import 'package:budgetflow/model/data_types/account_list.dart';
import 'package:budgetflow/model/utils/serializer.dart';
import 'package:flutter_test/flutter_test.dart';

Account account;
Account account1, account2, account3;
AccountList accountList;

void main() {
  group('Account Tests', () {
    setUp(() {
      account = Account(
        methodName: 'something',
        accountName: 'something else',
        beginning: DateTime.now(),
      );
    });
    test('Serialization sanity', () {
      String accountSerialization = account.serialize;
      Account fromSerialization =
          Serializer.unserialize(accountKey, accountSerialization);
      expect(account == fromSerialization, isTrue);
    });
  });
  group('Account List Tests', () {
    setUp(() {
      accountList = AccountList();
      account1 = Account(methodName: 'account1',
          accountName: 'account1Name',
          beginning: DateTime.now());
      account2 = Account(methodName: 'account2',
          accountName: 'account2Name',
          beginning: DateTime.now());
      account3 = Account(methodName: 'account3',
          accountName: 'account3Name',
          beginning: DateTime.now());
      accountList.add(account1);
      accountList.add(account2);
      accountList.add(account3);
    });
    test('Serialization sanity', () {
      String serialized = accountList.serialize;
      AccountList fromSerialized = Serializer.unserialize(
          accountListKey, serialized);
      expect(accountList == fromSerialized, isTrue);
    });
  });
}
