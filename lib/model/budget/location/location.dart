import 'dart:async';
import 'dart:core';

import 'package:geolocator/geolocator.dart';

class Location {
  double StartingLatitude;
  double StartingLongitude;
  double LastKnownLatitude;
  double LastKnownLongitude;
  Future<double> distanceTraveled;
  GeolocationStatus locationStatus;
  Position currentPosition;
  Position lastKnownPosition;
  bool locationStatusPlaceholder = true;

  // ignore: cancel_subscriptions
  StreamSubscription<Position> positionStream = Geolocator()
      .getPositionStream(
          LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10))
      .listen((Position position) {
    print(position == null
        ? 'Unknown'
        : position.latitude.toString() + ', ' + position.longitude.toString());
  });

  Future checkPermission(GeolocationStatus status) async {
    status = await Geolocator().checkGeolocationPermissionStatus();
    locationStatus = status;
  }

  Future getLocation(Position position) async {
    if (locationStatusPlaceholder == true) {
      position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      currentPosition = position;
      StartingLatitude = currentPosition.latitude;
      StartingLongitude = currentPosition.longitude;
    } else {
      return;
    }
  }

  Future getLastKnownLocation(Position position) async {
    if (locationStatusPlaceholder == true) {
      position = await Geolocator()
          .getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
      lastKnownPosition = position;
      LastKnownLatitude = lastKnownPosition.latitude;
      LastKnownLongitude = lastKnownPosition.longitude;
    } else {}
  }

  Future setLocation(Position position) async{
    this.currentPosition = position;
  }

  Future setLastKnownLocation(Position position) async{
    this.lastKnownPosition = position;
  }

  void DistanceTraveled(double distance) {
    Future <double> distance = Geolocator().distanceBetween(StartingLatitude,
        StartingLongitude, LastKnownLatitude, LastKnownLongitude);
    distanceTraveled = distance;
  }
}
