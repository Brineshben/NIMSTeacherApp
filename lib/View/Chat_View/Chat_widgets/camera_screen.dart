import 'dart:developer';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:teacherapp/Controller/api_controllers/feedViewController.dart';
import 'package:teacherapp/Controller/api_controllers/parentChatController.dart';
import '../../../Services/dialog_box.dart';
import '../../../Services/snackBar.dart';
import '../../../Utils/Colors.dart';

List<CameraDescription> cameras = [];

class CameraScreen extends StatefulWidget {
  final bool isParentChat;
  const CameraScreen({
    super.key,
    required this.isParentChat,
  });

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController controller;
  bool isControllerInitialized = false;
  bool flash = false;
  bool frontCamera = false;
  String imagePath = "";

  @override
  void initState() {
    super.initState();
    initializeCamera(frontCamera);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future initializeCamera(frontCamera) async {
    try {
      cameras = await availableCameras();
    } on CameraException catch (e) {
      log(e.code, error: e.description);
    }
    if (cameras.isNotEmpty) {
      controller = CameraController(
          frontCamera ? cameras[1] : cameras[0], ResolutionPreset.max, enableAudio: false);
      try {
        await controller.initialize();
      } on CameraException catch (e) {
        if (e.code == "CameraAccessDenied") {
          await ShowWarnDialog().showWarn(
            context: context,
            message: 'Enable camera access.',
            iconData: Icons.camera_alt,
            isCameraPage: true,
          );
        } else if (e.code == "AudioAccessDenied") {
          await ShowWarnDialog().showWarn(
            context: context,
            message: 'Audio access denied.',
            iconData: Icons.mic,
            isCameraPage: true,
          );
        }
        print("------CameraException--------${e.toString()}");
      } catch (e) {
        print("------initializeCamera--------${e.toString()}");
      }
      isControllerInitialized = true;
      controller.setFlashMode(FlashMode.off);
      setState(() {});
    } else {
      snackBar(
          context: context,
          message: "Camera not available.",
          color: Colors.red);
      // Handle the case where no cameras are available.
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: imagePath != ""
            ? Stack(
          children: [
            SizedBox(
              height: ScreenUtil().screenHeight,
              width: double.infinity,
              child: Center(
                child: Image.file(
                  File(imagePath),
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.only(bottom: 20, left: 20, right: 20),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() => imagePath = "");
                      },
                      icon: const Icon(
                        Icons.cancel,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        widget.isParentChat
                            ? Get.find<ParentChattingController>().filePath.value = imagePath
                            : Get.find<FeedViewController>().filePath.value = imagePath;
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.done,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
            : Stack(
          children: [
            SizedBox(
              height: ScreenUtil().screenHeight,
              width: double.infinity,
              child: Center(
                child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    // height: MediaQuery.of(context).size.height,
                    child: isControllerInitialized
                        ? CameraPreview(controller)
                        : null),
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.only(bottom: 20, left: 20, right: 20),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    !frontCamera
                        ? IconButton(
                      onPressed: () {
                        setState(() {
                          flash = !flash;
                        });
                        flash
                            ? controller
                            .setFlashMode(FlashMode.torch)
                            : controller
                            .setFlashMode(FlashMode.off);
                      },
                      icon: Icon(
                        flash ? Icons.flash_on : Icons.flash_off,
                        color: Colors.white,
                      ),
                    )
                        : const SizedBox(
                      width: 50,
                      height: 10,
                    ),
                    CircleAvatar(
                      backgroundColor: Colorutils.bgcolor10,
                      child: IconButton(
                        onPressed: () async {
                          XFile? photo = await controller.takePicture();
                          setState(() => imagePath = photo.path);
                        },
                        icon: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        setState(() => frontCamera = !frontCamera);
                        // await controller.dispose();
                        await initializeCamera(frontCamera);
                      },
                      icon: const Icon(
                        Icons.cameraswitch,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}