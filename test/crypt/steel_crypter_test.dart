import 'package:budgetflow/crypt/crypter.dart';
import 'package:budgetflow/crypt/encrypted.dart';
import 'package:budgetflow/crypt/password.dart';
import 'package:budgetflow/crypt/steel_crypter.dart';
import 'package:budgetflow/crypt/steel_password.dart';
import 'package:flutter_test/flutter_test.dart';

const String _SECRET_1 = "password1";
const String _SECRET_2 = "password2";
const String _MESSAGE_1 = "The quick brown fox jumps over the lazy dog.";
const String _MESSAGE_2 = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";

Password _pw1 = new SteelPassword(_SECRET_1);
Password _pw2 = new SteelPassword(_SECRET_2);
Crypter _c1 = new SteelCrypter(_pw1);
Crypter _c2 = new SteelCrypter(_pw2);

void main() {
  group("SteelCrypter tests", () {
    setUp(() {});
    test("Cipher is different than plaintext", () {
      Encrypted e = _c1.encrypt(_MESSAGE_1);
      expect(_MESSAGE_1, isNot(e.cipher));
    });
    test("Ciphers of different messages are different", () {
      Encrypted e1 = _c1.encrypt(_MESSAGE_1);
      Encrypted e2 = _c1.encrypt(_MESSAGE_2);
      expect(e1.cipher, isNot(e2.cipher));
    });
    test("IVs of different encryptions are different", () {
      Encrypted e1 = _c1.encrypt(_MESSAGE_1);
      Encrypted e2 = _c1.encrypt(_MESSAGE_1);
      expect(e1.iv, isNot(e2.iv));
    });
    test("Ciphers of same message encrypted different times are different", () {
      Encrypted e1 = _c1.encrypt(_MESSAGE_1);
      Encrypted e2 = _c1.encrypt(_MESSAGE_1);
      expect(e1.cipher, isNot(e2.cipher));
    });
    test("Decrypted cipher is same as original", () {
      Encrypted e = _c1.encrypt(_MESSAGE_1);
      String d = _c1.decrypt(e);
      expect(d, equals(_MESSAGE_1));
    });
  });
}
