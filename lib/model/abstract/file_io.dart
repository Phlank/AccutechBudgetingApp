

abstract class FileIO {
  Future writeFile(String path, String content);

  Future encryptAndWriteFile(String path, String content);

  Future<String> readFile(String path);

  Future<String> readAndDecryptFile(String path);

  Future<bool> fileExists(String path);
}
