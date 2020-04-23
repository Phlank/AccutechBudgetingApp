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

  /// Start this service. Must be called before any other method after construction.
  Future start() async {
    FileService fileService = _dispatcher.fileService;
    if (await fileService.fileExists(passwordFilepath)) {
      await _loadPassword(fileService);
    }
  }

  Future _loadPassword(FileService fileService) async {
    String content = await fileService.readFile(passwordFilepath);
    _password = Serializer.unserialize(passwordKey, content);
  }

  /// Stops this service.
  Future stop() {
    return null;
  }

  Future save() {
    String content = _password.serialize;
    return _dispatcher.fileService.writeFile(passwordFilepath, content);
  }

  /// Defines a new String 'secret' for encryption.
  void registerPassword(String password) {
    _password = SteelPassword.fromSecret(password);
    _crypter = SteelCrypter(_password);
    // If you don't update the crypter in the file service, it will encrypt all
    // files with the old password's AES scheme. That is why the below line
    // exists.
    _dispatcher.fileService.registerCrypter(_crypter);
  }

  /// Returns true if the password has been initialized.
  bool passwordExists() {
    return _password != null;
  }

  /// Returns true if the input String matches the information held on disk.
  Future<bool> validatePassword(String secret) async {
    bool result = await _password.verify(secret);
    if (result) {
      _crypter = SteelCrypter(_password);
      _dispatcher.fileService.registerCrypter(_crypter);
    }
    return result;
  }
}
