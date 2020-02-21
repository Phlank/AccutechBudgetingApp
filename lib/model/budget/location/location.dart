import 'dart:async';
import 'dart:core';

import 'package:geolocator/geolocator.dart';

class Location {
  static bool permissionsEnabled;
  double latitude, longitude;

  Location(this.latitude, this.longitude);

  static Future<bool> get permissionEnabled async {
    var status = await Geolocator().checkGeolocationPermissionStatus();
    if (status == GeolocationStatus.disabled ||
        status == GeolocationStatus.denied) {
      return false;
    }
    return true;
  }

  Future<Location> get current async {
    if (await Location.permissionEnabled) {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      return Location(position.latitude, position.longitude);
    }
    return null;
  }
}
