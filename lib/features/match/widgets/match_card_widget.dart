import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/common/models/user_model.dart';
import 'package:dating_app/common/services/location_services.dart';
import 'package:dating_app/features/match/services/match_by_age_range.dart';

import 'package:flutter/material.dart';

class MatchCardWidget extends StatelessWidget {
  final UserModel userModel;
  const MatchCardWidget({
    super.key,
    required this.userModel,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Card(
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withOpacity(0.5),
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ListTile(
                  title: Text(
                      "${userModel.name}, ${yearOld(dateTime: userModel.birth!)}"),
                  subtitle: FutureBuilder<GeoPoint>(
                    future: LocationServices.getGeoPoint(),
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        return Text(
                            "${LocationServices.distanceBetween(startPoint: userModel.geoPoint, endPoint: userModel.geoPoint).toInt()}m away");
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ), 
            ),
          ],
        ),
      ),
    );
  }
}
