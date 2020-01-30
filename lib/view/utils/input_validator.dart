class InputValidator {

  static bool pin(String input) {
    return new RegExp( r'\d\d\d\d').hasMatch(input);
  }

  static bool dollarAmount(String input) {
    return new RegExp(r'\d+(.\d\d)?').hasMatch(input);
  }

  static bool name(String input) {
    return new RegExp(r'\w+').hasMatch(input);
  }

  static bool age(String input) {
    return new RegExp(r'\d{2,3}').hasMatch(input);
  }
}
