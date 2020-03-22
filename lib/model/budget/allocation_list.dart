import 'package:budgetflow/model/budget/allocation.dart';
import 'package:budgetflow/model/budget/category/category.dart';
import 'package:budgetflow/model/budget/category/category_list.dart';
import 'package:budgetflow/model/serialize/serializable.dart';
import 'package:budgetflow/model/serialize/serializer.dart';
import 'package:quiver/collection.dart';

class AllocationList extends DelegatingList<Allocation>
    implements Serializable {
  List<Allocation> _list = [];

  List<Allocation> get delegate => _list;

  AllocationList([List<Allocation> allocations]) {
    if (allocations != null)
      _list = allocations;
  }

  AllocationList.defaultCategories() {
    CategoryList.defaultCategories.forEach((category) {
      _list.add(Allocation(category, 0.0));
    });
  }

  AllocationList.from(AllocationList other) {
    _list = List.from(other);
  }

  AllocationList.withCategoriesOf(AllocationList other) {
    other.forEach((allocation) {
      _list.add(Allocation(allocation.category, 0.0));
    });
  }

  void add(Allocation value) {
    if (!_list.contains(value)) {
      _list.add(value);
    }
  }

  AllocationList get spendingAllocations {
    AllocationList spending = AllocationList([]);
    _list.forEach((allocation) {
      if (allocation.category.isSpending) spending.add(allocation);
    });
    return spending;
  }

  AllocationList get savingAllocations {
    AllocationList saving = AllocationList([]);
    _list.forEach((allocation) {
      if (allocation.category.isSaving) saving.add(allocation);
    });
    return saving;
  }

  AllocationList get incomeAllocations {
    AllocationList income = AllocationList([]);
    _list.forEach((allocation) {
      if (allocation.category.isIncome) income.add(allocation);
    });
    return income;
  }

  String get serialize {
    Serializer serializer = Serializer();
    for (int i = 0; i < _list.length; i++) {
      serializer.addPair("$i", _list[i].serialize);
    }
    return serializer.serialize;
  }

  Allocation get(Allocation allocation) {
    return _list.firstWhere((element) {
      return element.category == allocation.category;
    });
  }

  Allocation getCategory(Category category) {
    return _list.firstWhere((element) {
      return element.category == category;
    });
  }

  AllocationList divide(double n) {
    AllocationList output = AllocationList.from(this);
    output.forEach((allocation) {
      allocation.value = this
          .getCategory(allocation.category)
          .value / n;
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
}
