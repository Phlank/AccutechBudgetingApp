import 'package:budgetflow/model/control.dart';
import 'package:budgetflow/model/fileio/dart_file_io.dart';
import 'package:budgetflow/model/fileio/file_io.dart';

class BudgetControl implements Control {
  static FileIO fileIO = new DartFileIO();

  @override
  bool isNewUser() {
    // TODO: implement isNewUser
    return null;
  }

  @override
  bool passwordIsValid(String secret) {
    // TODO: implement passwordIsValid
    return null;
  }

  @override
  void initialize() {
    // TODO: implement initialize
  }

  @override
  void save() {
    // TODO: implement save
  }

  @override
  void setPassword() {
    // TODO: implement setPassword
  }
}
