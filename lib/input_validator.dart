class InputValidator {
  static final Map<String, String> _regexMap = {
    'pin': r'\d\d\d\d',
    'dollarAmount': r'\d+(.\d\d)?',
    'name': r'\w+',
    'age': r'\d{2,3}'
  };

  static bool pin(String input) {
    return new RegExp(_regexMap['pin']).hasMatch(input);
  }

  static bool dollarAmount(String input) {
    return new RegExp(_regexMap['dollarAmount']).hasMatch(input);
  }

  static bool name(String input) {
    return new RegExp(_regexMap['name']).hasMatch(input);
  }

  static bool age(String input) {
    return new RegExp(_regexMap['age']).hasMatch(input);
  }
}
