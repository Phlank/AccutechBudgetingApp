import 'package:budgetflow/model/history/month.dart';
import 'package:budgetflow/model/history/month_time.dart';
import 'package:budgetflow/model/serialize/map_keys.dart';
import 'package:budgetflow/model/serialize/serializer.dart';
import 'package:budgetflow/model/serialize/unserializer.dart';

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
