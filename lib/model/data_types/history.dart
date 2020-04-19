import 'package:budgetflow/model/abstract/serializable.dart';
import 'package:budgetflow/model/data_types/month.dart';
import 'package:budgetflow/model/utils/serializer.dart';
import 'package:quiver/collection.dart';

class History extends DelegatingList<Month> implements Serializable {
  List<Month> _months;
  List<DateTime> _monthTimes;

  List<Month> get delegate => _months;

  History() {
    _months = [];
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

  /// Returns the Month in History that matches the given DateTime. If no match is found, returns null.
  Month getMonthFromDateTime(DateTime dt) {
    return _months.firstWhere((Month m) => m.timeIsInMonth(dt), orElse: null);
  }

  /// Returns the value side of a key-value pair used in storing this object as a JSON object.
  String get serialize {
    Serializer serializer = Serializer();
    int i = 0;
    _monthTimes.forEach((DateTime dt) {
      serializer.addPair(i, dt.toIso8601String());
      i++;
    });
    return serializer.serialize;
  }
}
