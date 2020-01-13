import 'dart:convert';

import 'package:budgetflow/crypt/crypter.dart';
import 'package:budgetflow/crypt/encrypted.dart';
import 'package:budgetflow/crypt/password.dart';
import 'package:budgetflow/crypt/steel_crypter.dart';
import 'package:budgetflow/fileio/dart_file_io.dart';
import 'package:budgetflow/fileio/file_io.dart';
import 'package:budgetflow/history/month.dart';

class History {
  static const String HISTORY_PATH = "history";
  static const String PASSWORD_PATH = "password";

  static FileIO fileIO = new DartFileIO();
  static Password password;
  static Crypter crypter;
  List<Month> months;

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
      password = Password.unserialize(passwordJson);
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
	  if (!newUser) {
		  fileIO.readFile(HISTORY_PATH).then((String cipher) {
			  String plaintext = crypter.decrypt(
				  Encrypted.fromFileContent(cipher));
			  months = unserialize(plaintext);
		  });
	  }
  }

  void setPassword(Password pw) {
    password = pw;
    crypter = new SteelCrypter(password);
  }

  void addMonth(Month m) {
    months.add(m);
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
