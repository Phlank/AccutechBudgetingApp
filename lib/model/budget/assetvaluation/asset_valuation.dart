import 'package:budgetflow/model/budget/location/location.dart';
import 'package:geolocator/geolocator.dart';

class AssetValuation{

  double assetValue;
  double newAssetValue;
  double mileage;
  double assetDepreciation;
  double distance;
  Location location;
  double latitude;
  double longitude;

  AssetValuation(){
    getTraveled(location);
    getAssetDeprication();
    setNewValue();
}

  Future<double> getTraveled(Location other) async{
    Future <double> traveled = Geolocator()
        .distanceBetween(latitude, longitude, other.latitude, other.longitude);
    distance = traveled as double;
  }

  void getAssetDeprication(){
    assetDepreciation = mileage * distance;
  }

  void setNewValue(){
    newAssetValue = assetValue - assetDepreciation;
  }

}