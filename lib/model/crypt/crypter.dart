import 'package:budgetflow/model/crypt/encrypted.dart';

abstract class Crypter {
  Encrypted encrypt(String plaintext);

  String decrypt(Encrypted encrypted);
}
