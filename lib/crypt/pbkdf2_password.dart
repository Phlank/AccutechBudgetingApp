import 'package:budgetflow/crypt/password.dart';
import 'package:password/password.dart' as DartPassword;

class PBKDF2Password extends Password {
  String _secret;
  String _fixedSecret;
  String _hash;

  PBKDF2Password(String secret) {
    _secret = secret;
    _fixedSecret = _fixLengthOfSecret(secret);
    _hash = hash();
  }

  String _fixLengthOfSecret(String input) {
    if (input.length < 16) {
      input = padTo(16, input);
    } else if (input.length < 24) {
      input = padTo(24, input);
    } else {
      input = padTo(32, input);
    }
    return input;
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
    return _fixedSecret;
  }
}
