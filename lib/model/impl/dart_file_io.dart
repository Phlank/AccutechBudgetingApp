import 'dart:io';

import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/abstract/crypter.dart';
import 'package:budgetflow/model/abstract/file_io.dart';
import 'package:budgetflow/model/data_types/encrypted.dart';
import 'package:budgetflow/model/utils/serializer.dart';
import 'package:path_provider/path_provider.dart';

class DartFileIO implements FileIO {
  static Future<String> _path;

  DartFileIO() {
    _path = _getPath();
  }

  static Future<String> _getPath() async {
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

  Future writeFile(String pathSuffix, String content) async {
    String path = await pathSuffixToPath(pathSuffix);
    File target = await _getTargetFile(path);
    target.writeAsString(content);
    print("File written: $path");
  }

  Future encryptAndWriteFile(String pathSuffix,
      String content,
      Crypter crypter,) async {
    String path = await pathSuffixToPath(pathSuffix);
    File target = await _getTargetFile(path);
    target.writeAsString(crypter
        .encrypt(content)
        .serialize);
  }

  Future<String> pathSuffixToPath(String pathSuffix) async {
    return await _path + '/' + pathSuffix;
  }

  Future<File> _getTargetFile(String path) async {
    return File('$path');
  }

  Future<String> readFile(String pathSuffix) async {
    String path = await pathSuffixToPath(pathSuffix);
    File target = await _getTargetFile(path);
    return target.readAsString();
  }

  Future<String> readAndDecryptFile(String pathSuffix, Crypter crypter) async {
    String path = await pathSuffixToPath(pathSuffix);
    File target = await _getTargetFile(path);
    String cipher = await target.readAsString();
    Encrypted encrypted = Serializer.unserialize(encryptedKey, cipher);
    return crypter.decrypt(encrypted);
  }

  Future<bool> fileExists(String pathSuffix) async {
    String path = await pathSuffixToPath(pathSuffix);
    File target = await _getTargetFile(path);
    return target.exists();
  }
}
