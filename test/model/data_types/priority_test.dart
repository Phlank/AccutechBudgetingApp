import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/data_types/priority.dart';
import 'package:budgetflow/model/utils/serializer.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group('Priority Tests', () {
    test('Priorities not equal to each other', () {
      expect(Priority.income == Priority.wants, isFalse);
      expect(Priority.income == Priority.needs, isFalse);
      expect(Priority.income == Priority.savings, isFalse);
      expect(Priority.income == Priority.other, isFalse);
      expect(Priority.income == Priority.required, isFalse);
    });
    test('Serialization sanity', () {
      String serialized = Priority.income.serialize;
      Priority fromSerialized = Serializer.unserialize(priorityKey, serialized);
      expect(Priority.income == fromSerialized, isTrue);
    });
  });
}
