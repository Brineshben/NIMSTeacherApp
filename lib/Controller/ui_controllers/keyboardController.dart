
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KeyboardController extends GetxController {
  Rx<FocusNode> summaryFocusNode = FocusNode().obs;
  Rx<FocusNode> whatWentWellFocusNode = FocusNode().obs;
  Rx<FocusNode> evenBetterIfFocusNode = FocusNode().obs;

  void manageFocusNode() {}
}