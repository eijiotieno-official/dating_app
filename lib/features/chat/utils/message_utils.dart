import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageUtils {
  static String formatMessageTime({
    required DateTime dateTime,
    required BuildContext context,
  }) {
    bool is24HoursFormat = MediaQuery.of(context).alwaysUse24HourFormat;

    String formattedTime = is24HoursFormat
        ? DateFormat.Hm().format(dateTime)
        : DateFormat('h:mm a').format(dateTime);

    return formattedTime;
  }

  static String formatDay({required DateTime dateTime}) {
    DateTime now = DateTime.now();

    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return "Today";
    } else if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day - 1) {
      return "Yesterday";
    } else {
      return DateFormat('d MMM y').format(dateTime);
    }
  }
}
