import 'package:budgetflow/model/abstract/service.dart';
import 'package:budgetflow/model/implementations/services/service_dispatcher.dart';

class AchievementService implements Service {
  ServiceDispatcher _dispatcher;

  AchievementService(this._dispatcher);

  Future start() {
    // TODO: implement start
    // see if files exist
    // load the list of possible achievements
    // load the list of earned achievements
  }

  Future<bool> _filesExist() async {

  }

  Future stop() {
    // TODO: implement stop
    // save the list of possible achievements
    // save the list of earned achievements
  }
}
