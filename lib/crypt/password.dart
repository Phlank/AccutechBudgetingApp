class Password {
  String _secret;

  Password(String secret) {
    _secret = secret;
  }

  bool verify(String input) {}

  String hash() {}

  String getSecret() {
    return _secret;
  }
}
