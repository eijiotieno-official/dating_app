import 'dart:io';

import 'package:dating_app/features/chat/services/app_storage_directory.dart';

Future<bool> existsFile({required String name}) async {
  Directory? directory = await appStorageDirectory;
  String path = '';
  if (await directory!.exists()) {
    path = directory.path;
  } else {
    await directory.create(recursive: true);
    path = directory.path;
  }
  File file = File("$path/$name");
  return file.existsSync();
}
