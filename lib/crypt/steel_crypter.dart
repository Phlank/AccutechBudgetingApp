import 'package:budgetflow/crypt/crypter.dart';
import 'package:budgetflow/crypt/encrypted.dart';
import 'package:budgetflow/crypt/password.dart';
import 'package:steel_crypt/steel_crypt.dart';

class SteelCrypter implements Crypter {
  static const int IV_LENGTH = 16;
  static const String MODE = "gcm";
  static const String PADDING = "pkcs7";

  Password _password;
  AesCrypt _aes;

  SteelCrypter(Password password) {
    _password = password;
    _aes = new AesCrypt(_password.getSecret(), MODE, PADDING);
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
