import 'package:budgetflow/model/budget/location/location.dart';
import 'package:geolocator/geolocator.dart';

class AssetValuation {
//Work in Progress, not plugged in to the rest of the software yet
  double assetValue = 0.0;
  double newAssetValue = 0.0;
  double mileage = 0.0;
  double assetDepreciation = 0.0;
  double distance = 0.0;
  Location location;
  double latitude = 0.0;
  double longitude = 0.0;

  AssetValuation() {
    setAssetValue(0.0);
    setDistance(0.0);
    setMileage(0.0);
    //getTraveled(location);
    getAssetDeprication();
    getNewValue();
  }

  Future<double> getTraveled(Location other) async {
    Future <double> traveled = Geolocator()
        .distanceBetween(latitude, longitude, other.latitude, other.longitude);
    double d = traveled as double;
    setDistance(d);
  }

  void setMileage(double m) {
    mileage = m;
  }

  void setDistance(double d) {
    distance = d;
  }

  void setAssetValue(double v) {
    assetValue = v;
  }

  void getNewValue() {
    newAssetValue = assetValue - assetDepreciation;

  }
  void getAssetDeprication() {
    assetDepreciation = mileage * distance;
  }
}