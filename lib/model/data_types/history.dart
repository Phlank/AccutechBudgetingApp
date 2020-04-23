import 'package:budgetflow/model/abstract/serializable.dart';
import 'package:budgetflow/model/data_types/month.dart';
import 'package:budgetflow/model/utils/serializer.dart';
import 'package:quiver/collection.dart';

class History extends DelegatingList<Month> implements Serializable {
  List<Month> _months;
  List<DateTime> _monthTimes;

  List<Month> get delegate => _months;

  History() {
    _months = List<Month>();
    _monthTimes = List<DateTime>();
  }

  @override
  void add(Month month) {
    if (!_months.contains(month)) {
      _months.add(month);
      _monthTimes.add(month.time);
    }
  }

  @override
  bool remove(covariant Month month) {
    if (_months.contains(month)) {
      _months.remove(month);
      _monthTimes.remove(month.time);
      return true;
    }
    return false;
  }

  /// Returns the Month in History that matches the given [datetime]. If no match is found, returns `null`.
  Month getMonthFromDateTime(DateTime datetime) {
    return _months.firstWhere(
          (Month m) => m.timeIsInMonth(datetime),
      orElse: null,
          );
  }

  /// Returns the value side of a key-value pair used in storing this object as a JSON object.
  String get serialize {
    Serializer serializer = Serializer();
    int i = 0;
    for (Month month in _months) {
      serializer.addPair(i, month);
      i++;
    }
    return serializer.serialize;
  }

  bool operator ==(Object other) => other is History && _equals(other);

  bool _equals(History other) {
    if (length != other.length) {
      return false;
    }
    for (Month month in _months) {
      if (!other.contains(month)) {
        return false;
      }
    }
    return true;
  }

  int get hashCode => _months.hashCode;
}
