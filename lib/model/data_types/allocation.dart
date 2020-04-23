import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/abstract/serializable.dart';
import 'package:budgetflow/model/data_types/category.dart';
import 'package:budgetflow/model/utils/serializer.dart';

/// A data type which holds information about how much money is involved with a
/// category.
class Allocation implements Serializable {
  /// Creates an Allocation object.
  Allocation(this.category, this.value);

  /// The relevant category of the Allocation.
  Category category;

  /// The relevant value of the Allocation.
  double value;

  /// Returns the value side of a key-value pair used in storing this object as a JSON object.
  String get serialize {
    Serializer serializer = Serializer();
    serializer.addPair(categoryKey, category);
    serializer.addPair(amountKey, value);
    return serializer.serialize;
  }

  /// Returns true if this Allocation has the same [category] and [value] as [other].
  bool operator ==(Object other) => other is Allocation && this._equals(other);

  bool _equals(Allocation other) {
    return this.category == other.category && this.value == other.value;
  }

  /// The hash code for this object.
  int get hashCode => category.hashCode;
}
