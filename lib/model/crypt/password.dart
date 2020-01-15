import 'package:budgetflow/model/fileio/serializable.dart';

abstract class Password implements Serializable {
  bool verify(String secret, String salt);

  String getHash();

  String getSecret();

  String getSalt();
}
