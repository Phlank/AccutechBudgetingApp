import 'package:budgetflow/model/abstract/crypter.dart';

abstract class FileIO {
  Future writeFile(String path, String content);

  Future encryptAndWriteFile(String path, String content, Crypter crypter);

  Future<String> readFile(String path);

  Future<String> readAndDecryptFile(String path, Crypter crypter);

  Future<bool> fileExists(String path);
}
