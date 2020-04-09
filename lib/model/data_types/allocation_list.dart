import 'package:budgetflow/model/abstract/serializable.dart';
import 'package:budgetflow/model/data_types/allocation.dart';
import 'package:budgetflow/model/data_types/category.dart';
import 'package:budgetflow/model/utils/serializer.dart';
import 'package:quiver/collection.dart';

class AllocationList extends DelegatingList<Allocation>
    implements Serializable {
  List<Allocation> _list = [];

  List<Allocation> get delegate => _list;

  AllocationList([List<Allocation> allocations]) {
    if (allocations != null) _list = allocations;
  }

  /// Constructs a new AllocationList with predetermined [Categories](Category).
  ///
  /// Used when creating a new budget from user-provided information.
  AllocationList.defaultCategories() {
    Category.defaultCategories.forEach((category) {
      _list.add(Allocation(category, 0.0));
    });
  }

  /// New list with the same objects as the specified list.
  ///
  /// Manipulating objects in the constructed list will also manipulate objects in the specified list.
  AllocationList.from(AllocationList other) {
    _list = List.from(other);
  }

  /// Constructs a new AllocationList with the same categories as another specified AllocationList.
  ///
  /// All values for the (Allocations)[ALlocation] in the constructed list will equal 0.
  AllocationList.withCategoriesOf(AllocationList other) {
    other.forEach((allocation) {
      _list.add(Allocation(allocation.category, 0.0));
    });
  }

  /// Adds the specified Allocation to the AllocationList if it is not currently contained within the AllocationList.
  void add(Allocation value) {
    if (!_list.contains(value)) {
      _list.add(value);
    }
  }

  /// Returns a sublist of Allocations with Categories of type Spending.
  AllocationList get spendingAllocations {
    AllocationList spending = AllocationList();
    _list.forEach((allocation) {
      if (allocation.category.isSpending) spending.add(allocation);
    });
    return spending;
  }

  /// Returns a sublist of Allocations with Categories of type Saving.
  AllocationList get savingAllocations {
    AllocationList saving = AllocationList();
    _list.forEach((allocation) {
      if (allocation.category.isSaving) saving.add(allocation);
    });
    return saving;
  }

  /// Returns a sublist of Allocations with Categories of type Income.
  AllocationList get incomeAllocations {
    AllocationList income = AllocationList();
    _list.forEach((allocation) {
      if (allocation.category.isIncome) income.add(allocation);
    });
    return income;
  }

  /// Returns the value side of a key-value pair used in storing this object as a JSON object.
  String get serialize {
    Serializer serializer = Serializer();
    for (int i = 0; i < _list.length; i++) {
      serializer.addPair("$i", _list[i].serialize);
    }
    return serializer.serialize;
  }

  Allocation getWithSameCategory(Allocation allocation) {
    return _list.firstWhere((element) {
      return element.category == allocation.category;
    });
  }

  Allocation getCategory(Category category) {
    Allocation output = _list.firstWhere((element) {
      return element.category == category;
    });
    return output;
  }

  AllocationList divide(double n) {
    AllocationList output = AllocationList();
    forEach((allocation) {
      output.add(Allocation(allocation.category, allocation.value / n));
    });
    return output;
  }

  bool operator ==(Object other) =>
      other is AllocationList && this._equals(other);

  bool _equals(AllocationList other) {
    bool output = true;
    if (this.length == other.length) {
      this.forEach((allocation) {
        if (other.contains(allocation)) output = false;
      });
    } else {
      output = false;
    }
    return output;
  }

  int get hashCode => _list.hashCode;

  void printOut() {
    forEach((allocation) {
      print(allocation.category.name + ': ' + allocation.value.toString());
    });
  }
}
