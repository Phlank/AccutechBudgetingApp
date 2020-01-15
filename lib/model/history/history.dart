import 'dart:convert';

import 'package:budgetflow/model/budget/budget.dart';
import 'package:budgetflow/model/budget/budget_factory.dart';
import 'package:budgetflow/model/crypt/crypter.dart';
import 'package:budgetflow/model/crypt/encrypted.dart';
import 'package:budgetflow/model/crypt/password.dart';
import 'package:budgetflow/model/crypt/steel_crypter.dart';
import 'package:budgetflow/model/crypt/steel_password.dart';
import 'package:budgetflow/model/fileio/dart_file_io.dart';
import 'package:budgetflow/model/fileio/file_io.dart';
import 'package:budgetflow/model/history/month.dart';

class History {
  static const String HISTORY_PATH = "history";
  static const String PASSWORD_PATH = "password";

  static FileIO fileIO = new DartFileIO();
  static Password password;
  static Crypter crypter;
  List<Month> months;
  int year, month;
  Month currentMonth;
  Budget budget;
  bool newUser;

  History() {
    months = new List<Month>();
  }

  bool isNewUser() {
    fileIO.fileExists(HISTORY_PATH).then((value) {
      newUser = !value;
      return !value;
    });
  }

  bool passwordIsValid(String secret) {
    fileIO.readFile(PASSWORD_PATH).then((String passwordJson) {
      password = SteelPassword.unserialize(passwordJson);
      bool passwordMatch = password.verify(secret, password.getSalt());
      if (passwordMatch) {
        initialize();
        return true;
      } else {
        return false;
      }
    });
  }

  void initialize() {
    updateCurrentTime();
    if (!newUser) {
      fileIO.readFile(HISTORY_PATH).then((String cipher) {
        loadData(cipher);
      });
    }
  }

  void updateCurrentTime() {
    DateTime now = DateTime.now();
    year = now.year;
    month = now.month;
  }

  void loadData(String cipher) {
    String plaintext = crypter.decrypt(Encrypted.unserialize(cipher));
    months = unserialize(plaintext);
    if (months.contains(new Month(year, month, 0.0))) {
      currentMonth =
          months.firstWhere((Month m) => m.year == year && m.month == month);
      budget = Budget.fromMonth(currentMonth);
    } else {
      currentMonth = new Month(year, month, months[months.length - 1].income);
      months.add(currentMonth);
      budget = BudgetFactory.newFromBudget(
          Budget.fromMonth(months[months.length - 2]));
    }
  }

  void setPassword(String newSecret) {
    password = new SteelPassword(newSecret);
    crypter = new SteelCrypter(password);
  }

  void updateCurrentMonth(Budget budget) {
    currentMonth = Month.fromBudget(budget);
  }

  void addMonth(Month m) {
    months.add(m);
  }

  void saveData() {
    updateCurrentMonth(budget);
    months.forEach((Month m) => m.writeMonth());
    writePassword();
    writeHistory();
  }

  void writePassword() {
    fileIO.writeFile(PASSWORD_PATH, password.serialize());
  }

  void writeHistory() {
    fileIO.writeFile(HISTORY_PATH, this.serialize());
  }

  String serialize() {
    String output = "{";
    int i = 0;
    months.forEach((Month m) {
      output += "\"" + i.toString() + "\":" + m.serialize();
      i++;
    });
    output += "}";
    return output;
  }

  static List<Month> unserialize(String serialized) {
    Map map = jsonDecode(serialized);
    List<Month> returnable = new List();
    map.forEach((dynamic s, dynamic d) {
      returnable.add(Month.unserializeMap(d));
    });
    return returnable;
  }
}
