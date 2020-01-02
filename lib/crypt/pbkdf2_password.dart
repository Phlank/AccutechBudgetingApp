import 'package:budgetflow/crypt/password.dart';
import 'package:password/password.dart' as ImplementedPassword;

class PBKDF2Password implements Password {

    String _secret;

    PBKDF2Password(String secret) {
        _secret = secret;
    }

    bool verify(String secret) {
        return false;
    }

    String hash() {
        return ImplementedPassword.Password.hash(_secret, ImplementedPassword.PBKDF2());
    }

    String getSecret() {
        return _secret;
    }
}