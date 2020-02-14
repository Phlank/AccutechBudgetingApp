import 'dart:async';
import 'dart:core';
import 'package:geolocator/geolocator.dart';

 class Location{
   double startingLatitude;
   double startingLongitude;
   double lastKnownLatitude;
   double lastKnownLongitude;
   Future<double> distanceTraveled;
   GeolocationStatus locationStatus;
   Position currentPosition;
   Position lastKnownPosition;
   bool locationStatusPlaceholder = true;

   // ignore: cancel_subscriptions
   StreamSubscription<Position> positionStream = Geolocator().
   getPositionStream(LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10)).
   listen(
           (Position position) {
         print(position == null ? 'Unknown' : position.latitude.toString() + ', ' + position.longitude.toString());
       });

  Future checkPermission() async {
    locationStatus = await Geolocator().checkGeolocationPermissionStatus();
  }
  Future getLocation() async{
    if (locationStatusPlaceholder == true){
    currentPosition = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    startingLatitude = currentPosition.latitude;
    startingLongitude = currentPosition.longitude;
    }
    else{

    }
  }

  Future getLastKnownLocation() async{
    if (locationStatusPlaceholder == true){
    lastKnownPosition = await Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
    lastKnownLatitude = lastKnownPosition.latitude;
    lastKnownLongitude = lastKnownPosition.longitude;
    }
    else{

    }
  }

  void DistanceTraveled(){
    distanceTraveled = Geolocator().distanceBetween(startingLatitude, startingLongitude, lastKnownLatitude, lastKnownLongitude);
  }
}