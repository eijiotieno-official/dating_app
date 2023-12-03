import 'package:dating_app/common/utils/firebase_utils.dart';
import 'package:dating_app/features/chat/enums/message_status_enum.dart';
import 'package:dating_app/features/chat/models/message_model.dart';
import 'package:dating_app/features/chat/services/send_message_service.dart';

class LikeBack {
  static Future<void> execute({required String user}) async {
    await SendMessageService.execute(
      messageModel: MessageModel(
        id: "id",
        sender: FirebaseUtils.currentUserId!,
        receiver: user,
        text: "I like you too",
        photo: null,
        time: DateTime.now(),
        status: MessageStatus.waiting,
        extension: '',
      ),
    );
  }
}
