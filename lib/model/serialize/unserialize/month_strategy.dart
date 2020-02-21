import 'package:budgetflow/model/history/month.dart';
import 'package:budgetflow/model/history/month_time.dart';
import 'package:budgetflow/model/serialize/map_keys.dart';
import 'package:budgetflow/model/serialize/serializer.dart';
import 'package:budgetflow/model/serialize/unserializer.dart';

class MonthStrategy implements Unserializer {
  @override
  unserializeValue(Map value) {
    MonthBuilder builder = MonthBuilder();
    builder.setIncome(double.parse(value[KEY_INCOME]));
    builder.setMonthTime(
        MonthTime(int.parse(value[KEY_YEAR]), int.parse(value[KEY_MONTH])));
    builder.setType(Serializer.unserialize(KEY_TYPE, value[KEY_TYPE]));
    return builder.build();
  }
}
