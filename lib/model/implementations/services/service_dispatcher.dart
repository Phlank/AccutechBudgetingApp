import 'package:budgetflow/model/abstract/service.dart';
import 'package:budgetflow/model/implementations/services/achievement_service.dart';
import 'package:budgetflow/model/implementations/services/encryption_service.dart';
import 'package:budgetflow/model/implementations/services/file_service.dart';
import 'package:budgetflow/model/implementations/services/history_service.dart';
import 'package:budgetflow/model/implementations/services/location_service.dart';

class ServiceDispatcher {
  List<Service> _services = [];

  void register(Service service) {
    _services.add(service);
  }

  Future registerAndStart(Service service) async {
    _services.add(service);
    await service.start();
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
}
