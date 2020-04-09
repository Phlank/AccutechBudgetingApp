import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/abstract/unserializer.dart';
import 'package:budgetflow/model/data_types/location.dart';
class LocationStrategy implements Unserializer {
  @override
  unserializeValue(Map value) {
    if (value == null) return null;
    if (value.containsKey(latitudeKey) && value.containsKey(longitudeKey)) {
      return Location(
        double.parse(value[latitudeKey]),
        double.parse(value[longitudeKey]),
      );
    }
    return null;
  }
}
