import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:teacherapp/Services/snackBar.dart';
import 'package:teacherapp/Utils/Colors.dart';
import 'package:url_launcher/url_launcher.dart';

String? capitalizeEachWord(String? input) {
  if (input == null || input.isEmpty) return input;

  return input
      .split(' ')
      .map((word) => word.isNotEmpty
          ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
          : '')
      .join(' ');
}

String convertDateFormat(String? inputDate) {
  if (inputDate == null) {
    return "--";
  }
  try {
    // Parse the input date string to DateTime
    DateTime dateTime = DateTime.parse(inputDate);

    // Format the DateTime to the desired format
    String formattedDate = DateFormat('MM/dd/yy').format(dateTime);

    return formattedDate;
  } catch (e) {
    return "--";
  }
}

String convertTimeFormat(String? inputDate) {
  if (inputDate == null) {
    return "--";
  }
  try {
    // Parse the input date string to DateTime
    DateTime dateTime = DateTime.parse(inputDate);

    // Format the DateTime to the desired format
    // String formattedTime = DateFormat('hh:mma').format(dateTime).toUpperCase();
    String formattedTime = DateFormat('HH:mm').format(dateTime).toUpperCase();

    return formattedTime;
  } catch (e) {
    return "--";
  }
}

openUrl({required String message, required BuildContext context}) async {
  try {
    if (!message.startsWith('http://') && !message.startsWith('https://')) {
      message = 'https://$message'; // Prepend https:// if missing
    }
    await launchUrl(Uri.parse(message));
  } catch (e) {
    snackBar(
        context: context,
        message: 'Could not launch $message',
        color: Colorutils.black);
  }
}

hSpace(double size) {
  return SizedBox(
    height: size,
  );
}

wSpace(double size) {
  return SizedBox(
    width: size,
  );
}

String chatRoomDateAndTimeFormat(String? dateTimeString) {
  if (dateTimeString == null) {
    return "";
  }

  try {
    DateTime dateTime = DateTime.parse(dateTimeString);
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = today.subtract(Duration(days: 1));
    DateTime startOfWeek = today.subtract(
        Duration(days: today.weekday - 1)); // Start of the current week

    // DateFormat timeFormat = DateFormat('h:mm a'); // e.g., 3:41 PM
    // DateFormat dayFormat = DateFormat('EEE h:mm a'); // e.g., Wed 3:41 PM
    DateFormat timeFormat = DateFormat('HH:mm'); // e.g., 18:20
    DateFormat dayFormat = DateFormat('EEE HH:mm'); // e.g., Wed 18:20
    DateFormat dateFormat =
        DateFormat('MM/dd/yyyy'); // e.g., 10/10/2024 10:50 PM

    if (dateTime.isAfter(today)) {
      return '${timeFormat.format(dateTime)}';
    } else if (dateTime.isAfter(yesterday)) {
      return 'Yesterday ${timeFormat.format(dateTime)}';
    } else if (dateTime.isAfter(startOfWeek)) {
      return dayFormat.format(dateTime);
    } else {
      return dateFormat.format(dateTime);
    }
  } catch (e) {
    return "";
  }
}
