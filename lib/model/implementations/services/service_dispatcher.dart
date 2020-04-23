import 'package:budgetflow/model/abstract/saveable.dart';
import 'package:budgetflow/model/abstract/service.dart';
import 'package:budgetflow/model/implementations/services/account_service.dart';
import 'package:budgetflow/model/implementations/services/achievement_service.dart';
import 'package:budgetflow/model/implementations/services/encryption_service.dart';
import 'package:budgetflow/model/implementations/services/file_service.dart';
import 'package:budgetflow/model/implementations/services/history_service.dart';
import 'package:budgetflow/model/implementations/services/location_service.dart';

class ServiceDispatcher {
  List<Service> _services = [];

  void register(Service service) {
    if (!_hasDuplicateService(service)) {
      _services.add(service);
    }
  }

  Future registerAndStart(Service service) async {
    if (!_hasDuplicateService(service)) {
      _services.add(service);
      await service.start();
      print('ServiceDispatcher: Started ' + service.runtimeType.toString());
    }
  }

  bool _hasDuplicateService(Service service) {
    if (_services.isEmpty) {
      return false;
    }
    for (Service element in _services) {
      print('Testing runtime types: input=' +
          service.runtimeType.toString() +
          ' vs element=' +
          element.runtimeType.toString());
      if (service.runtimeType == element.runtimeType) {
        return true;
      }
    }
    return false;
  }

  Future startAll() async {
    for (var service in _services) {
      await service.start();
    }
  }

  void stopAll() {
    for (var service in _services) {
      service.stop();
    }
  }

  Future saveApplicable() async {
    for (Object service in _services) {
      if (service is Saveable) {
        await service.save();
      }
    }
  }

  // There is no way in Dart 2 as of 4/19/2020 to implement the DRY principle here. This is the best way I've found so far to do this.
  AchievementService get achievementService =>
      _getRequestedService(AchievementService);

  FileService get fileService => _getRequestedService(FileService);

  LocationService get locationService => _getRequestedService(LocationService);

  EncryptionService get encryptionService =>
      _getRequestedService(EncryptionService);

  HistoryService get historyService => _getRequestedService(HistoryService);

  AccountService get accountService => _getRequestedService(AccountService);

  Service _getRequestedService(Type ofType) {
    for (Service service in _services) {
      if (service.runtimeType == ofType) {
        return service;
      }
    }
    return null;
  }
}
