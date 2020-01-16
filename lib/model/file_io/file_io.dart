abstract class FileIO {
  Future writeFile(String path, String content) {}

  Future<String> readFile(String path) {}

  Future<bool> fileExists(String path) {}
}
