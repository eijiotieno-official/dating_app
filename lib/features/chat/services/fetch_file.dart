import 'dart:io';

import 'package:dating_app/features/chat/services/file_exists.dart';

import 'app_storage_directory.dart';

Future<File?> fetchFile({
  required String id,
  required String url,
  required String extension,
}) async {
  File? file;
  bool idExists = await existsFile(name: "$id$extension");
  bool urlExists = await existsFile(name: "$url$extension");
  Directory? directory = await appStorageDirectory;
  String path = directory!.path;
  if (idExists) {
    file = File("$path/$id$extension");
  }
  if (urlExists) {
    file = File("$path/$url$extension");
  }
  return file;
}
