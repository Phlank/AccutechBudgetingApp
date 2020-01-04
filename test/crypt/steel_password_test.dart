import 'package:budgetflow/crypt/password.dart';
import 'package:budgetflow/crypt/steel_password.dart';
import 'package:flutter_test/flutter_test.dart';

const String _SECRET_1 = "password1";
const String _SECRET_2 = "password2";

Password _pw1 = new SteelPassword(_SECRET_1);
Password _pw2 = new SteelPassword(_SECRET_2);

void main() {
  group("SteelPassword tests", () {
    setUp(() {
    });
    test("Secret and hash do not match", () {
      expect("password1", isNot(_pw1.getHash()));
    });
    test("Salt is different each SteelPassword object", () {
      String s1 = _pw1.getSalt();
      String s2 = new SteelPassword(_SECRET_1).getSalt();
      expect(s1, isNot(s2));
    });
    test("Different passwords have different hashes", () {
      expect (_pw1.getHash(), isNot(_pw2.getHash()));
    });
    test("Password verifies correctly", () {
      expect(true, _pw1.verify(_SECRET_1, _pw1.getSalt()));
    });
  });
}
