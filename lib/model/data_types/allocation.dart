import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/abstract/serializable.dart';
import 'package:budgetflow/model/data_types/category.dart';
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

  bool operator ==(Object other) => other is Allocation && this._equals(other);

  bool _equals(Allocation other) {
    return this.category == other.category;
  }

  int get hashCode => category.hashCode;
}
