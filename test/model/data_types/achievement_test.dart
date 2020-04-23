import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/data_types/achievement.dart';
import 'package:budgetflow/model/data_types/achievement_list.dart';
import 'package:budgetflow/model/utils/serializer.dart';
import 'package:flutter_test/flutter_test.dart';

Achievement achievement;
Achievement achievement1, achievement2, achievement3;
AchievementList achievementList;

void main() {
  group('Achievement Tests', () {
    setUp(() {
      achievement = Achievement(
        name: 'name',
        title: 'title',
        description: 'this is a sample achievement description',
        currentProgress: 0,
        targetProgress: 5,
      );
    });
    test('Serialization sanity', () {
      String serialized = achievement.serialize;
      Achievement fromSerialized =
          Serializer.unserialize(achievementKey, serialized);
      expect(achievement == fromSerialized, isTrue);
    });
    test('Unearned when progress not met', () {
      expect(achievement.earned, isFalse);
    });
    test('Earned when progress met', () {
      achievement.earn();
      expect(achievement.earned, isTrue);
    });
    test('Progress scales with currentProgress', () {
      achievement.currentProgress = 1;
      expect(achievement.progress, 0.2);
      achievement.currentProgress = 3;
      expect(achievement.progress, 0.6);
    });
  });
}
