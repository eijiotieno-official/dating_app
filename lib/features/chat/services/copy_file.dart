import 'dart:io';

import 'package:dating_app/features/chat/services/app_storage_directory.dart';
import 'package:path/path.dart' as p;

Future<File?> copyFile({
  required String? id,
  required String source,
}) async {
  Directory? directory = await appStorageDirectory;
  String extension = p.extension(source);
  String path = '';
  if (await directory!.exists()) {
    path = directory.path;
  } else {
    await directory.create(recursive: true);
    path = directory.path;
  }
  return await File(source).copy('$path/$id$extension');
}
