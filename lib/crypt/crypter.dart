class Crypter {
  Encrypted encrypt(String plaintext) {}

  String decrypt(Encrypted encrypted) {}
}

class Encrypted {
  String iv;
  String cipher;

  Encrypted(String iv, String cipher) {
    this.iv = iv;
    this.cipher = cipher;
  }
}
