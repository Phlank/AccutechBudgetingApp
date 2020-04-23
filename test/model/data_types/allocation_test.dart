import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/data_types/allocation.dart';
import 'package:budgetflow/model/data_types/allocation_list.dart';
import 'package:budgetflow/model/data_types/category.dart';
import 'package:budgetflow/model/utils/serializer.dart';
import 'package:flutter_test/flutter_test.dart';

Allocation allocation;
AllocationList allocationList;
Allocation allocation1, allocation2, allocation3;

void main() {
  group('Allocation Tests', () {
    setUp(() {
      allocation = Allocation(Category.uncategorized, 300);
    });
    test('Serialization sanity', () {
      String serialized = allocation.serialize;
      Allocation fromSerialized =
      Serializer.unserialize(allocationKey, serialized);
      expect(allocation == fromSerialized, isTrue);
    });
  });
  group('AllocationList Tests', () {
    setUp(() {
      allocation1 = Allocation(Category.savings, 200);
      allocation2 = Allocation(Category.pets, 400);
      allocation3 = Allocation(Category.groceries, 900);
      allocationList = AllocationList([allocation1, allocation2, allocation3]);
    });
    test('Serialization sanity', () {
      String serialized = allocationList.serialize;
      AllocationList fromSerialized =
      Serializer.unserialize(allocationListKey, serialized);
      expect(allocationList == fromSerialized, isTrue);
    });
  });
}
