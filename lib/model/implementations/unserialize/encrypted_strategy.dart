import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/abstract/unserializer.dart';
import 'package:budgetflow/model/data_types/encrypted.dart';
class EncryptedStrategy implements Unserializer {
  @override
  unserializeValue(Map value) {
    String iv = value[ivKey];
    String cipher = value[cipherKey];
    return Encrypted(iv, cipher);
  }
}
