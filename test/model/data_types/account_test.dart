import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/data_types/account.dart';
import 'package:budgetflow/model/utils/serializer.dart';
import 'package:flutter_test/flutter_test.dart';

Account account;

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
}
