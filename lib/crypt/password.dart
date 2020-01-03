class Password {

  bool verify(String secret, String salt) {}

  Password hashOnlyPassword(String hash) {}

  String getHash() {}

  String getSecret() {}

  String getSalt() {}

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
