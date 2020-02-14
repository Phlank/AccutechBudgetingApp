import 'package:budgetflow/model/crypt/password.dart';
import 'package:budgetflow/model/crypt/steel_password.dart';
import 'package:flutter_test/flutter_test.dart';

const String _SECRET_1 = "password1";
const String _SECRET_2 = "password2";

Password _pw1, _pw2;

DateTime start, end;

Future<void> main() async {
  _pw1 = await Password.fromSecret(_SECRET_1);
  _pw2 = await Password.fromSecret(_SECRET_2);
  group("SteelPassword tests", () {
    setUp(() {
      start = DateTime.now();
    });
    test("Secret and hash do not match", () {
      expect("password1", isNot(_pw1.hash));
    });
    test("Salt is different each SteelPassword object", () async {
      String s1 = _pw1.salt;
      String s2 = _pw2.salt;
      expect(s1, isNot(s2));
    });
    test("Different passwords have different hashes", () {
      expect(_pw1.hash, isNot(_pw2.hash));
    });
    test("Password verifies correctly", () async {
      expect(await _pw1.verify(_SECRET_1), true);
    });
    test("Wrong password does not verify", () async {
      expect(await _pw1.verify(_SECRET_2), false);
    });
    test("Salt + secret is 32 chars long", () {
      String s1 = _pw1.salt;
      expect((_SECRET_1 + s1).length, 32);
    });
    test("Password made from hash can verify new secret", () async {
      Password p0 = Password.fromHashAndSalt(_pw1.hash, _pw1.salt);
      expect(await p0.verify(_SECRET_1), true);
    });
    test("Serialization sanity", () async {
      String _pw1s = _pw1.serialize();
      Password _pw1u = SteelPassword.unserialize(_pw1s);
      expect(await _pw1u.verify(_SECRET_1), true);
    });
    tearDown(() {
      end = DateTime.now();
      int elapsed = end.millisecondsSinceEpoch - start.millisecondsSinceEpoch;
      print("Ms elapsed: $elapsed");
    });
  });
}
