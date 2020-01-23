import 'package:budgetflow/model/crypt/password.dart';
import 'package:budgetflow/model/crypt/steel_password.dart';
import 'package:flutter_test/flutter_test.dart';

const String _SECRET_1 = "password1";
const String _SECRET_2 = "password2";

SteelPassword _pw1 = Password.fromSecret(_SECRET_1);
SteelPassword _pw2 = Password.fromSecret(_SECRET_2);

void main() {
  group("SteelPassword tests", () {
    setUp(() {
    });
    test("Secret and hash do not match", () {
      expect("password1", isNot(_pw1.getHash()));
    });
    test("Salt is different each SteelPassword object", () {
      String s1 = _pw1.getSalt();
      String s2 = Password.fromSecret(_SECRET_1).getSalt();
      expect(s1, isNot(s2));
    });
    test("Different passwords have different hashes", () {
      expect (_pw1.getHash(), isNot(_pw2.getHash()));
    });
    test("Password verifies correctly", () {
      expect(_pw1.verify(_SECRET_1), true);
    });
    test("Wrong password does not verify", () {
      expect(_pw1.verify(_SECRET_2), false);
    });
    test("Salt + secret is 32 chars long", () {
      String s1 = _pw1.getSalt();
      expect((_SECRET_1 + s1).length, 32);
    });
    test("Password made from hash can verify new secret", () {
      Password p0 = SteelPassword.fromHashAndSalt(
          _pw1.getHash(), _pw1.getSalt());
      expect(_pw1.verify(_SECRET_1), true);
    });
    test("Serialization sanity", () {
      String _pw1s = _pw1.serialize();
      Password _pw1u = SteelPassword.unserialize(_pw1s);
      expect(_pw1u.verify(_SECRET_1), true);
    });
  });
}
