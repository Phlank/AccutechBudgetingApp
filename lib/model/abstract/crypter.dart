import 'package:budgetflow/model/data_types/encrypted.dart';

abstract class Crypter {
  /// Returns an [Encrypted] object with an IV and cipher corresponding to [plaintext].
  Encrypted encrypt(String plaintext);

  /// Returns a plaintext String corresponding to [encrypted].
  String decrypt(Encrypted encrypted);
}
