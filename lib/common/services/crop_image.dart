import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

Future<File?> cropImage({
  required File file,
  required CropStyle cropStyle,
  required CropAspectRatioPreset cropAspectRatioPreset,
}) async {

  CroppedFile? croppedFile = await ImageCropper().cropImage(
    sourcePath: file.path,
    cropStyle: cropStyle,
    aspectRatioPresets: [
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio16x9
    ],
    uiSettings: [
      AndroidUiSettings(
        toolbarTitle: '',
        toolbarColor: Colors.black,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: cropAspectRatioPreset,
        lockAspectRatio: false,
        showCropGrid: false,
        hideBottomControls: true,
        statusBarColor: Colors.black,
      ),
    ],
  );
  return File(croppedFile!.path);
}
