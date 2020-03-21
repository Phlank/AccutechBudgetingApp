import 'package:budgetflow/model/budget/category/category.dart';
import 'package:budgetflow/model/serialize/map_keys.dart';
import 'package:budgetflow/model/serialize/serializable.dart';
import 'package:budgetflow/model/serialize/serializer.dart';

class Allocation implements Serializable {
  Category category;
  double value;

  Allocation(this.category, this.value);

  String get serialize {
    Serializer serializer = Serializer();
    serializer.addPair(categoryKey, category);
    serializer.addPair(amountKey, value);
    return serializer.serialize;
  }
}
