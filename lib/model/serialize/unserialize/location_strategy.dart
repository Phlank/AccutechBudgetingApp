import 'package:budgetflow/model/budget/location/location.dart';
import 'package:budgetflow/model/serialize/map_keys.dart';
import 'package:budgetflow/model/serialize/unserializer.dart';

class LocationStrategy implements Unserializer {
  @override
  unserializeValue(Map value) {
    if (value == null) return null;
    if (value.containsKey(KEY_LATITUDE) && value.containsKey(KEY_LONGITUDE))
      return Location(value[KEY_LATITUDE], value[KEY_LONGITUDE]);
    return null;
  }
}
