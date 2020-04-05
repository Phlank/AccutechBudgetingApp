import 'package:budgetflow/model/data_types/encrypted.dart';
import 'package:budgetflow/model/serialize/map_keys.dart';
import 'package:budgetflow/model/serialize/unserializer.dart';

class EncryptedStrategy implements Unserializer {
  @override
  unserializeValue(Map value) {
    String iv = value[ivKey];
    String cipher = value[cipherKey];
    return Encrypted(iv, cipher);
  }
}
