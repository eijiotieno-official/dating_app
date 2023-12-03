import 'package:dating_app/common/models/user_model.dart';
import 'package:dating_app/common/providers/user_provider.dart';
import 'package:dating_app/common/utils/interests_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectInterestsWidget extends StatelessWidget {
  const SelectInterestsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, value, child) {
        UserModel user = value.currentUserModel!;
        List<dynamic> selectedInterests =
            user.interests == null ? [] : user.interests!;
        return ListTile(
          dense: true,
          title: const Padding(
            padding: EdgeInsets.only(
              left: 8.0,
              bottom: 4,
            ),
            child: Text("What interests you?"),
          ),
          subtitle: Wrap(
            children: List.generate(
              interests.length,
              (index) => GestureDetector(
                onTap: () {
                  bool contains = selectedInterests
                      .any((element) => element == interests[index]);
                  if (contains) {
                    selectedInterests.remove(interests[index]);
                    value.updateCurrentUserData(
                      user: UserModel(
                        id: user.id,
                        name: user.name,
                        photos: user.photos,
                        email: user.email,
                        about: user.about,
                        geoPoint: user.geoPoint,
                        birth: user.birth,
                        interests: selectedInterests,
                        gender: user.gender,
                      ),
                    );
                  } else {
                    selectedInterests.add(interests[index]);
                    value.updateCurrentUserData(
                      user: UserModel(
                        id: user.id,
                        name: user.name,
                        photos: user.photos,
                        email: user.email,
                        about: user.about,
                        geoPoint: user.geoPoint,
                        birth: user.birth,
                        interests: selectedInterests,
                        gender: user.gender,
                      ),
                    );
                  }
                },
                child: Card(
                  color: selectedInterests.contains(interests[index])
                      ? Theme.of(context).colorScheme.primary
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: Text(
                      interests[index],
                      style: TextStyle(
                        color: selectedInterests.contains(interests[index])
                            ? Colors.white
                            : null,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
