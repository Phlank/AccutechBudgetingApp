import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/abstract/serializable.dart';
import 'package:budgetflow/model/data_types/category.dart';
import 'package:budgetflow/model/utils/serializer.dart';

class Allocation implements Serializable {
  Category category;
  double value;

  Allocation(this.category, this.value);

  /// Returns the value side of a key-value pair used in storing this object as a JSON object.
  String get serialize {
    Serializer serializer = Serializer();
    serializer.addPair(categoryKey, category);
    serializer.addPair(amountKey, value);
    return serializer.serialize;
  }

  bool operator ==(Object other) => other is Allocation && this._equals(other);

  bool _equals(Allocation other) {
    return this.category == other.category && this.value == other.value;
  }

  int get hashCode => category.hashCode;
}
