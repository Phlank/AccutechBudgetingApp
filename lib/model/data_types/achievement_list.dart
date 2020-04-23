import 'package:budgetflow/model/abstract/serializable.dart';
import 'package:budgetflow/model/data_types/achievement.dart';
import 'package:budgetflow/model/utils/serializer.dart';
import 'package:quiver/collection.dart';

class AchievementList extends DelegatingList<Achievement>
    implements Serializable {
  List<Achievement> _list;

  List<Achievement> get delegate => _list;

  AchievementList() {
    _list = List<Achievement>();
  }

  /// Returns the value side of a key-value pair used in storing this object as a JSON object.
  String get serialize {
    Serializer serializer = Serializer();
    for (int i = 0; i < _list.length; i++) {
      serializer.addPair(i, _list[i]);
    }
    return serializer.serialize;
  }

  bool operator ==(Object other) => other is AchievementList && _equals(other);

  bool _equals(AchievementList other) {
    if (length != other.length) {
      return false;
    }
    for (Achievement achievement in _list) {
      if (!other.contains(achievement)) {
        return false;
      }
    }
    return true;
  }

  int get hashCode => _list.hashCode;
}
