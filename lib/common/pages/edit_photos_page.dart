import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating_app/common/models/user_model.dart';
import 'package:dating_app/common/providers/user_provider.dart';
import 'package:dating_app/common/services/crop_image.dart';
import 'package:dating_app/common/services/firebase_services.dart';
import 'package:dating_app/common/utils/firebase_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

enum PhotoType { url, file }

class EditPhotosPage extends StatefulWidget {
  final List<dynamic>? urls;
  const EditPhotosPage({super.key, required this.urls});

  @override
  State<EditPhotosPage> createState() => _EditPhotosPageState();
}

class _EditPhotosPageState extends State<EditPhotosPage> {
  List<Photo> photos = [];
  @override
  void initState() {
    if (widget.urls != null) {
      for (var element in widget.urls!) {
        setState(() {
          photos.add(Photo(path: element, photoType: PhotoType.url));
        });
      }
    }
    super.initState();
  }

  int page = 0;

  PageController pageController = PageController();

  bool uploading = false;
  List<String> urls = [];
  Future<void> updatePhotos() async {
    for (var photo in photos) {
      if (photo.photoType == PhotoType.file) {
        await FirebaseServices.uploadFile(file: File(photo.path)).then(
          (url) {
            if (url != null) {
              setState(() {
                urls.add(url);
              });
            }
          },
        );
      } else if (photo.photoType == PhotoType.url) {
        setState(() {
          urls.add(photo.path);
        });
      }
    }
  }

  back() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Dismiss Changes"),
          content: const Text("Are you sure?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Get.back();
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (pop) {
        if (photos.any((element) => element.photoType == PhotoType.file) &&
            uploading == false) {
          back();
        } else {
          Get.back();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                if (photos.any(
                        (element) => element.photoType == PhotoType.file) &&
                    uploading == false) {
                  back();
                } else {
                  Get.back();
                }
              },
              icon: const Icon(Icons.arrow_back)),
          title: uploading
              ? const Text("Uploading...")
              : Text(photos.isEmpty
                  ? "Pick a photo"
                  : "Edit Photos ${page + 1} of ${photos.length}"),
          actions: uploading
              ? null
              : [
                  if (photos.isNotEmpty)
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Remove Photo"),
                              content: const Text("Are you sure?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    setState(() {});
                                  },
                                  child: const Text("No"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    photos
                                        .removeAt(pageController.page!.toInt());
                                    Navigator.pop(context);
                                    setState(() {});
                                  },
                                  child: const Text("Yes"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.delete,
                      ),
                    ),
                  if (photos.isNotEmpty)
                    IconButton(
                      onPressed: () async {
                        ImagePicker imagePicker = ImagePicker();
                        await imagePicker
                            .pickImage(source: ImageSource.gallery)
                            .then(
                          (value) async {
                            if (value != null) {
                              await cropImage(
                                file: File(value.path),
                                cropStyle: CropStyle.rectangle,
                                cropAspectRatioPreset:
                                    CropAspectRatioPreset.original,
                              ).then(
                                (crop) {
                                  if (crop != null) {
                                    setState(() {
                                      photos.add(
                                        Photo(
                                          path: crop.path,
                                          photoType: PhotoType.file,
                                        ),
                                      );
                                    });
                                    pageController
                                        .jumpToPage(photos.length - 1);
                                  }
                                },
                              );
                            }
                          },
                        );
                      },
                      icon: const Icon(Icons.add_a_photo),
                    ),
                ],
        ),
        body: uploading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : photos.isEmpty
                ? Center(
                    child: IconButton(
                      onPressed: () async {
                        ImagePicker imagePicker = ImagePicker();
                        await imagePicker
                            .pickImage(source: ImageSource.gallery)
                            .then(
                          (value) async {
                            if (value != null) {
                              await cropImage(
                                file: File(value.path),
                                cropStyle: CropStyle.rectangle,
                                cropAspectRatioPreset:
                                    CropAspectRatioPreset.original,
                              ).then(
                                (crop) {
                                  if (crop != null) {
                                    setState(() {
                                      photos.add(
                                        Photo(
                                          path: crop.path,
                                          photoType: PhotoType.file,
                                        ),
                                      );
                                    });
                                    if (photos.length >= 2) {
                                      setState(() {});
                                      pageController
                                          .jumpToPage(photos.length - 1);
                                    }
                                  }
                                },
                              );
                            }
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.add_a_photo,
                        size: 50,
                      ),
                    ),
                  )
                : PageView.builder(
                    physics: const BouncingScrollPhysics(),
                    controller: pageController,
                    itemCount: photos.length,
                    onPageChanged: (v) => setState(() {
                      page = v;
                    }),
                    itemBuilder: (context, index) {
                      return photos[index].photoType == PhotoType.url
                          ? CachedNetworkImage(imageUrl: photos[index].path)
                          : Image.file(File(photos[index].path));
                    },
                  ),
        floatingActionButton: AnimatedOpacity(
          opacity:
              photos.any((element) => element.photoType == PhotoType.file) &&
                      uploading == false
                  ? 1.0
                  : 0.0,
          duration: const Duration(milliseconds: 500),
          child: FloatingActionButton(
            onPressed: () async {
              setState(() {
                uploading = true;
              });
              await updatePhotos().then(
                (_) async {
                  await FirebaseUtils.usersCollection
                      .doc(FirebaseUtils.currentUserId)
                      .update(
                    {
                      'photos': urls,
                    },
                  ).then(
                    (_) {
                      UserProvider userProvider =
                          Provider.of<UserProvider>(context, listen: false);
                      UserModel? user = userProvider.currentUserModel;
                      if (user != null) {
                        userProvider.updateCurrentUserData(
                          user: UserModel(
                            id: user.id,
                            name: user.name,
                            photos: urls,
                            email: user.email,
                            about: user.about,
                            geoPoint: user.geoPoint,
                            birth: user.birth,
                            interests: user.interests,
                            gender: user.gender,
                          ),
                        );
                        Get.back();
                      }
                    },
                  );
                },
              );
            },
            child: const Icon(Icons.check),
          ),
        ),
      ),
    );
  }
}

class Photo {
  String path;
  PhotoType photoType;

  Photo({required this.path, required this.photoType});
}
