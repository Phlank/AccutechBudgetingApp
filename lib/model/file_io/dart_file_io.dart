import 'dart:io';

import 'package:budgetflow/model/file_io/file_io.dart';
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

  Future<bool> fileExists(String pathSuffix) async {
    String path = await pathSuffixToPath(pathSuffix);
    File target = await _getTargetFile(path);
    return target.exists();
  }
}
