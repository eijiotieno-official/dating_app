import 'package:dating_app/common/models/user_model.dart';

int yearOld({required DateTime dateTime}) {
  DateTime today = DateTime.now();
  return today.difference(dateTime).inDays ~/ 365;
}

bool matchByAgeRange({
  required UserModel user,
  required int max,
  required int min,
}) =>
    yearOld(dateTime: user.birth!) <= max &&
    min >= yearOld(dateTime: user.birth!);
