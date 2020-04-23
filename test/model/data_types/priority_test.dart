import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/data_types/encrypted.dart';
import 'package:budgetflow/model/data_types/priority.dart';
import 'package:budgetflow/model/utils/serializer.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  test('Priorities not equal to each other', () {
    expect(Priority.income == Priority.wants, isFalse);
    expect(Priority.income == Priority.needs, isFalse);
    expect(Priority.income == Priority.savings, isFalse);
    expect(Priority.income == Priority.other, isFalse);
    expect(Priority.income == Priority.required, isFalse);
  });
  test("Serialization is reversible", () {
    Encrypted e =
        new Encrypted("udisabyfeb", "fuiea8932rui3buih8sd9fueHUIWHD&W");
    String es = e.serialize;
    String escs = Serializer.unserialize(encryptedKey, es).serialize;
    expect(es, equals(escs));
  });
}
