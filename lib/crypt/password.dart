class Password {
  bool verify(String secret, String salt) {}

  // This needs to exist so we have something to call verify() on.
  // Without this function, we have to work with the bare bone libraries, and
  // that's just nasty.
  Password hashOnlyPassword(String hash) {}

  String getHash() {}

  String getSecret() {}

  String getSalt() {}
}
