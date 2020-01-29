import 'dart:io';

import 'package:budgetflow/model/file_io/file_io.dart';
import 'package:path_provider/path_provider.dart';

class DartFileIO implements FileIO {
  static Future<String> _path;

  DartFileIO() {
    _path = _getPath();
  }

  static Future<String> _getPath() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    return appDocDir.path;
  }

  Future writeFile(String pathSuffix, String content) async {
    String homePath = await _path;
    String path = homePath + pathSuffix;
    File target = await _getTargetFile(path);
    target.writeAsString(content);
    print("File written: $_path$pathSuffix");
  }

  Future<File> _getTargetFile(String path) async {
    return File('$path');
  }

  Future<String> readFile(String pathSuffix) async {
    String path = await _path;
    File target = await _getTargetFile(path + pathSuffix);
    return target.readAsString();
  }

  Future<bool> fileExists(String pathSuffix) async {
    String path = await _path;
    File target = await _getTargetFile(path + pathSuffix);
    return target.exists();
  }
}
