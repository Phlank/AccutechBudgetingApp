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
    if (!hasDuplicateService(service)) {
      _services.add(service);
    }
  }

  Future registerAndStart(Service service) async {
    if (!hasDuplicateService(service)) {
      _services.add(service);
      await service.start();
    }
  }

  bool hasDuplicateService(Service service) {
    Type serviceType = service.runtimeType;
    var match = _services.firstWhere((test) {
      return test.runtimeType == serviceType;
    }, orElse: null);
    return match != null;
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
  AchievementService getAchievementService() {
    return _services.firstWhere((service) {
      return service is AchievementService;
    }, orElse: null);
  }

  FileService getFileService() {
    return _services.firstWhere((service) {
      return service is FileService;
    }, orElse: null);
  }

  LocationService getLocationService() {
    return _services.firstWhere((service) {
      return service is LocationService;
    }, orElse: null);
  }

  EncryptionService getEncryptionService() {
    return _services.firstWhere((service) {
      return service is EncryptionService;
    }, orElse: null);
  }

  HistoryService getHistoryService() {
    return _services.firstWhere((service) {
      return service is HistoryService;
    }, orElse: null);
  }

  AccountService get accountService {
    return _services.firstWhere((service) {
      return service is AccountService;
    }, orElse: null);
  }
}
