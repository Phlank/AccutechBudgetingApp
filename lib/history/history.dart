import 'package:budgetflow/crypt/password.dart';
import 'package:budgetflow/crypt/steel_crypter.dart';
import 'package:budgetflow/fileio/dart_file_io.dart';
import 'package:budgetflow/fileio/file_io.dart';
import 'package:budgetflow/crypt/crypter.dart';
import 'package:budgetflow/history/month.dart';

class History {

  static FileIO fileIO = new DartFileIO();
  static Password password;
  static Crypter crypter;
  static List<Month> months;

  static void initialize(String secret) {
    if (!_passwordIsValid(secret)) {
      throw new Exception("Invalid password: $secret");
    }
    // TODO implement past here
    // Pretty much just get the months into the list
  }

  static bool _passwordIsValid(String secret) {
    // TODO implement this
    // If returns true, then before return, update fields password and crypter
  }
}
