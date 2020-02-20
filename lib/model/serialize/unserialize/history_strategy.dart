import 'package:budgetflow/model/history/history.dart';
import 'package:budgetflow/model/serialize/map_keys.dart';
import 'package:budgetflow/model/serialize/serializer.dart';
import 'package:budgetflow/model/serialize/unserializer.dart';

class HistoryStrategy implements Unserializer {
  @override
  unserializeValue(Map value) {
    History output = History();
    value.forEach((key, value) {
      output.addMonth(Serializer.unserialize(KEY_MONTH, value));
    });
    return output;
  }
}
