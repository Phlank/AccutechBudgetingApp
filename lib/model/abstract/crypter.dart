import 'package:budgetflow/model/data_types/encrypted.dart';

abstract class Crypter {
  Encrypted encrypt(String plaintext);

  String decrypt(Encrypted encrypted);
}
