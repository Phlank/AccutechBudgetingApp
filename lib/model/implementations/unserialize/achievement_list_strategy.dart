import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/abstract/unserializer.dart';
import 'package:budgetflow/model/data_types/achievement_list.dart';
import 'package:budgetflow/model/utils/serializer.dart';

class AchievementListStrategy implements Unserializer {
  @override
  unserializeValue(Map value) {
    AchievementList output = AchievementList();
    for (var subvalue in value.values) {
      output.add(Serializer.unserialize(achievementKey, subvalue));
    }
    return output;
  }
}
