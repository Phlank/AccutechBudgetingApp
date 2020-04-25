import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/abstract/serializable.dart';
import 'package:budgetflow/model/implementations/steel_password.dart';
import 'package:budgetflow/model/utils/serializer.dart';

/// Interface for passwords.
abstract class Password implements Serializable {
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

  Future<bool> verify(String secret);

  /// The hash value of the password.
  String get hash;

  /// The plaintext password.
  String get secret;

  /// The salt value of the password.
  String get salt;
}
