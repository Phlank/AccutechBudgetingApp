import 'package:budgetflow/crypt/encrypted.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  test("Serialization is reversible", () {
    Encrypted e =
        new Encrypted("udisabyfeb", "fuiea8932rui3buih8sd9fueHUIWHD&W");
    String es = e.serialize();
    String escs = Encrypted.unserialize(es).serialize();
    expect(es, equals(escs));
  });
}
