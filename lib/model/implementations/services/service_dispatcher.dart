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
      print('ServiceDispatcher: Started ' + service.runtimeType.toString());
    }
  }

  bool hasDuplicateService(Service service) {
    if (_services.isEmpty) {
      return false;
    }
    for (Service element in _services) {
      print('Testing runtime types: input=' + service.runtimeType.toString() +
          ' vs element=' + element.runtimeType.toString());
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
  AchievementService get achievementService {
    return _services.firstWhere((service) {
      return service is AchievementService;
    }, orElse: null);
  }

  FileService get fileService {
    return _services.firstWhere((service) {
      return service is FileService;
    }, orElse: null);
  }

  LocationService get locationService {
    return _services.firstWhere((service) {
      return service is LocationService;
    }, orElse: null);
  }

  EncryptionService get encryptionService {
    return _services.firstWhere((service) {
      return service is EncryptionService;
    }, orElse: null);
  }

  HistoryService get historyService {
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
