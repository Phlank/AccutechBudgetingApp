import 'package:budgetflow/model/asset_valuation.dart';
import 'package:flutter_test/flutter_test.dart';

AssetValuation _assetValuation = new AssetValuation();
void main(){
  group("arithemetic functionality", (){
    setUp((){
      _assetValuation.setDistance(5.0);
      _assetValuation.setMileage(1.7);
      _assetValuation.setAssetValue(50000);
      _assetValuation.getAssetDeprication();
      _assetValuation.getNewValue();
    });
    group("mileage tests", (){
      test("mileage presence test",(){
        expect(_assetValuation.mileage, isNotNull);
      });
      test("mileage testing",(){
        expect(_assetValuation.mileage, 1.7);
      });
    });
    group("Distance tests", () {
      test("distance presence testing", () {
        expect(_assetValuation.distance, isNotNull);
      });
      test("distance testing", () {
        expect(_assetValuation.distance, 5.0);
      });
    });
    group("Depreciation tests", () {
      test("depreciation presence testing", () {
        expect(_assetValuation.assetDepreciation, isNotNull);
      });
      test("depreciation testing", () {
        expect(_assetValuation.assetDepreciation, 8.5);
      });
    });
    group("Asset Value tests", () {
      test("assetValue  testing", () {
        expect(_assetValuation.assetValue, isNotNull);
      });
      test("assetValue testing", () {
        expect(_assetValuation.assetValue, 50000);
      });
    });
    group("New Asset value tests", ()
    {
      test("New Asset Value presence testing", () {
        expect(_assetValuation.newAssetValue, isNotNull);
      });
      test("New Asset Value presence testing", () {
        expect(_assetValuation.newAssetValue, 49991.5);
      });
    });
  });
}