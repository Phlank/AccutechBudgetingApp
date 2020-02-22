import 'package:budgetflow/model/budget/category/category.dart';

class InputValidator {
  static final Map<String, String> _regexMap = {
    'pin': r'\d\d\d\d',
    'dollarAmount': r'^\$?\-?([1-9]{1}[0-9]{0,2}(\,\d{3})*(\.\d{0,2})?|[1-9]{1}\d{0,}(\.\d{0,2})?|0(\.\d{0,2})?|(\.\d{1,2}))$|^\-?\$?([1-9]{1}\d{0,2}(\,\d{3})*(\.\d{0,2})?|[1-9]{1}\d{0,}(\.\d{0,2})?|0(\.\d{0,2})?|(\.\d{1,2}))$|^\(\$?([1-9]{1}\d{0,2}(\,\d{3})*(\.\d{0,2})?|[1-9]{1}\d{0,}(\.\d{0,2})?|0(\.\d{0,2})?|(\.\d{1,2}))\)$',
    'name': r'\w+',
    'age': r'\d{2,3}'
  };

  static bool dynamicValidation(Type d, String value){
    switch(d){
      case num:
        return dollarAmount(value);
      case String:
        return required(value);
      case Category:
        return required(value);
      default:
        throw Exception('unrecognized type input');
    }
  }

  static bool required(String input) {
    return !(input.trim() == '');
  }

  static const String REQUIRED_MESSAGE = 'Required field';

  static bool pin(String input) {
    return new RegExp(_regexMap['pin']).hasMatch(input);
  }

  static const String PIN_MESSAGE = 'Must be four digits';

  static bool dollarAmount(String input) {
    try {
      double.parse(input);
      return true;
    } catch (Object) {
      return false;
    }
  }

  static const String DOLLAR_MESSAGE = 'Must be a valid dollar amount';

  static bool name(String input) {
    return new RegExp(_regexMap['name']).hasMatch(input);
  }

  static bool age(String input) {
    return new RegExp(_regexMap['age']).hasMatch(input);
  }
}
