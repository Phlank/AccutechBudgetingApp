import 'package:budgetflow/model/budget/allocation.dart';
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
    else {
      CategoryList.defaultCategories.forEach((category) {
        _list.add(Allocation(category, 0.0));
      });
    }
  }

  AllocationList.from(AllocationList other) {
    _list = List.from(other);
  }

  AllocationList.withCategoriesOf(AllocationList other) {
    other.forEach((allocation) {
      _list.add(Allocation(allocation.category, 0.0));
    });
  }

  String get serialize {
    Serializer serializer = Serializer();
    for (int i = 0; i < _list.length; i++) {
      serializer.addPair("$i", _list[i].serialize);
    }
    return serializer.serialize;
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
