import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/abstract/io.dart';
import 'package:budgetflow/model/implementations/services/file_service.dart';
import 'package:budgetflow/model/implementations/steel_password.dart';
import 'package:budgetflow/model/utils/serializer.dart';

class PasswordIO implements IO {
  FileService _fileService;
  SteelPassword _password;

  PasswordIO(this._fileService);

  PasswordIO.fromPassword(this._fileService, this._password);

  @override
  Future<Object> load() async {
    String content = await _fileService.readFile(passwordFilepath);
    _password = Serializer.unserialize(passwordKey, content);
    return _password;
  }

  @override
  Future save() {
    _fileService.writeFile(passwordFilepath, _password.serialize);
  }
}
