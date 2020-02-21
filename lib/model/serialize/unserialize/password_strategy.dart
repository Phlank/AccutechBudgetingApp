import 'package:budgetflow/model/crypt/password.dart';
import 'package:budgetflow/model/serialize/map_keys.dart';
import 'package:budgetflow/model/serialize/unserializer.dart';

class PasswordStrategy implements Unserializer {
  @override
  unserializeValue(Map value) {
    String hash = value[KEY_HASH];
    String salt = value[KEY_SALT];
    return Password.fromHashAndSalt(hash, salt);
  }
}
