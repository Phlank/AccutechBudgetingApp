import 'package:budgetflow/global/defaults.dart';
import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/abstract/service.dart';
import 'package:budgetflow/model/data_types/achievement.dart';
import 'package:budgetflow/model/data_types/achievement_list.dart';
import 'package:budgetflow/model/implementations/services/file_service.dart';
import 'package:budgetflow/model/implementations/services/service_dispatcher.dart';
import 'package:budgetflow/model/utils/serializer.dart';

class AchievementService implements Service {
  ServiceDispatcher _dispatcher;
  FileService _fileService;
  AchievementList _earned;
  AchievementList _possible;

  AchievementService(this._dispatcher) {
    _fileService = _dispatcher.getFileService();
  }

  Future start() async {
    if (await _filesExist()) {
      await _loadAchievements();
    } else {
      _earned = List();
      _possible = List();
      for (var achievement in defaultAchievements) {
        _possible.add(achievement);
      }
    }
  }

  Future<bool> _filesExist() async {
    return await _fileService.fileExists(earnedAchievementsFilepath) &&
        await _fileService.fileExists(possibleAchievementsFilepath);
  }

  Future _loadAchievements() async {
    await _loadPossibleAchievements();
    await _loadEarnedAchievements();
  }

  Future _loadEarnedAchievements() async {
    String content =
    await _fileService.readAndDecryptFile(earnedAchievementsFilepath);
    _earned = Serializer.unserialize(achievementListKey, content);
  }

  Future _loadPossibleAchievements() async {
    String content =
    await _fileService.readAndDecryptFile(possibleAchievementsFilepath);
    _earned = Serializer.unserialize(achievementListKey, content);
  }

  Future stop() {
    save();
    return null;
  }

  Future save() {
    _saveEarnedAchievements();
    _savePossibleAchievements();
  }

  Future _saveEarnedAchievements() {
    String content = _earned.serialize;
    return _fileService.encryptAndWriteFile(
      earnedAchievementsFilepath,
      content,
    );
  }

  Future _savePossibleAchievements() {
    String content = _possible.serialize;
    return _fileService.encryptAndWriteFile(
      possibleAchievementsFilepath,
      content,
    );
  }

  bool isEarned(Achievement achievement) {
    return _earned.contains(achievement);
  }

  void earn(Achievement achievement) {
    if (!_earned.contains(achievement)) {
      _earned.add(achievement);
    }
    // TODO display popup
  }

  int get numEarned => _earned.length;

  AchievementList get earned => _earned;
}
