import 'package:budgetflow/crypt/crypter.dart';
import 'package:budgetflow/crypt/password.dart';
import 'package:budgetflow/crypt/steel_password.dart';
import 'package:budgetflow/fileio/dart_file_io.dart';
import 'package:budgetflow/fileio/file_io.dart';
import 'package:budgetflow/history/json_stringifier.dart';
import 'package:budgetflow/history/month.dart';
import 'package:budgetflow/history/stringifier.dart';

class History {
  static const String HISTORY_PATH = "history";
  static const String PASSWORD_PATH = "password";

  static FileIO fileIO = new DartFileIO();
  static Stringifier stringifier = new JSONStringifier();
  static Future<String> json;
  static Password password;
  static Crypter crypter;
  static List<Month> months;

  static bool isNewUser() {
    fileIO.fileExists(HISTORY_PATH).then((value) {
      return value;
    });
  }

  static bool passwordIsValid(String secret) {
    fileIO.readFile(PASSWORD_PATH).then((String passwordJson) {
      Password stored = Password.unserialize(passwordJson);
      bool passwordMatch = stored.verify(secret, stored.getSalt());
      if (passwordMatch) {
        initialize();
        return true;
      }
      return false;
    });
  }

  static void initialize() {

  }



  static Future _loadMonths() async {
    String awaitedJSON = await json;
    months = stringifier.unstringifyHistory(awaitedJSON);
  }

  String serialize() {

  }

// TODO change password
}
