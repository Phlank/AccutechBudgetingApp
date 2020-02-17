import 'package:budgetflow/model/budget/data/category.dart';
import 'package:budgetflow/model/budget/data/priority.dart';
import 'package:flutter_test/flutter_test.dart';

Category cHousing,
    cGroceries,
    cSavings,
    cEntertainment,
    cUncategorized,
    cNeed1,
    cNeed2,
    cNeed3;

void main() {
  group('Category tests', () {
    setUp(() {
      cNeed1 = new Category('1', Priority.need);
      cNeed2 = new Category('2', Priority.need);
      cNeed3 = new Category('3', Priority.need);
      cHousing = new Category("Housing", Priority.required);
      cGroceries = new Category("Groceries", Priority.need);
      cSavings = new Category("Savings", Priority.savings);
      cEntertainment = new Category("Entertainment", Priority.want);
      cUncategorized = new Category("Uncategorized", Priority.other);
    });
    test('Test cNeed1.compareTo(cNeed2) is 1', () {
      expect(cNeed1.compareTo(cNeed2), -1);
    });
    test('Test cNeed2.compareTo(cNeed2) is 0', () {
      expect(cNeed2.compareTo(cNeed2), 0);
    });
    test('Test cNeed2.compareTo(cNeed3) is -1', () {
      expect(cNeed2.compareTo(cNeed3), -1);
    });
    test('Test cNeed3.compareTo(cNeed2) is 1', () {
      expect(cNeed3.compareTo(cNeed2), 1);
    });
    test('Test cNeed2.compareTo(cNeed1) is 1', () {
      expect(cNeed2.compareTo(cNeed1), 1);
    });
    test('Test cNeed3.compareTo(cNeed1) is 1', () {
      expect(cNeed3.compareTo(cNeed1), 1);
    });
    test('Test cNeed1.compareTo(cNeed3) is -1', () {
      expect(cNeed1.compareTo(cNeed3), -1);
    });
    test('Test cNeed1.serialize', () {
      expect(cNeed1.serialize, '{"name":"1","priority":"Need"}');
    });
    test('Test cNeed2.serialize', () {
      expect(cNeed2.serialize, '{"name":"2","priority":"Need"}');
    });
    test('Test unserialize cNeed1', () {
      Category fromSerialized = Category.unserialize('{"name":"1","priority":"Need"}');
      expect(fromSerialized == cNeed1, true);
    });
    test('Test unserialize cNeed2', () {
      Category fromSerialized = Category.unserialize('{"name":"2","priority":"Need"}');
      expect(fromSerialized == cNeed2, true);
    });
    test('Serialization sanity', () {
      Category fromSerialized = Category.unserialize(
          '{"name":"1","priority":"Need"}');
      String serialized = fromSerialized.serialize;
      Category copyFS = Category.unserialize(serialized);
      expect(fromSerialized == copyFS, isTrue);
    });
  });
}
