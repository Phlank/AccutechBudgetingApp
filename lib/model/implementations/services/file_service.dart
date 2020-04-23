import 'dart:io';

import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/abstract/crypter.dart';
import 'package:budgetflow/model/abstract/file_io.dart';
import 'package:budgetflow/model/abstract/service.dart';
import 'package:budgetflow/model/data_types/encrypted.dart';
import 'package:budgetflow/model/implementations/services/service_dispatcher.dart';
import 'package:budgetflow/model/utils/serializer.dart';
import 'package:path_provider/path_provider.dart';

class FileService implements FileIO, Service {
  ServiceDispatcher _dispatcher;
  String _path;
  Crypter _crypter;

  FileService(this._dispatcher);

  Future start() async {
    _path = await _getPath();
  }

  Future stop() {
    return null;
  }

  Future<String> _getPath() async {
    Directory appDocDir;
    String appPath;
    try {
      appDocDir = await getApplicationDocumentsDirectory();
      appPath = appDocDir.path;
    } catch (MissingPluginException) {
      appPath = null;
    }
    return appPath;
  }

  /// Must be called before using any encrypt or decrypt functions.
  void registerCrypter(Crypter crypter) {
    _crypter = crypter;
  }

  Future writeFile(String pathSuffix, String content) async {
    String path = pathSuffixToPath(pathSuffix);
    File target = _getTargetFile(path);
    target.writeAsString(content);
    print("File written: $path");
  }

  Future encryptAndWriteFile(String pathSuffix, String content) async {
    String path = pathSuffixToPath(pathSuffix);
    File target = _getTargetFile(path);
    target.writeAsString(_crypter
        .encrypt(content)
        .serialize);
  }

  String pathSuffixToPath(String pathSuffix) {
    return _path + '/' + pathSuffix;
  }

  File _getTargetFile(String path) {
    return File('$path');
  }

  Future<String> readFile(String pathSuffix) async {
    String path = pathSuffixToPath(pathSuffix);
    File target = _getTargetFile(path);
    String content = await target.readAsString();
    print('FileService: Contents of file:\n$content');
    return content;
  }

  Future<String> readAndDecryptFile(String pathSuffix) async {
    String path = pathSuffixToPath(pathSuffix);
    File target = _getTargetFile(path);
    String cipher = await target.readAsString();
    print('FileService: Contents of file:\n$cipher');
    Encrypted encrypted = Serializer.unserialize(encryptedKey, cipher);
    return _crypter.decrypt(encrypted);
  }

  Future<bool> fileExists(String pathSuffix) async {
    String path = pathSuffixToPath(pathSuffix);
    File target = _getTargetFile(path);
    return target.exists();
  }
}
