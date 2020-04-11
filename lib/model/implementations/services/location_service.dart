import 'package:budgetflow/model/abstract/service.dart';
import 'package:budgetflow/model/data_types/location.dart';
import 'package:geolocator/geolocator.dart';

class LocationService implements Service {
  Geolocator _geolocator = Geolocator();
  GeolocationStatus _status;
  Stream<Location> _locationStream = Stream.empty();

  void start() {
    // TODO: implement start
  }

  void stop() {
    // TODO: implement stop
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
