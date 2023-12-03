import 'package:dating_app/common/enum/gender_enum.dart';

class PreferenceModel {
  final int maxAge;
  final int minAge;
  final Gender gender;
  final List<String> interests;
  final double distance;
  PreferenceModel({
    required this.maxAge,
    required this.minAge,
    required this.gender,
    required this.interests,
    required this.distance,
  });
}
