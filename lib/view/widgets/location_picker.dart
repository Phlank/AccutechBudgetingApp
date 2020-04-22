import 'package:budgetflow/global/api_keys.dart';
import 'package:budgetflow/model/data_types/location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:place_picker/place_picker.dart';

class LocationPicker {
  static Future<Location> show(BuildContext context, Location location) async {
    LatLng displayLocation;
    if (location != null) {
      displayLocation = LatLng(location.latitude, location.longitude);
    } else {
      displayLocation = LatLng(0, 0);
    }
    LocationResult result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PlacePicker(
          googleMapsAPIKey,
          displayLocation: displayLocation,
        ),
      ),
    );
    return Location(result.latLng.latitude, result.latLng.longitude);
  }
}
