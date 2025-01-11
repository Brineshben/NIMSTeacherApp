import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart' as directory;
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:crypto/crypto.dart';
import 'package:teacherapp/Controller/api_controllers/feedViewController.dart';
import 'package:teacherapp/Controller/api_controllers/parentChatController.dart';

import '../../../Utils/Colors.dart';

class ChatAudioRecordingWidget extends StatefulWidget {
  final bool isParentChat;
  const ChatAudioRecordingWidget({super.key, required this.isParentChat});

  @override
  State<ChatAudioRecordingWidget> createState() =>
      _ChatAudioRecordingWidgetState();
}

class _ChatAudioRecordingWidgetState extends State<ChatAudioRecordingWidget> {
  final recorder = AudioRecorder();
  bool isRecorderReady = false;
  DateTime? _startTime;
  String? duration;
  Timer? timer;

  @override
  void initState() {
    initRecorder();
    super.initState();
  }

  @override
  void dispose() {
    recorder.dispose();
    timer!.cancel();
    super.dispose();
  }

  Future initRecorder() async {
    // await Permission.microphone.request();
    if(await recorder.hasPermission()){
      await record();
      setState(() {});
    }else{
      // await recorder.
    }
  }

  String generateRandomFilename() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (i) => random.nextInt(256));
    final hash = sha1.convert(bytes);
    return hash.toString();
  }

  Future record() async {
    // final provider = Provider.of<ChatProvider>(context, listen: false);
    final appDir = await directory.getApplicationDocumentsDirectory();
    final randomFilename = generateRandomFilename();
    await recorder.start(
        const RecordConfig(encoder: AudioEncoder.wav, bitRate: 64000),
        path: '${appDir!.path}/$randomFilename.wav');
    setState(() => _startTime = DateTime.now());
    timer = Timer.periodic(
        const Duration(seconds: 1),
        (timer) => setState(() => duration = DateTime.now()
            .difference(_startTime!)
            .toString()
            .split(".")
            .first));
    // provider.setAudioPath(path: '${appDir.path}/$randomFilename.wav');
    widget.isParentChat ? Get.find<ParentChattingController>().audioPath.value =
    '${appDir.path}/$randomFilename.wav'
    : Get.find<FeedViewController>().audioPath.value =
        '${appDir.path}/$randomFilename.wav';
  }

  Future stop() async {
    // final provider = Provider.of<ChatProvider>(context, listen: false);
    // if (!isRecorderReady) return;
    await recorder.stop();
    // final newPath = File(path!).renameSync("$path.wav");
    // await saveAudioFile(newPath.path);
    // provider.setAudioPath(newPath.path);
    // print("---path---------$path");
  }

  // Future<void> saveAudioFile(String filePath) async {
  //   try {
  //     final appDir = await getExternalStorageDirectory();
  //     final newFile = await File(filePath).copy('${appDir!.path}/audio_bitrate60000.wav');
  //     print("------newFile-------$newFile");
  //     print('Audio file saved: ${newFile.path}');
  //   } catch (e) {
  //     print('Error saving audio file: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
            ),
            height: 40.w,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Lottie.asset(
                    "assets/animation/animation_lmrkm21r.json",
                    fit: BoxFit.cover,
                  ),
                  if (duration != null) Text("$duration"),
                  const Icon(
                    Icons.fiber_manual_record,
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 5),
        Container(
          height: 40.w,
          width: 40.w,
          decoration: const BoxDecoration(
            color: Colorutils.greenDark,
            shape: BoxShape.circle,
          ),
          child: InkWell(
            onTap: () async {
              if (await recorder.isRecording()) {
                await recorder.stop().then((value) {
                  // final provider = Provider.of<ChatProvider>(context, listen: false);
                  // provider.chatField(ChatField.textField);
                  if(widget.isParentChat) {
                    Get.find<ParentChattingController>().showAudioRecordWidget.value =
                    false;
                    Get.find<ParentChattingController>().showAudioPlayingWidget.value =
                    true;
                  } else {
                    Get.find<FeedViewController>().showAudioRecordWidget.value =
                    false;
                    Get.find<FeedViewController>().showAudioPlayingWidget.value =
                    true;
                  }
                });
              }
            },
            child: const Icon(
              Icons.check,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
