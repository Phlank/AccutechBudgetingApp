import 'package:budgetflow/crypt/password.dart';
import 'package:steel_crypt/steel_crypt.dart';

class SteelPassword extends Password {
  static const String ALGORITHM = "scrypt";
  static const int SALT_LENGTH = 16;

  String _secret;
  String _hash;
  String _salt;
  PassCrypt _passCrypt;

  SteelPassword(String secret) {
    _passCrypt = new PassCrypt(ALGORITHM);
    _salt = CryptKey().genDart(16);
    _hash = _passCrypt.hashPass(_salt, secret);
  }

  Password hashOnlyPassword(String hash) {
    SteelPassword pw = new SteelPassword("");
    pw._hash = hash;
    pw._salt = "";
    pw._secret = "";
    return pw;
  }

  bool verify(String secret, String salt) {
    bool success = _passCrypt.checkPassKey(salt, secret, _hash);
    if (success) {
      _secret = secret;
      _salt = salt;
      _passCrypt = new PassCrypt(ALGORITHM);
    }
    return success;
  }

  String getHash() {
    return _hash;
  }

  String getSecret() {
    return _secret;
  }

  String getSalt() {
    return _salt;
  }
}
