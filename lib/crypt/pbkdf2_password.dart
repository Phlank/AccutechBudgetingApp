import 'package:budgetflow/crypt/password.dart';
import 'package:password/password.dart' as DartPassword;

class PBKDF2Password implements Password {
  String _secret;
  String _hash;

  PBKDF2Password newPassword(String secret) {
    _secret = secret;
    _hash = hash();
    return this;
  }

  PBKDF2Password hashOnlyPassword(String hash) {
    _hash = hash;
    return this;
  }

  bool verify(String secret) {
    return DartPassword.Password.verify(secret, _hash);
  }

  String hash() {
    return DartPassword.Password.hash(
        _secret, DartPassword.PBKDF2()); // Uses PBKDF2() to salt password
  }

  String getSecret() {
    return _secret;
  }
}
