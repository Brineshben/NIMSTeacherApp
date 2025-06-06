// String? capitalizeEachWord(String? name) {
//   if (name == null || name.isEmpty) {
//     return "--";
//   }
//   return name
//       .split(' ') // Split the string into words
//       .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
//       .join(' '); // Join the words back with spaces
// }

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:teacherapp/Services/check_connectivity.dart';
import 'package:teacherapp/Services/snackBar.dart';

Future<void> checkInternet(
    {required BuildContext context,
    required Future Function() function}) async {
  bool connected = await CheckConnectivity().check();
  bool isConnectionGood = await CheckConnectivity().goodConnection();
  print("internect connection is $connected");
  print("internect Good connection is $isConnectionGood");
  if (connected) {
    if (isConnectionGood) {
      await function();
    } else {
      snackBar(
          context: context,
          message: "Something went wrong.",
          color: Colors.red);
    }
  } else {
    snackBar(
        context: context,
        message: "No Internet Connection.",
        color: Colors.red);
  }
}

Future<void> checkInternetWithOutSnacksbar(
    {required Future Function() function}) async {
  bool connected = await CheckConnectivity().check();
  bool isConnectionGood = await CheckConnectivity().goodConnection();
  print("internect connection is $connected");
  print("internect Good connection is $isConnectionGood");
  if (connected) {
    if (isConnectionGood) {
      await function();
    } else {
      print("Something went wrong.");
    }
  } else {
    print("No Internet Connection.");
  }
}

Future<bool> checkInternetWithReturnBool(
    {required BuildContext context,
    required Future Function() function}) async {
  bool connected = await CheckConnectivity().check();
  bool isConnectionGood = await CheckConnectivity().goodConnection();
  print("internect connection is $connected");
  print("internect Good connection is $isConnectionGood");
  if (connected) {
    if (isConnectionGood) {
      await function();
      return true;
    } else {
      snackBar(
          context: context,
          message: "Something went wrong.",
          color: Colors.red);
      return false;
    }
  } else {
    snackBar(
        context: context,
        message: "No Internet Connection.",
        color: Colors.red);
    return false;
  }
}

String messageBubbleTimeFormat(String? dateTime) {
  // Check if the input date-time string is null
  if (dateTime == null) {
    return "--";
  }
 
  // Parse the input date-time string
  DateTime parsedDateTime = DateTime.parse(dateTime);
 
  // Format the parsed DateTime to the desired time format
  // String formattedTime = DateFormat('h:mm a').format(parsedDateTime);
  String formattedTime = DateFormat('HH:mm').format(parsedDateTime);

  return formattedTime;
}

Duration parseDuration(String durationString) {
  final parts = durationString.split(':');
  if (parts.length != 3) {
    throw FormatException('Invalid duration format');
  }

  final hours = int.parse(parts[0]);
  final minutes = int.parse(parts[1]);
  final secondsAndMilliseconds = parts[2].split('.');
  final seconds = int.parse(secondsAndMilliseconds[0]);
  final milliseconds = secondsAndMilliseconds.length > 1
      ? int.parse(secondsAndMilliseconds[1].padRight(6, '0').substring(0, 3))
      : 0;

  return Duration(
    hours: hours,
    minutes: minutes,
    seconds: seconds,
    milliseconds: milliseconds,
  );
}

Future<String> getFormattedFileSize(String filePath) async {
  final file = File(filePath);

  if (await file.exists()) {
    int fileSizeInBytes = await file.length(); // Size in bytes

    // Convert and format the file size
    if (fileSizeInBytes < 1024 * 1024) {
      return '${(fileSizeInBytes / 1024).toStringAsFixed(0)} KB.'; // Less than 1 MB
    } else {
      return '${(fileSizeInBytes / (1024 * 1024)).toStringAsFixed(1)} MB.'; // 1 MB or more
    }
  } else {
    throw FileSystemException('File does not exist', filePath);
  }
}

Future<void> requestStoragePermission() async {
  var status = await Permission.storage.request();
  if (status.isGranted) {
    print("Storage permission granted.");
  } else if (status.isDenied) {
    print("Storage permission denied.");
  } else if (status.isPermanentlyDenied) {
    print(
        "Storage permission permanently denied. Please enable it from settings.");
  }
}
