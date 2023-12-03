import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationServices {
  static Future grantPermission() async {
    await Permission.location.status.isGranted.then(
      (granted) async {
        if (granted == false) {
          PermissionStatus permissionStatus =
              await Permission.location.request();
          if (permissionStatus == PermissionStatus.permanentlyDenied) {
            Fluttertoast.showToast(msg: "Allow location permission");
            await openAppSettings();
          }
        }
      },
    );
  }

  static Future<Position> getPosition() async =>
      await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium);

  static Future<GeoPoint> getGeoPoint() async {
    Position currentPosition = await getPosition();
    return GeoPoint(currentPosition.latitude, currentPosition.longitude);
  }

  static Future<List<Placemark>> decodePostion(
          {required Position position}) async =>
      await placemarkFromCoordinates(position.latitude, position.longitude);

  static double distanceBetween({
    required GeoPoint startPoint,
    required GeoPoint endPoint,
  }) =>
      Geolocator.distanceBetween(
        startPoint.latitude,
        startPoint.longitude,
        endPoint.latitude,
        endPoint.longitude,
      );
}
