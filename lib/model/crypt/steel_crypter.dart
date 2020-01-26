import 'package:budgetflow/model/crypt/crypter.dart';
import 'package:budgetflow/model/crypt/encrypted.dart';
import 'package:budgetflow/model/crypt/password.dart';
import 'package:steel_crypt/steel_crypt.dart';

class SteelCrypter implements Crypter {
  static const int IV_LENGTH = 16;
  static const String MODE = "gcm";
  static const String PADDING = "pkcs7";

  static Password _password;
  static AesCrypt _aes;

  SteelCrypter(Password password) {
    _password = password;
    // Key must be of length 32, but the entered password doesn't need to be.
    // We just use the salt to get to a length of 32.
    String key = _password.secret + _password.salt;
    _aes = new AesCrypt(key, MODE, PADDING);
  }

  Encrypted encrypt(String plaintext) {
    String iv = CryptKey().genDart(IV_LENGTH);
    String cipher = _aes.encrypt(plaintext, iv);
    Encrypted encrypted = new Encrypted(iv, cipher);
    return encrypted;
  }

  String decrypt(Encrypted encrypted) {
    String plaintext = _aes.decrypt(encrypted.cipher, encrypted.iv);
    return plaintext;
  }
}
