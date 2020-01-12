import 'dart:io';

import 'package:budgetflow/fileio/file_io.dart';
//import 'package:path_provider/path_provider.dart';

class DartFileIO implements FileIO {
  static Future<String> _path;

  DartFileIO() {
    _path = _getPath();
  }

  static Future<String> _getPath() async {
    //Directory appDocDir = await getApplicationDocumentsDirectory();
    //return appDocDir.path;
    return null;
  }

  Future writeFile(String pathSuffix, String content) async {
    String homePath = await _path;
    String path = homePath + pathSuffix;
    File target = await _getTargetFile(path);
    target.writeAsString(content);
  }

  Future<File> _getTargetFile(String path) async {
    return File('$path');
  }

  Future<String> readFile(String pathSuffix) async {
    String path = await _path;
    File target = await _getTargetFile(path + pathSuffix);
    return target.readAsString();
  }
}
