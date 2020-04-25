import 'package:budgetflow/model/abstract/service.dart';
import 'package:budgetflow/model/data_types/category.dart';
import 'package:budgetflow/model/data_types/location.dart';
import 'package:budgetflow/model/data_types/transaction.dart';
import 'package:budgetflow/model/implementations/services/service_dispatcher.dart';
import 'package:geolocator/geolocator.dart';

class LocationService implements Service {
  ServiceDispatcher _dispatcher;
  Geolocator _geolocator = Geolocator();
  GeolocationStatus _status;
  Map<Location, Category> _notificationMap = {};

  /// Controls the required distance needed to be within a certain location to trigger a notification.
  final int _metersThreshold = 10;

  LocationService(this._dispatcher);

  Future start() {
    assert(_dispatcher.historyService != null);
    _loadNotificationMap();
    _startLocationNotificationStream();
    return null;
  }

  void _loadNotificationMap() {
    for (Transaction transaction in _dispatcher.historyService
        .allTransactions) {
      if (transaction.location != null) {
        if (!_notificationMap.containsKey(transaction.location)) {
          _notificationMap[transaction.location] = transaction.category;
        }
      }
    }
  }

  void _startLocationNotificationStream() {
    getLocationStream().listen(_respondToLocations);
  }

  Future<void> _respondToLocations(Location location) async {
    for (Location nLocation in _notificationMap.keys) {
      if (await nLocation.distanceTo(location) < 10) {
        // TODO trigger notification
      }
    }
  }

  Future stop() {
    // TODO implement stop
    // Save any important information
  }

  Future<bool> isEnabled() {
    return _geolocator.isLocationServiceEnabled();
  }

  Future<bool> isAllowed() async {
    _status = await _geolocator.checkGeolocationPermissionStatus();
    return _status == GeolocationStatus.granted;
  }

  Future<bool> _checkStatus() async {
    bool enabled = await isEnabled();
    bool allowed = await isAllowed();
    if (!enabled) {
      return false;
    }
    if (!allowed) {
      return false;
    }
    return true;
  }

  Future<Location> getCurrentLocation() async {
    bool goodStatus = await _checkStatus();
    if (goodStatus) {
      return _positionToLocation(await _geolocator.getCurrentPosition());
    }
    return null;
  }

  Location _positionToLocation(Position position) {
    return Location(position.latitude, position.longitude);
  }

  Stream<Location> getLocationStream() {
    return _geolocator.getPositionStream().map((event) {
      // Each Position from og stream is mapped to Location for the new stream
      return _positionToLocation(event);
    });
  }
}
