import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatMessageTime({
  required DateTime dateTime,
  required BuildContext context,
}) {
  bool is24HoursFormat = MediaQuery.of(context).alwaysUse24HourFormat;

  String formattedTime = is24HoursFormat
      ? DateFormat.Hm().format(dateTime)
      : DateFormat('h:mm a').format(dateTime);

  return formattedTime;
}
