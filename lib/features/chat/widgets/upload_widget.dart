import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/common/utils/firebase_utils.dart';
import 'package:dating_app/features/chat/enums/message_status_enum.dart';
import 'package:dating_app/features/chat/models/message_model.dart';
import 'package:dating_app/features/chat/services/fetch_file.dart';
import 'package:dating_app/features/chat/services/file_exists.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

class UploadWidget extends StatefulWidget {
  final MessageModel message;
  const UploadWidget({super.key, required this.message});

  @override
  State<UploadWidget> createState() => _UploadWidgetState();
}

class _UploadWidgetState extends State<UploadWidget> {
  UploadTask? uploadTask;
  double uploadProgress = 0.0;
  Future uploadFile() async {
    MessageModel message = widget.message;
    bool exists = await existsFile(
      name: "${message.id}${message.extension}",
    );
    if (exists) {
      File? waitingFile = await fetchFile(
        extension: widget.message.extension!,
        id: message.id,
        url: message.photo!,
      );

      String fileName = path.basename(waitingFile!.path);
      Reference storageRef = FirebaseStorage.instance.ref();
      Reference fileRef = storageRef.child("files/$fileName");
      setState(() {
        uploadTask = fileRef.putFile(waitingFile);
      });

      uploadTask!.snapshotEvents.listen(
        (TaskSnapshot taskSnapshot) async {
          if (taskSnapshot.state == TaskState.running) {
            setState(() {
              uploadProgress =
                  (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
            });
          }

          if (taskSnapshot.state == TaskState.error) {
            setState(() {
              uploadProgress = 0.0;
              uploadTask = null;
            });
          }

          if (taskSnapshot.state == TaskState.success) {
            String url = await taskSnapshot.ref.getDownloadURL();
            await FirebaseFirestore.instance
                .collection("persons")
                .doc(message.sender)
                .collection("chats")
                .doc(message.receiver)
                .collection("messages")
                .doc(message.id)
                .update(
              {
                'photo': url,
                'status':
                    enumStringMessageStatus(messageStatus: MessageStatus.sent),
              },
            );
          }
        },
      );
    } else {
      FirebaseUtils.usersCollection
          .doc(FirebaseUtils.currentUserId)
          .collection("chats")
          .doc(message.receiver)
          .collection("messages")
          .doc(message.id)
          .delete();
      FirebaseUtils.usersCollection
          .doc(message.receiver)
          .collection("chats")
          .doc(FirebaseUtils.currentUserId)
          .collection("messages")
          .doc(message.id)
          .delete();
    }
  }

  @override
  void initState() {
    uploadFile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: () {
            if (uploadTask != null &&
                uploadTask?.snapshot.state == TaskState.running) {
              uploadTask!.cancel();
              FirebaseUtils.usersCollection
                  .doc(FirebaseUtils.currentUserId)
                  .collection("chats")
                  .doc(widget.message.receiver)
                  .collection("messages")
                  .doc(widget.message.id)
                  .delete();
              FirebaseUtils.usersCollection
                  .doc(widget.message.receiver)
                  .collection("chats")
                  .doc(FirebaseUtils.currentUserId)
                  .collection("messages")
                  .doc(widget.message.id)
                  .delete();
            } else if (widget.message.status == MessageStatus.waiting) {
              uploadFile();
            }
          },
          child: SizedBox(
            height: 50,
            width: 50,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        uploadTask?.snapshot.state == TaskState.running
                            ? Icons.cancel
                            : Icons.upload_rounded,
                        color: Colors.white,
                      ),
                    ),
                    Center(
                      child: CircularProgressIndicator(
                        value: uploadProgress,
                        strokeWidth: 3,
                        strokeCap: StrokeCap.round,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                        backgroundColor: Colors.black45,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
