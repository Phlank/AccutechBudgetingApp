import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/abstract/unserializer.dart';
import 'package:budgetflow/model/history/history.dart';
import 'package:budgetflow/model/utils/serializer.dart';

class HistoryStrategy implements Unserializer {
  @override
  unserializeValue(Map value) {
    History output = History();
    value.forEach((key, value) {
      output.addMonth(Serializer.unserialize(monthKey, value));
    });
    return output;
  }
}
