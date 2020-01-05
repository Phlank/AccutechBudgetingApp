import 'package:budgetflow/crypt/password.dart';
import 'package:budgetflow/crypt/steel_crypter.dart';
import 'package:budgetflow/fileio/dart_file_io.dart';
import 'package:budgetflow/fileio/file_io.dart';
import 'package:budgetflow/crypt/crypter.dart';

class History {
  static FileIO fileIO;
  static Password password;
  static Crypter crypter;

  History(Password password) {
    History.fileIO = new DartFileIO();
    History.password = password;
    History.crypter = new SteelCrypter(password);
  }
}
