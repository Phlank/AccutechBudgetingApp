import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/abstract/unserializer.dart';
import 'package:budgetflow/model/data_types/achievement.dart';

class AchievementStrategy implements Unserializer {
  @override
  unserializeValue(Map value) {
    return Achievement(
      name: value[nameKey],
      title: value[titleKey],
      description: value[achievementDescriptionKey],
      currentProgress: int.parse(value[currentProgressKey]),
      targetProgress: int.parse(value[targetProgressKey]),
    );
  }
}
