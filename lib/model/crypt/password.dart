import 'package:budgetflow/model/file_io/saveable.dart';
import 'package:budgetflow/model/file_io/serializable.dart';

abstract class Password implements Serializable, Saveable {
  bool verify(String secret);

  String getHash();

  String getSecret();

  String getSalt();
}
