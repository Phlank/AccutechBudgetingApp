import 'package:budgetflow/model/history/month.dart';
import 'package:budgetflow/model/history/month_time.dart';
import 'package:budgetflow/model/serialize/map_keys.dart';
import 'package:budgetflow/model/serialize/serializer.dart';
import 'package:budgetflow/model/serialize/unserializer.dart';

class MonthStrategy implements Unserializer {
  @override
  unserializeValue(Map value) {
    MonthBuilder builder = MonthBuilder();
    builder.setIncome(double.parse(value[incomeKey]));
    builder.setMonthTime(
        MonthTime(int.parse(value[yearKey]), int.parse(value[monthKey])));
    builder.setType(Serializer.unserialize(typeKey, value[typeKey]));
    return builder.build();
  }
}
