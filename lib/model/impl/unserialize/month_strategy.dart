import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/abstract/unserializer.dart';
import 'package:budgetflow/model/history/month.dart';
import 'package:budgetflow/model/history/month_time.dart';
import 'package:budgetflow/model/serialize/serializer.dart';

class MonthStrategy implements Unserializer {
  @override
  unserializeValue(Map value) {
    return Month(
      type: Serializer.unserialize(typeKey, value[typeKey]),
      income: double.parse(value[incomeKey]),
      monthTime:
      MonthTime(int.parse(value[yearKey]), int.parse(value[monthKey])),
    );
  }
}
