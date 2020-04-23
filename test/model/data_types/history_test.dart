import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/data_types/budget_type.dart';
import 'package:budgetflow/model/data_types/history.dart';
import 'package:budgetflow/model/data_types/month.dart';
import 'package:budgetflow/model/utils/dates.dart';
import 'package:budgetflow/model/utils/serializer.dart';
import 'package:flutter_test/flutter_test.dart';

History history;
Month month1, month2, month3;

void main() {
  group('History Tests', () {
    setUp(() {
      month1 =
          Month(time: DateTime.now(), income: 2000, type: BudgetType.growth);
      month2 = Month(
          time: Dates.getNthPreviousMonthTime(1),
          income: 2200,
          type: BudgetType.depletion);
      month3 = Month(
          time: Dates.getNthPreviousMonthTime(2),
          income: 2000,
          type: BudgetType.growth);
      history = History();
      history.add(month1);
      history.add(month2);
      history.add(month3);
    });
    test('Serialization sanity', () {
      String serialized = history.serialize;
      History fromSerialized = Serializer.unserialize(historyKey, serialized);
      expect(history == fromSerialized, isTrue);
    });
  });
}
