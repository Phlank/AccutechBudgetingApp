import 'package:budgetflow/global/achievements.dart';
import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/abstract/saveable.dart';
import 'package:budgetflow/model/abstract/service.dart';
import 'package:budgetflow/model/data_types/achievement.dart';
import 'package:budgetflow/model/data_types/achievement_list.dart';
import 'package:budgetflow/model/implementations/services/file_service.dart';
import 'package:budgetflow/model/implementations/services/service_dispatcher.dart';
import 'package:budgetflow/model/utils/serializer.dart';

class AchievementService implements Service, Saveable {
  ServiceDispatcher _dispatcher;
  FileService _fileService;
  AchievementList _achievements;

  static final _achievementsNotLoadedMessage =
      'Achievements have not been loaded for this service. Has this service finished starting?';

  AchievementList get all => _achievements;

  AchievementList get earned {
    AchievementList output = AchievementList();
    for (Achievement achievement in _achievements) {
      if (achievement.earned) output.add(achievement);
    }
    return output;
  }

  AchievementList get unearned {
    AchievementList output = AchievementList();
    for (Achievement achievement in _achievements) {
      if (!achievement.earned) output.add(achievement);
    }
    return output;
  }

  AchievementService(this._dispatcher) {
    _fileService = _dispatcher.fileService;
  }

  Future start() async {
    if (await _filesExist()) {
      await _loadAchievements();
    } else {
      _achievements = AchievementList();
      for (var achievement in Achievements.defaults) {
        _achievements.add(achievement);
      }
    }
  }

  Future<bool> _filesExist() async {
    return await _fileService.fileExists(achievementsFilepath);
  }

  Future _loadAchievements() async {
    String content = await _fileService.readFile(achievementsFilepath);
    _achievements = Serializer.unserialize(achievementListKey, content);
  }

  Future stop() {
    save();
    return null;
  }

  /// Write achievements to disk.
  Future save() async {
    String content = _achievements.serialize;
    return _fileService.writeFile(achievementsFilepath, content);
  }

  /// Increments currentProgress of target by 1 and returns true if the [Achievement] is not earned prior to the method call.
  ///
  /// If the [Achievement] was earned prior to calling this method, it will return false. However, if the achievement was not earned prior to calling this method, it will return true.
  bool incrementProgress(Achievement target) {
    Achievement achievementInMemory = _achievements.firstWhere((element) {
      return _achievementsMatch(target, element);
    });
    assert(achievementInMemory != null, _achievementsNotLoadedMessage);
    if (target.currentProgress < target.targetProgress) {
      target.currentProgress++;
      return target.earned;
    }
    return false;
  }

  bool _achievementsMatch(Achievement ach1, Achievement ach2) {
    return ach1.name == ach2.name;
  }
}
