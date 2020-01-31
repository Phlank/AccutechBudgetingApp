class InputValidator {
  static final Map<String, String> _regexMap = {
    'pin': r'\d\d\d\d',
    // Found at https://stackoverflow.com/questions/354044/what-is-the-best-u-s-currency-regex
    'dollarAmount': r'^[+-]?[0-9]{1,3}(?:,?[0-9]{3})*(?:\.[0-9]{2})?$',
    'name': r'\w+',
    'age': r'\d{2,3}'
  };

  static bool required(String input) {
    return !(input.trim() == '');
  }

  static const String REQUIRED_MESSAGE = 'Required field';

  static bool pin(String input) {
    return new RegExp(_regexMap['pin']).hasMatch(input);
  }

  static const String PIN_MESSAGE = 'Must be four digits';

  static bool dollarAmount(String input) {
    return new RegExp(_regexMap['dollarAmount']).hasMatch(input);
  }

  static const String DOLLAR_MESSAGE = 'Must be a valid dollar amount';

  static bool name(String input) {
    return new RegExp(_regexMap['name']).hasMatch(input);
  }

  static bool age(String input) {
    return new RegExp(_regexMap['age']).hasMatch(input);
  }
}
