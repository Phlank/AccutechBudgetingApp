import 'package:budgetflow/model/abstract/serializable.dart';
import 'package:budgetflow/model/data_types/achievement.dart';
import 'package:quiver/collection.dart';

class AchievementList extends DelegatingList<Achievement>
    implements Serializable {
  List<Achievement> _list;

  List<Achievement> get delegate => _list;

  // TODO add saving and loading to this

  // TODO Implement
  /// Returns the value side of a key-value pair used in storing this object as a JSON object.
  String get serialize => null;
}
