import 'package:budgetflow/crypt/crypter.dart';
import 'package:encrypt/encrypt.dart' as DartEncrypt;

class AESCrypter implements Crypter {
  static const int IV_LENGTH = 16;

  static String _secret;
  static DartEncrypt.Key _secretKey;
  static DartEncrypt.Encrypter _encrypter;
  static DartEncrypt.IV _iv;

  AESCrypter(String secret) {
    _secret = secret;
    _secretKey = DartEncrypt.Key.fromUtf8(_secret);
    _encrypter = DartEncrypt.Encrypter(DartEncrypt.AES(_secretKey));
  }

  Encrypted encrypt(String plaintext) {
    _iv = DartEncrypt.IV.fromLength(IV_LENGTH);
    DartEncrypt.Encrypted processedOutput =
        _encrypter.encrypt(plaintext, iv: _iv);
    return new Encrypted(_iv.base64, processedOutput.base64);
  }

  String decrypt(Encrypted encrypted) {
    DartEncrypt.Encrypted.from64(encrypted.cipher);
    String plaintext =
        _encrypter.decrypt(DartEncrypt.Encrypted.from64(encrypted.cipher));
    return plaintext;
  }
}
