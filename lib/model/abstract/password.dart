import 'package:budgetflow/model/crypt/steel_password.dart';
import 'package:budgetflow/model/file_io/saveable.dart';
import 'package:budgetflow/model/serialize/map_keys.dart';
import 'package:budgetflow/model/serialize/serializable.dart';
import 'package:budgetflow/model/serialize/serializer.dart';

abstract class Password implements Serializable, Saveable {

  static Future<Password> fromSecret(String secret) async {
    return SteelPassword.fromSecret(secret);
  }

  // This needs to exist so we have something to call verify() on.
  // Without this function, we have to work with the bare bone libraries, and
  // that's just nasty. When verify() is called, it should make all other
  // functions usable because it takes secret as a param.
  static Password fromHashAndSalt(String hash, String salt) {
    return SteelPassword.fromHashAndSalt(hash, salt);
  }

  static Password unserialize(String serialized) {
    return Serializer.unserialize(passwordKey, serialized);
  }

  static Future<Password> load() {
    return SteelPassword.load();
  }

  Future<bool> verify(String secret);

  String get hash;

  String get secret;

  String get salt;
}
