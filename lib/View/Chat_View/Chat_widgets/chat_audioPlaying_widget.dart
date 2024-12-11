import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teacherapp/Controller/api_controllers/feedViewController.dart';

import '../../../Utils/Colors.dart';

class ChatAudioPlayingWidget extends StatefulWidget {
  // final Function(bool) removeAudioPath;
  const ChatAudioPlayingWidget({
    super.key,
    // required this.removeAudioPath,
  });

  @override
  State<ChatAudioPlayingWidget> createState() => _ChatAudioPlayingWidgetState();
}

class _ChatAudioPlayingWidgetState extends State<ChatAudioPlayingWidget> {
  final player = AudioPlayer();
  Duration _audioPosition = Duration.zero;
  Duration _audioDuration = Duration.zero;
  bool _isPlaying = false;
  String? _audioPath;
  String userId = "";
  String schoolId = "";

  @override
  void initState() {
    _initAudioPlayer();
    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  void _initAudioPlayer() async {
    player.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() => _isPlaying = state == PlayerState.playing);
      }
    });

    player.onDurationChanged.listen((Duration duration) {
      if (mounted) {
        setState(() => _audioDuration = duration);
      }
    });

    player.onPositionChanged.listen((Duration duration) {
      if (mounted) {
        setState(() => _audioPosition = duration);
      }
    });

    // player.onPlayerComplete.listen((event) {
    //   if (mounted) {
    //     setState(() => _audioPosition = Duration.zero);
    //   }
    // });

    _audioPath = Get.find<FeedViewController>().audioPath.value!;
    await player.setSourceDeviceFile(_audioPath!);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.h),
          color: Colors.white,
        ),
        height: 50.h,
        width: double.infinity,
        child: Row(
          children: [
            InkWell(
              onTap: () => _playAudio(_audioPath!),
              child: SizedBox(
                width: 25,
                height: 25,
                child: Center(child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow)),
              ),
            ),
            Expanded(
              child: SliderTheme(
                data: const SliderThemeData(
                    thumbShape: RoundSliderThumbShape(
                        enabledThumbRadius: 8, disabledThumbRadius: 8)),
                child: Slider(
                  min: 0,
                  max: _audioDuration.inSeconds.toDouble(),
                  value: _audioPosition.inSeconds.toDouble(),
                  onChanged: (value) async {
                    final position = Duration(seconds: value.toInt());
                    await player.seek(position);
                    await player.resume();
                  },
                  thumbColor: Colorutils.userdetailcolor,
                  activeColor: Colorutils.userdetailcolor,
                ),
              ),
            ),
            SizedBox(width: 5.w),
            Text(
              formatDuration(_audioDuration - _audioPosition),
              style: const TextStyle(fontSize: 10),
            ),
            SizedBox(width: 5.w),
            InkWell(
              onTap: () {
                Get.find<FeedViewController>().audioPath.value = null;
                Get.find<FeedViewController>().showAudioPlayingWidget.value =
                    false; // for hiding the audio playing widget //
              },
              child: SizedBox(
                width: 25.w,
                height: 40.w,
                child: const Icon(
                  Icons.close,
                  color: Colors.grey,
                ),
              ),
            ),
            // SizedBox(
            //   width: 25,
            //   child: IconButton(
            //     onPressed: () {
            //       Get.find<FeedViewController>().audioPath.value = null;
            //     },
            //     icon: const Icon(
            //       Icons.close,
            //       color: ColorUtil.grey,
            //     ),
            //   ),
            // ),
            SizedBox(width: 5.w),
          ],
        ),
      ),
    );
  }

  Future<void> _playAudio(String content) async {
    if (_isPlaying) {
      await player.pause();
    } else {
      await player.play(DeviceFileSource(_audioPath!));
    }
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String threeDigits(int n) => n.toString().padLeft(3, '0');

    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    String milliseconds = threeDigits(duration.inMilliseconds.remainder(1000));

    if (hours == "00") {
      return '$minutes:$seconds';
    } else {
      return '$hours:$minutes:$seconds';
    }
  }
}
