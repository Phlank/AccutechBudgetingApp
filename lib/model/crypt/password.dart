import 'package:budgetflow/model/crypt/steel_password.dart';
import 'package:budgetflow/model/file_io/saveable.dart';
import 'package:budgetflow/model/file_io/serializable.dart';

abstract class Password implements Serializable, Saveable {
  static Password fromSecret(String secret) {
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
    return SteelPassword.unserialize(serialized);
  }

  static Future<Password> load() {
    return SteelPassword.load();
  }

  bool verify(String secret);

  String getHash();

  String getSecret();

  String getSalt();
}
