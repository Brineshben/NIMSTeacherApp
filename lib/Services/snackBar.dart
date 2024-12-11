import 'package:flutter/material.dart';

import '../Utils/Colors.dart';

void showSnackBar(BuildContext context, String msg, Color clr) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg),
      backgroundColor: clr,
    ),
  );
}

snackBar(
    {required BuildContext context,
      required String message,
      required Color color}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontFamily: 'Montserrat-Regular',
          fontSize: 15,
        ),
        textAlign: TextAlign.center,
      ),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      elevation: 10,
      duration: const Duration(seconds: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      margin: const EdgeInsets.only(
        bottom: 50,
        right: 50,
        left: 50,
      ),
    ),
  );
}