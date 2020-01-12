class Encrypted {
  String iv;
  String cipher;

  Encrypted(String iv, String cipher) {
    this.iv = iv;
    this.cipher = cipher;
  }

  static Encrypted fromFileContent(String content) {
    // TODO implement this
    // should be able to parse file content into data structure
    // see toFileContent() for format, make sure it can't be messed up
    return null;
  }

  static String toFileContent() {
    // TODO implement this
    // output should be iv:<$iv>cipher:<$cipher>
    // don't use magic strings
    return null;
  }
}
