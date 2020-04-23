import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/abstract/serializable.dart';
import 'package:budgetflow/model/data_types/category.dart';
import 'package:budgetflow/model/data_types/location.dart';
import 'package:budgetflow/model/data_types/payment_method.dart';
import 'package:budgetflow/model/utils/serializer.dart';
import 'package:flutter/widgets.dart';

class Transaction implements Serializable {
  final DateTime time;
  final String vendor;
  final PaymentMethod method;
  final double amount;
  final Category category;
  final Location location;

  static final empty = Transaction(
    vendor: "",
    method: PaymentMethod.cash,
    amount: 0.0,
    category: Category.uncategorized,
    time: DateTime.now(),
  );

  Transaction({
    @required this.vendor,
    @required this.method,
    @required this.amount,
    @required this.category,
    @required this.time,
    this.location,
  });

  /// Returns the value side of a key-value pair used in storing this object as a JSON object.
  String get serialize {
    Serializer serializer = Serializer();
    serializer.addPair(timeKey, time.toIso8601String());
    serializer.addPair(vendorKey, vendor);
    serializer.addPair(methodKey, method);
    serializer.addPair(amountKey, amount);
    serializer.addPair(categoryKey, category);
    serializer.addPair(locationKey, location);
    return serializer.serialize;
  }

  bool operator ==(Object other) => other is Transaction && _equals(other);

  bool _equals(Transaction other) {
    return time == other.time &&
        vendor == other.vendor &&
        method == other.method &&
        amount == other.amount &&
        category == other.category &&
        (location == other.location ||
            (location == null && other.location == null));
  }

  /// The hash code for this object.
  int get hashCode =>
      time.hashCode ^
      vendor.hashCode ^
      method.hashCode ^
      amount.hashCode ^
      category.hashCode ^
      location.hashCode;
}
