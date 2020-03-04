import 'package:budgetflow/model/budget/location/location.dart';
import 'package:budgetflow/model/serialize/map_keys.dart';
import 'package:budgetflow/model/serialize/unserializer.dart';

class LocationStrategy implements Unserializer {
  @override
  unserializeValue(Map value) {
    if (value == null) return null;
    if (value.containsKey(latitudeKey) && value.containsKey(longitudeKey))
      return Location(value[latitudeKey], value[longitudeKey]);
    return null;
  }
}
