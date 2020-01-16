import 'package:budgetflow/model/control.dart';
import 'package:budgetflow/model/crypt/crypter.dart';
import 'package:budgetflow/model/crypt/steel_crypter.dart';
import 'package:budgetflow/model/crypt/steel_password.dart';
import 'package:budgetflow/model/file_io/dart_file_io.dart';
import 'package:budgetflow/model/file_io/file_io.dart';
import 'package:budgetflow/model/history/history.dart';

import 'crypt/password.dart';

class BudgetControl implements Control {
  static const String _PASSWORD_PATH = "password";

  static FileIO fileIO;
  static Password _password;
  static Crypter crypter;

  bool _newUser;
  int _year, _month;
  History _history;

  BudgetControl() {
    fileIO = new DartFileIO();
  }

  @override
  bool isNewUser() {
    bool result = false;
    fileIO.fileExists(History.HISTORY_PATH).then((value) {
      result = !value;
    });
    _newUser = result;
    return result;
  }

  @override
  bool passwordIsValid(String secret) {
    bool result = false;
    _password = SteelPassword.load();
    bool passwordMatch = _password.verify(secret);
    if (passwordMatch) {
      initialize();
      result = true;
    } else {
      result = false;
    }
    return result;
  }

  @override
  void initialize() {
    _updateMonthAndYear();
    crypter = new SteelCrypter(_password);
    if (!_newUser) {
      _load();
    }
  }

  void _updateMonthAndYear() {
    DateTime now = DateTime.now();
    _year = now.year;
    _month = now.month;
  }

  void _load() {}

  void save() {
    _history.save();
    fileIO.writeFile(_PASSWORD_PATH, _password.serialize());
  }

  @override
  void setPassword(String newSecret) {
    _password = new SteelPassword(newSecret);
    crypter = new SteelCrypter(_password);
  }
}
