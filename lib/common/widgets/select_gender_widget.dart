import 'package:dating_app/common/enum/gender_enum.dart';
import 'package:dating_app/common/models/user_model.dart';
import 'package:dating_app/common/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectGenderWidget extends StatelessWidget {
  final Gender? selectedGender;
  const SelectGenderWidget({
    super.key,
    required this.selectedGender,
  });

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    UserModel user = userProvider.currentUserModel!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        child: Column(
          children: [
            RadioListTile(
              contentPadding: const EdgeInsets.all(0),
              value: selectedGender,
              groupValue: Gender.man,
              onChanged: (value) {
                userProvider.updateCurrentUserData(
                  user: UserModel(
                    id: user.id,
                    name: user.name,
                    photos: user.photos,
                    email: user.email,
                    about: user.about,
                    geoPoint: user.geoPoint,
                    birth: user.birth,
                    interests: user.interests,
                    gender: Gender.man,
                  ),
                );
              },
              title: const Text("Man"),
            ),
            RadioListTile(
              contentPadding: const EdgeInsets.all(0),
              value: selectedGender,
              groupValue: Gender.woman,
              onChanged: (value) {
                userProvider.updateCurrentUserData(
                  user: UserModel(
                    id: user.id,
                    name: user.name,
                    photos: user.photos,
                    email: user.email,
                    about: user.about,
                    geoPoint: user.geoPoint,
                    birth: user.birth,
                    interests: user.interests,
                    gender: Gender.woman,
                  ),
                );
              },
              title: const Text("Woman"),
            ),
          ],
        ),
      ),
    );
  }
}
