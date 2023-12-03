import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/common/models/user_model.dart';
import 'package:dating_app/common/services/location_services.dart';

Future<bool> matchByLocation({
  required UserModel user,
  required double distance,
}) async {
  GeoPoint? startPoint = await LocationServices.getGeoPoint();

  double distanceBetween = LocationServices.distanceBetween(
      startPoint: startPoint, endPoint: user.geoPoint);

  return distanceBetween <= distance;
}
