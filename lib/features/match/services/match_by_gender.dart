import 'package:dating_app/common/enum/gender_enum.dart';
import 'package:dating_app/common/models/user_model.dart';

bool matchByGender({
  required UserModel user,
  required Gender gender,
}) =>
    gender == user.gender;
