import 'package:dating_app/common/enum/gender_enum.dart';
import 'package:dating_app/common/models/user_model.dart';
import 'package:dating_app/common/pages/edit_photos_page.dart';
import 'package:dating_app/common/providers/user_provider.dart';
import 'package:dating_app/common/utils/firebase_utils.dart';
import 'package:dating_app/common/widgets/select_gender_widget.dart';
import 'package:dating_app/common/widgets/select_interests_widget.dart';
import 'package:dating_app/common/widgets/user_photos_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';

class ProfilePage extends StatefulWidget {
  final UserModel user;
  const ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController aboutController = TextEditingController();

  bool updating = false;
  Future<bool> updateProfile() async {
    bool updated = false;
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    UserModel user = userProvider.currentUserModel!;
    await FirebaseUtils.usersCollection.doc(FirebaseUtils.currentUserId).update(
      {
        "name": user.name,
        "about": user.about,
        "birth": user.birth,
        "gender": enumStringGender(gender: user.gender!),
        "interests": user.interests,
      },
    ).then(
      (_) {
        updated = true;
      },
    );

    return updated;
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(milliseconds: 700),
      () {
        UserProvider userProvider =
            Provider.of<UserProvider>(context, listen: false);
        setState(() {
          nameController =
              TextEditingController(text: userProvider.currentUserModel!.name);

          aboutController =
              TextEditingController(text: userProvider.currentUserModel!.about);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.user.id == FirebaseUtils.currentUserId
        ? buildCurrentUserWidget()
        : buildUserWidget();
  }

  Widget buildCurrentUserWidget() => Consumer<UserProvider>(
        builder: (context, value, child) {
          UserModel? user = value.currentUserModel;
          return user == null
              ? const SizedBox.shrink()
              : Scaffold(
                  appBar: AppBar(title: const Text("Profile")),
                  body: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: Stack(
                            children: [
                              UserPhotosWidget(
                                photos: user.photos,
                              ),
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      right: 20,
                                      bottom: 10,
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        Get.to(
                                          () =>
                                              EditPhotosPage(urls: user.photos),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.add_a_photo,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Card(
                            child: Column(
                              children: [
                                ListTile(
                                  minVerticalPadding: 0,
                                  title: TextField(
                                    controller: nameController,
                                    maxLength: 30,
                                    decoration: const InputDecoration(
                                      labelText: "Name",
                                      border: InputBorder.none,
                                      counter: SizedBox.shrink(),
                                    ),
                                    onChanged: (text) {
                                      value.updateCurrentUserData(
                                        user: UserModel(
                                          id: user.id,
                                          name: text,
                                          photos: user.photos,
                                          email: user.email,
                                          about: user.about,
                                          geoPoint: user.geoPoint,
                                          birth: user.birth,
                                          interests: user.interests,
                                          gender: user.gender,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                ListTile(
                                  minVerticalPadding: 0,
                                  title: TextField(
                                    controller: aboutController,
                                    maxLines: null,
                                    decoration: const InputDecoration(
                                      labelText: "About me",
                                      border: InputBorder.none,
                                    ),
                                    onChanged: (text) {
                                      setState(() {});
                                      value.updateCurrentUserData(
                                        user: UserModel(
                                          id: user.id,
                                          name: user.name,
                                          photos: user.photos,
                                          email: user.email,
                                          about: text,
                                          geoPoint: user.geoPoint,
                                          birth: user.birth,
                                          interests: user.interests,
                                          gender: user.gender,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SelectGenderWidget(selectedGender: user.gender),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Card(
                            child: ListTile(
                              dense: true,
                              contentPadding: const EdgeInsets.all(0),
                              title: const Padding(
                                padding: EdgeInsets.only(left: 12),
                                child: Text("Date of Birth"),
                              ),
                              subtitle: CalendarDatePicker(
                                initialDate: user.birth == null
                                    ? DateTime.now()
                                        .subtract(const Duration(days: 6570))
                                    : user.birth!,
                                firstDate: DateTime.now().subtract(
                                    const Duration(days: 15000000000)),
                                lastDate: DateTime.now()
                                    .subtract(const Duration(days: 6570)),
                                onDateChanged: (date) {
                                  value.updateCurrentUserData(
                                    user: UserModel(
                                      id: user.id,
                                      name: user.name,
                                      photos: user.photos,
                                      email: user.email,
                                      about: user.about,
                                      geoPoint: user.geoPoint,
                                      birth: date,
                                      interests: user.interests,
                                      gender: user.gender,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        const SelectInterestsWidget(),
                      ],
                    ),
                  ),
                  floatingActionButton: AnimatedOpacity(
                    opacity: user.name == null ||
                            user.about == null ||
                            user.photos == null ||
                            user.photos!.isEmpty ||
                            user.interests == null ||
                            user.interests!.isEmpty ||
                            user.birth == null ||
                            user.gender == null
                        ? 0.0
                        : 1.0,
                    duration: const Duration(milliseconds: 700),
                    child: FloatingActionButton(
                      onPressed: () async {
                        if (updating == false) {
                          setState(() {
                            updating = true;
                          });
                          await updateProfile().then(
                            (updated) {
                              if (updated) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return const HomePage(
                                          receivedAction: null);
                                    },
                                  ),
                                );
                              } else {
                                setState(() {
                                  updating = false;
                                });
                              }
                            },
                          );
                        }
                      },
                      child: updating
                          ? const CircularProgressIndicator()
                          : const Icon(Icons.check),
                    ),
                  ),
                );
        },
      );

  Widget buildUserWidget() => Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: UserPhotosWidget(
                photos: widget.user.photos!,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AppBar(title: Text(widget.user.name!)),
              ],
            )
          ],
        ),
      );
}
