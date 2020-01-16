import 'package:budgetflow/model/file_io/serializable.dart';

abstract class Password implements Serializable {
  bool verify(String secret);

  String getHash();

  String getSecret();

  String getSalt();
}
