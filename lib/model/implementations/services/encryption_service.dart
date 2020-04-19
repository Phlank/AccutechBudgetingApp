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

  /// Stops this service.
  Future stop() {
    return null;
  }

  /// Defines a new String 'secret' for encryption.
  void registerPassword(String password) {
    _password = SteelPassword.fromSecret(password);
    _crypter = SteelCrypter(_password);
    // If you don't update the crypter in the file service, it will encrypt all
    // files with the old password's AES scheme. That is why the below line
    // exists.
    _dispatcher.getFileService().registerCrypter(_crypter);
  }

  /// Returns true if the password has been initialized.
  bool passwordExists() {
    return _password != null;
  }

  /// Returns true if the input String matches the information held on disk.
  Future<bool> validatePassword(String secret) {
    return _password.verify(secret);
  }
}
