import 'package:budgetflow/model/crypt/encrypted.dart';
import 'package:budgetflow/model/serialize/map_keys.dart';
import 'package:budgetflow/model/serialize/unserializer.dart';

class EncryptedStrategy implements Unserializer {
  @override
  unserializeValue(value) {
    String iv = value[KEY_IV];
    String cipher = value[KEY_CIPHER];
    return Encrypted(iv, cipher);
  }
}
