enum MessageStatus { waiting, sent, delivered, read }

MessageStatus enumMessageStatus({required String string}) =>
    MessageStatus.values
        .firstWhere((e) => e.toString().split('.').last == string);

String enumStringMessageStatus({required MessageStatus messageStatus}) =>
    messageStatus
        .toString()
        .substring(messageStatus.toString().indexOf('.') + 1);
