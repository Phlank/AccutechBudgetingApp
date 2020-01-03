class Password {
  bool verify(String secret, String salt) {}

  // This needs to exist so we have something to call verify() on.
  // Without this function, we have to work with the bare bone libraries, and
  // that's just nasty.
  Password hashOnlyPassword(String hash) {}

  String getHash() {}

  String getSecret() {}

  String getSalt() {}

  // A helper function for some implementations of passwords which may need
  // padding to certain integers.
  String padTo(int n, String input) {
    while (input.length < n) {
      // Pad once then double
      input = input + " " + input;
    }
    while (input.length > n) {
      // Take characters off of front until n
      input = input.replaceFirst(input.substring(0, 1), '');
    }
    return input;
  }
}
