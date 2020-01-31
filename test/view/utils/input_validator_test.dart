import 'package:budgetflow/view/utils/input_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Test input 5.40 is dollarAmount', () {
    expect(InputValidator.dollarAmount('5.40'), true);
  });
  test('Test input 5.400 is dollarAmount', () {
    expect(InputValidator.dollarAmount('5.400'), true);
  });
  test('Test input 5.4 is dollarAmount', () {
    expect(InputValidator.dollarAmount('5.4'), true);
  });
  test('Test input 5 is dollarAmount', () {
    expect(InputValidator.dollarAmount('5'), true);
  });
  test('Test input 0 is dollarAmount', () {
    expect(InputValidator.dollarAmount('0'), true);
  });
  test('Test input "" is not dollarAmount', () {
    expect(InputValidator.dollarAmount(''), false);
  });
  test('Test input 5..40 is not dollarAmount', () {
    expect(InputValidator.dollarAmount('5..40'), false);
  });
  test('Test input 400.300.000 is not dollarAmount', () {
    expect(InputValidator.dollarAmount('400.300.000'), false);
  });
  test('Test input 1.23. is not dollarAmount', () {
    expect(InputValidator.dollarAmount('1.23.'), false);
  });
}
