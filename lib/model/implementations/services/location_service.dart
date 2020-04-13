import 'package:budgetflow/model/abstract/service.dart';
import 'package:budgetflow/model/data_types/location.dart';
import 'package:budgetflow/model/implementations/services/service_dispatcher.dart';
import 'package:geolocator/geolocator.dart';

class LocationService implements Service {
  ServiceDispatcher _dispatcher;
  Geolocator _geolocator = Geolocator();
  GeolocationStatus _status;

  LocationService(this._dispatcher);

  Future start() {
    // TODO implement start
    // Load map of locations -> categories for notifications
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
      // TODO respond if location not enabled
      return false;
    }
    if (!allowed) {
      // TODO respond if location not allowed
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
