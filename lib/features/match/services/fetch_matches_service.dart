import 'package:dating_app/common/models/user_model.dart';
import 'package:dating_app/common/services/firebase_services.dart';
import 'package:dating_app/common/utils/firebase_utils.dart';
import 'package:dating_app/features/match/models/preference_model.dart';
import 'package:dating_app/features/match/providers/match_provider.dart';
import 'package:dating_app/features/match/services/match_by_age_range.dart';
import 'package:dating_app/features/match/services/match_by_interests.dart';
import 'package:dating_app/features/match/services/match_by_location.dart';

import 'match_by_gender.dart';

class FetchMatchesService {
  static execute({required MatchProvider matchProvider}) async {
    List<UserModel> allUsers = await FirebaseServices.readAllUsers();
    PreferenceModel preference = matchProvider.preference;
    matchProvider.clearMatches();
    for (var user in allUsers) {
      bool alreadyMatched =
          matchProvider.matches.any((element) => element.id == user.id);
      if (alreadyMatched == false) {
        bool matchGender = user.gender == null
            ? false
            : matchByGender(user: user, gender: preference.gender);
        bool matchAgeRange = user.birth == null
            ? false
            : matchByAgeRange(
                user: user,
                max: preference.maxAge,
                min: preference.minAge,
              );

        bool matchInterests = user.interests == null
            ? false
            : matchByInterests(user: user, interests: preference.interests);

        bool matchLocation =
            await matchByLocation(user: user, distance: preference.distance);

        bool already =
            matchProvider.likes.any((element) => element.id == user.id);

        if (!already ) {
          if (matchGender) {
            if (matchLocation || matchInterests || matchAgeRange) {
              matchProvider.addMatch(userModel: user);
            }
          }
        }
      }
    }
  }
}
