import 'dart:async';
import 'dart:core';

import 'package:budgetflow/model/serialize/map_keys.dart';
import 'package:budgetflow/model/serialize/serializable.dart';
import 'package:budgetflow/model/serialize/serializer.dart';
import 'package:geolocator/geolocator.dart';

class Location implements Serializable {
  static bool permissionsEnabled;
  final double latitude, longitude;

  const Location(this.latitude, this.longitude);

  static Future<bool> get permissionEnabled async {
    var status = await Geolocator().checkGeolocationPermissionStatus();
    if (status == GeolocationStatus.disabled ||
        status == GeolocationStatus.denied) {
      return false;
    }
    return true;
  }

  static Future<Location> get current async {
    if (await Location.permissionEnabled) {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      return Location(position.latitude, position.longitude);
    }
    return null;
  }

  static Location fromGeolocatorPosition(Position position) {
    return Location(position.latitude, position.longitude);
  }

  Future<double> distanceTo(Location other) async {
    return await Geolocator()
        .distanceBetween(latitude, longitude, other.latitude, other.longitude);
  }

  String get serialize {
    Serializer serializer = new Serializer();
    serializer.addPair(KEY_LATITUDE, latitude);
    serializer.addPair(KEY_LONGITUDE, longitude);
  }
}
