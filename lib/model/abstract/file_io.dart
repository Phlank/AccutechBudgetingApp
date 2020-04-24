/// Interface for File IO operations.
abstract class FileIO {
  /// Write a file to disk at [path] with [content].
  Future writeFile(String path, String content);

  /// Write a file to disk at [path] with an encrypted form of [content].
  Future encryptAndWriteFile(String path, String content);

  /// Read a file from disk at [path].
  Future<String> readFile(String path);

  /// Read a file from disk at [path] and decrypt it.
  Future<String> readAndDecryptFile(String path);

  /// Returns whether or not a File at [path] exists.
  Future<bool> fileExists(String path);
}
