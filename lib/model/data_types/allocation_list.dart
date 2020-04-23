import 'package:budgetflow/model/abstract/serializable.dart';
import 'package:budgetflow/model/data_types/allocation.dart';
import 'package:budgetflow/model/data_types/category.dart';
import 'package:budgetflow/model/utils/serializer.dart';
import 'package:quiver/collection.dart';

class AllocationList extends DelegatingList<Allocation>
    implements Serializable {
  /// Creates a new AllocationList.
  ///
  /// If [allocations] is unspecified, [delegate] will initialize as an empty list.
  /// Otherwise, [delegate] will initialize as [allocations].
  AllocationList([List<Allocation> allocations]) {
    if (allocations != null) _list = allocations;
  }

  /// Constructs a new AllocationList with predetermined [Category] objects.
  ///
  /// Used when creating a new budget from user-provided information during setup.
  AllocationList.defaultCategories() {
    Category.defaultCategories.forEach((category) {
      _list.add(Allocation(category, 0.0));
    });
  }

  List<Allocation> _list = [];

  /// The delegate list of the superclass.
  List<Allocation> get delegate => _list;

  /// Constructs a new AllocationList with the same categories as [other].
  ///
  /// All values of the Allocation objects in the constructed list will equal `0`.
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

  /// Returns a sublist of [Allocation] objects with Categories of type Saving.
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

  /// Returns the element in this list that has the same Category as [allocation].
  Allocation getWithSameCategory(Allocation allocation) {
    for (Allocation element in _list) {
      if (allocation.category == element.category) return element;
    }
    return null;
  }

  /// Returns the element in this list with [category].
  Allocation getCategory(Category category) {
    for (Allocation element in _list) {
      if (element.category == category) return element;
    }
    return null;
  }

  /// Returns a new AllocationList with all values divided by [n].
  AllocationList divide(double n) {
    AllocationList output = AllocationList();
    for (Allocation element in _list) {
      output.add(Allocation(element.category, element.value / 4));
    }
    return output;
  }

  bool operator ==(Object other) =>
      other is AllocationList && this._equals(other);

  bool _equals(AllocationList other) {
    if (length != other.length) {
      return false;
    }
    for (Allocation allocation in _list) {
      if (!other.contains(allocation)) {
        return false;
      }
    }
    return true;
  }

  /// The hash code for this object.
  int get hashCode => _list.hashCode;
}
