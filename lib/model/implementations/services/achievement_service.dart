import 'package:budgetflow/global/strings.dart';
import 'package:budgetflow/model/abstract/service.dart';
import 'package:budgetflow/model/data_types/achievement_list.dart';
import 'package:budgetflow/model/implementations/services/file_service.dart';
import 'package:budgetflow/model/implementations/services/service_dispatcher.dart';

class AchievementService implements Service {
  ServiceDispatcher _dispatcher;
  FileService _fileService;
  AchievementList _earned;
  AchievementList _available;

  AchievementService(this._dispatcher) {
    _fileService = _dispatcher.getFileService();
  }

  Future start() async {
    // TODO: implement start
    if (await _filesExist()) {
      await _loadPossibleAchievements();
      await _loadEarnedAchievements();
    }
    // else earned is empty list, possible is default list
  }

  Future<bool> _filesExist() async {
    return await _fileService.fileExists(earnedAchievementsFilepath) &&
        await _fileService.fileExists(possibleAchievementsFilepath);
  }

  Future _loadAchievements() async {
    await _loadPossibleAchievements();
    await _loadEarnedAchievements();
  }

  Future _loadPossibleAchievements() {

  }

  Future _loadEarnedAchievements() {

  }

  Future stop() {
    // TODO: implement stop
    // save the list of possible achievements
    // save the list of earned achievements
  }
}
