import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/abstract/service.dart';
import 'package:budgetflow/model/implementations/services/file_service.dart';
import 'package:budgetflow/model/implementations/services/service_dispatcher.dart';
import 'package:budgetflow/model/implementations/steel_crypter.dart';
import 'package:budgetflow/model/implementations/steel_password.dart';
import 'package:budgetflow/model/utils/serializer.dart';

class EncryptionService implements Service {
  ServiceDispatcher _dispatcher;
  SteelPassword _password;
  SteelCrypter _crypter;

  EncryptionService(this._dispatcher);

  Future start() async {
    FileService fileService = _dispatcher.getFileService();
    if (await fileService.fileExists(passwordFilepath)) {
      _loadPassword(fileService);
    }
  }

  void _loadPassword(FileService fileService) async {
    String content = await fileService.readFile(passwordFilepath);
    _password = Serializer.unserialize(passwordKey, content);
    _crypter = SteelCrypter(_password);
    fileService.registerCrypter(_crypter);
  }

  Future stop() {
    return null;
  }

  void registerPassword(String password) {
    _password = SteelPassword.fromSecret(password);
    _crypter = SteelCrypter(_password);
    _dispatcher.getFileService().registerCrypter(_crypter);
  }

  bool passwordExists() {
    return _password != null;
  }

  Future<bool> validatePassword(String secret) {
    return _password.verify(secret);
  }
}
