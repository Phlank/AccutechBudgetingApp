import 'package:budgetflow/crypt/password.dart';
import 'package:budgetflow/crypt/steel_crypter.dart';
import 'package:budgetflow/crypt/steel_password.dart';
import 'package:budgetflow/fileio/dart_file_io.dart';
import 'package:budgetflow/fileio/file_io.dart';
import 'package:budgetflow/crypt/crypter.dart';
import 'package:budgetflow/history/json_stringifier.dart';
import 'package:budgetflow/history/stringifier.dart';

import 'package:budgetflow/history/month.dart';

class History {

  static const String HISTORY_PATH = "history";

  static FileIO fileIO = new DartFileIO();
  static Stringifier stringifier = new JSONStringifier();
  static Future<String> json;
  static Password password;
  static Crypter crypter;
  static List<Month> months;

  static Future<bool> initialize(String secret) async {
    json = fileIO.readFile(HISTORY_PATH);
    bool passwordMatch = await _passwordIsValid(secret);
    if (passwordMatch) {
      // Load everything
      _loadMonths();

      return true;
    }
    return false;
  }

  static Future<bool> _passwordIsValid(String secret) async {
    String awaitedJSON = await json;
    Password stored = stringifier.unstringifyPassword(awaitedJSON);
    if (stored.verify(secret, stored.getSalt())) {
      // This will generate a new salt and hash. Making a new salt and hash each
      // time the app is loaded means the content of all encrypted files
      // changes.
      password = new SteelPassword(secret);
      return true;
    }
    return false;
  }

  static Future _loadMonths() async {
    String awaitedJSON = await json;
    months = await stringifier.unstringifyHistory(awaitedJSON);
  }

  // TODO change password
}
