import 'dart:async';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:audioplayers/audioplayers.dart' as audio;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:teacherapp/Controller/db_controller/Feed_db_controller.dart';
import 'package:teacherapp/Utils/Colors.dart';
import 'package:teacherapp/Utils/audio.dart';
import 'package:teacherapp/Utils/constant_function.dart';
import 'package:teacherapp/Utils/font_util.dart';

class AudioWidget extends StatefulWidget {
  final String content;
  final String messageId;
  const AudioWidget({
    super.key,
    required this.content,
    required this.messageId,
  });

  @override
  State<AudioWidget> createState() => _AudioWidgetState();
}

class _AudioWidgetState extends State<AudioWidget>
// with AutomaticKeepAliveClientMixin
{
  String? path;
  bool isLoading = false;
  late PlayerController playerController;
  late StreamSubscription<PlayerState> playerStateSubcriptionController;
  Duration? totalDuration;
  late audio.AudioPlayer audioS;

  String seek = "1";
  Duration? _audioDuration = Duration.zero;
  bool _isPlaying = false;
  List<double>? waveData;
  @override
  void initState() {
    playerController = PlayerController();
    audioS = audio.AudioPlayer();
    playerStateSubcriptionController =
        playerController.onPlayerStateChanged.listen(
      (event) {
        Get.find<FeedDBController>().uiUpdate();
      },
    );
    playerController.onPlayerStateChanged.listen((state) {
      _isPlaying = state.isPlaying;
    });
    playerController.onCurrentDurationChanged.listen((duration) {
      _audioDuration = totalDuration! - Duration(milliseconds: duration);
      Get.find<FeedDBController>().uiUpdate();
    });
    // _initAudioPlayer();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await _initAudioPlayer();
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    playerStateSubcriptionController.cancel();
    // playerController.stopAllPlayers(); // Stop all registered audio players
    playerController.dispose();
    super.dispose();
  }

  Future<void> _initAudioPlayer() async {
    print("Init Work --------------------------------------------");
    // Fetch or download the file path
    path = await Get.find<FeedDBController>()
        .getFilePathByFileName(url: widget.content, type: "audio");

    // if (path == null) {
    //   checkInternet(
    //     context: context,
    //     function: () async {
    //       try {
    //         isLoading = true;
    //         Get.find<DBController>().uiUpdate();

    //         print("objectArun  2");
    //         await Get.find<DBController>().dowloadMediaToDB(
    //             messageId: widget.messageId,
    //             url: widget.content,
    //             type: "audio");
    //         path = await Get.find<DBController>()
    //             .getFilePathByFileName(url: widget.content, type: "audio");

    //         isLoading = false;
    //         Get.find<DBController>().uiUpdate();
    //       } catch (e) {
    //         isLoading = false;
    //       }
    //     },
    //   );
    // }

    if (path != null) {
      waveData = await Get.find<FeedDBController>()
          .getAudiofileWaveData(messageId: widget.messageId, type: "audio");

      await playerController.preparePlayer(
        path: path!,
      );
      // _audioDuration = Duration(
      //     milliseconds: await playerController.getDuration(DurationType.max));
      // _audioDuration = totalDuration;
    }

    // Get.find<DBController>().uiUpdate();
  }

  // @override
  // bool get wantKeepAlive => true; // Return true to keep the state alive.

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        if (!_isPlaying) {
          path = await Get.find<FeedDBController>()
              .getFilePathByFileName(url: widget.content, type: "audio");

          waveData = await Get.find<FeedDBController>()
              .getAudiofileWaveData(messageId: widget.messageId, type: "audio");

          _audioDuration = await Get.find<FeedDBController>()
              .getAudiofileDurationData(
                  messageId: widget.messageId, type: "audio");

          totalDuration = _audioDuration;

          Get.find<FeedDBController>().uiUpdate();
        }
      },
    );

    return Material(
      color: Colorutils.transparent,
      child: GetBuilder<FeedDBController>(builder: (Controller) {
        print("Rebuild Dowload start---------------------");
        return Container(
          width: 290.w,
          // height: 70,
          decoration: BoxDecoration(
              color: Colorutils.fontColor17,
              borderRadius: BorderRadius.circular(10.h),
              boxShadow: const [
                // BoxShadow(
                //   blurRadius: 1,
                //   color: ColorUtil.grey.withOpacity(0.5),
                // )
              ]),
          child: Padding(
            padding: EdgeInsets.all(8.w),
            child: Row(
              children: [
                Container(
                    height: 45.w,
                    width: 45.w,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colorutils.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 2,
                            color: Colorutils.grey,
                          )
                        ]),
                    child: isLoading
                        ? SizedBox(
                            width: 25.w,
                            height: 25.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : path != null &&
                                waveData != null &&
                                _audioDuration != null
                            ? InkWell(
                                // onTap: () => _playAudio(path!),
                                onTap: () async {
                                  SingleAudio.playSingleAudio(
                                      playerController, _isPlaying, path!);
                                },
                                child: Center(
                                  child: SizedBox(
                                    height: 25.h,
                                    width: 25.h,
                                    child: FittedBox(
                                      child: Icon(_isPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow),
                                    ),
                                  ),
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  checkInternet(
                                    context: context,
                                    function: () async {
                                      // if (path == null) {
                                      //   isLoading = true;
                                      //   Get.find<DBController>().uiUpdate();
                                      //   print("objectArun  2");
                                      //   await Get.find<DBController>()
                                      //       .dowloadMediaToDB(
                                      //           messageId: widget.messageId,
                                      //           url: widget.content,
                                      //           type: "audio");
                                      //   path = await Get.find<DBController>()
                                      //       .getFilePathByFileName(
                                      //           url: widget.content,
                                      //           type: "audio");

                                      //   waveData = await playerController
                                      //       .extractWaveformData(
                                      //           path: path!, noOfSamples: 20);

                                      //   isLoading = false;

                                      //   await playerController.preparePlayer(
                                      //     path: path!,
                                      //   );

                                      //   _audioDuration = totalDuration =
                                      //       Duration(
                                      //           milliseconds:
                                      //               await playerController
                                      //                   .getDuration(
                                      //                       DurationType.max));

                                      //   await Controller
                                      //       .dowloadAudioWaveDataToDB(
                                      //           messageId: widget.messageId,
                                      //           audioData: waveData!,
                                      //           duration:
                                      //               _audioDuration!.toString(),
                                      //           type: "audio");

                                      //   Get.find<DBController>().uiUpdate();
                                      // }

                                      path = null;

                                      if (path == null) {
                                        try {
                                          isLoading = true;
                                          Get.find<FeedDBController>()
                                              .uiUpdate();
                                          print("start working ----------- 1");
                                          await Get.find<FeedDBController>()
                                              .dowloadMediaToDB(
                                                  messageId: widget.messageId,
                                                  url: widget.content,
                                                  type: "audio")
                                              .then(
                                            (value) async {
                                              print(
                                                  "start working ----------- 2");
                                              path = await Get.find<
                                                      FeedDBController>()
                                                  .getFilePathByFileName(
                                                      url: widget.content,
                                                      type: "audio");
                                            },
                                          ).then(
                                            (value) async {
                                              print(
                                                  "start working ----------- 3");
                                              waveData = await playerController
                                                  .extractWaveformData(
                                                      path: path!,
                                                      noOfSamples: 20);
                                            },
                                          ).then(
                                            (value) async {
                                              print(
                                                  "start working ----------- 4");
                                              print(
                                                  "start working ----------- 4 --- $path");

                                              await audioS
                                                  .setSourceDeviceFile(path!);

                                              _audioDuration =
                                                  await audioS.getDuration();
                                              print(
                                                  "start working ----------- $_audioDuration");

                                              // final duration =
                                              //     await playerController
                                              //         .getDuration(
                                              //             DurationType.max);

                                              // print(
                                              //     "start working ----------- $duration");

                                              // _audioDuration = Duration(
                                              //     milliseconds: duration);

                                              totalDuration = _audioDuration;
                                              print(
                                                  "start working ----------- 5");
                                              await Controller
                                                  .dowloadAudioWaveDataToDB(
                                                      messageId:
                                                          widget.messageId,
                                                      audioData: waveData!,
                                                      duration: _audioDuration!
                                                          .toString(),
                                                      type: "audio");
                                              print(
                                                  "start working ----------- 6");
                                              isLoading = false;

                                              await playerController
                                                  .preparePlayer(
                                                path: path!,
                                              );

                                              Get.find<FeedDBController>()
                                                  .uiUpdate();
                                            },
                                          );
                                        } catch (e) {
                                          print("start working ----------- $e");
                                        }
                                      }
                                    },
                                  );
                                },
                                child: SizedBox(
                                  width: 25.w,
                                  height: 25.w,
                                  child: const Icon(
                                    Icons.download_rounded,
                                    color: Colorutils.userdetailcolor,
                                  ),
                                ),
                              )),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: _audioDuration == null
                      ? Text(
                          "00:00",
                          style: TextStyle(fontSize: 10.w),
                        )
                      : Text(
                          formatDuration(_audioDuration!),
                          style: TextStyle(fontSize: 10.w),
                        ),
                ),
                waveData == null
                    ? Padding(
                        padding: EdgeInsets.all(4.w),
                        child: SizedBox(
                          width: 117.w,
                          height: 10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(
                              20,
                              (index) {
                                return Container(
                                  height: 3.2,
                                  width: 3.2,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colorutils.black.withOpacity(.25)),
                                );
                              },
                            ),
                          ),
                        ),
                      )
                    : Expanded(
                        child: AudioFileWaveforms(
                          waveformData: waveData!,
                          size: Size(200.w, 30.h),
                          playerController: playerController,
                          enableSeekGesture: true,
                          waveformType: WaveformType.fitWidth,
                          playerWaveStyle: PlayerWaveStyle(
                            fixedWaveColor: Colorutils.black.withOpacity(.25),
                            // liveWaveColor: Colors.blueAccent,
                            liveWaveColor: Colorutils.userdetailcolor,
                            spacing: 6.w,
                          ),
                        ),
                      ),
                _isPlaying
                    ? InkWell(
                        onTap: () {
                          setState(() {
                            if (seek == "1") {
                              seek = "1.5";
                            } else if (seek == "1.5") {
                              seek = "2";
                            } else {
                              seek = "1";
                            }
                          });
                          switch (seek) {
                            case "1":
                              {
                                playerController.setRate(1.0);
                              }
                            case "1.5":
                              {
                                playerController.setRate(1.5);
                              }
                            case "2":
                              {
                                playerController.setRate(2.0);
                              }
                          }
                        },
                        child: Container(
                          width: 40.w,
                          height: 30.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.h),
                            color: Colorutils.white,
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 2,
                                color: Colorutils.grey,
                              )
                            ],
                          ),
                          child: Center(
                            child: Text(
                              "x$seek",
                              style: TeacherAppFonts.interW600_14sp_textWhite
                                  .copyWith(color: Colorutils.black),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox()
              ],
            ),
          ),
        );
      }),
    );
  }

  // Future<void> _playAudio(String content) async {
  //   if (!_isPlaying) {
  //     // await playerController.stopPlayer();
  //     await playerController.startPlayer(finishMode: FinishMode.pause);
  //   } else {
  //     await playerController.pausePlayer();
  //     // player.play;
  //   }
  // }

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

class AudioWidget2 extends StatefulWidget {
  final String content;
  final String messageId;
  const AudioWidget2({
    super.key,
    required this.content,
    required this.messageId,
  });

  @override
  State<AudioWidget2> createState() => _AudioWidget2State();
}

class _AudioWidget2State extends State<AudioWidget2>
// with AutomaticKeepAliveClientMixin
{
  String? path;
  bool isLoading = false;
  late PlayerController playerController;
  late StreamSubscription<PlayerState> playerStateSubcriptionController;
  Duration? totalDuration;
  late audio.AudioPlayer audioS;

  String seek = "1";
  Duration? _audioDuration = Duration.zero;
  bool _isPlaying = false;
  List<double>? waveData;
  @override
  void initState() {
    playerController = PlayerController();
    audioS = audio.AudioPlayer();
    playerStateSubcriptionController =
        playerController.onPlayerStateChanged.listen(
      (event) {
        Get.find<FeedDBController>().uiUpdate();
      },
    );
    playerController.onPlayerStateChanged.listen((state) {
      _isPlaying = state.isPlaying;
    });
    playerController.onCurrentDurationChanged.listen((duration) {
      _audioDuration = totalDuration! - Duration(milliseconds: duration);
      Get.find<FeedDBController>().uiUpdate();
    });
    // _initAudioPlayer();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await _initAudioPlayer();
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    playerStateSubcriptionController.cancel();
    // playerController.stopAllPlayers(); // Stop all registered audio players
    playerController.dispose();
    super.dispose();
  }

  Future<void> _initAudioPlayer() async {
    print("Init Work --------------------------------------------");
    // Fetch or download the file path
    path = await Get.find<FeedDBController>()
        .getFilePathByFileName(url: widget.content, type: "audio");

    // if (path == null) {
    //   checkInternet(
    //     context: context,
    //     function: () async {
    //       try {
    //         isLoading = true;
    //         Get.find<DBController>().uiUpdate();

    //         print("objectArun  2");
    //         await Get.find<DBController>().dowloadMediaToDB(
    //             messageId: widget.messageId,
    //             url: widget.content,
    //             type: "audio");
    //         path = await Get.find<DBController>()
    //             .getFilePathByFileName(url: widget.content, type: "audio");

    //         isLoading = false;
    //         Get.find<DBController>().uiUpdate();
    //       } catch (e) {
    //         isLoading = false;
    //       }
    //     },
    //   );
    // }

    if (path != null) {
      waveData = await Get.find<FeedDBController>()
          .getAudiofileWaveData(messageId: widget.messageId, type: "audio");

      await playerController.preparePlayer(
        path: path!,
      );
      // _audioDuration = Duration(
      //     milliseconds: await playerController.getDuration(DurationType.max));
      // _audioDuration = totalDuration;
    }

    // Get.find<DBController>().uiUpdate();
  }

  // @override
  // bool get wantKeepAlive => true; // Return true to keep the state alive.

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        if (!_isPlaying) {
          path = await Get.find<FeedDBController>()
              .getFilePathByFileName(url: widget.content, type: "audio");

          waveData = await Get.find<FeedDBController>()
              .getAudiofileWaveData(messageId: widget.messageId, type: "audio");

          _audioDuration = await Get.find<FeedDBController>()
              .getAudiofileDurationData(
                  messageId: widget.messageId, type: "audio");

          totalDuration = _audioDuration;

          Get.find<FeedDBController>().uiUpdate();
        }
      },
    );

    return Material(
      color: Colorutils.transparent,
      child: GetBuilder<FeedDBController>(builder: (Controller) {
        print("Rebuild Dowload start---------------------");
        return Container(
          width: 290.w,
          // height: 70,
          decoration: BoxDecoration(
              color: Colorutils.replayBg,
              borderRadius: BorderRadius.circular(10.h),
              boxShadow: const [
                // BoxShadow(
                //   blurRadius: 1,
                //   color: ColorUtil.grey.withOpacity(0.5),
                // )
              ]),
          child: Padding(
            padding: EdgeInsets.all(8.w),
            child: Row(
              children: [
                Container(
                    height: 45.w,
                    width: 45.w,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colorutils.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 2,
                            color: Colorutils.grey,
                          )
                        ]),
                    child: isLoading
                        ? SizedBox(
                            width: 25.w,
                            height: 25.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : path != null &&
                                waveData != null &&
                                _audioDuration != null
                            ? InkWell(
                                // onTap: () => _playAudio(path!),
                                onTap: () async {
                                  SingleAudio.playSingleAudio(
                                      playerController, _isPlaying, path!);
                                },
                                child: Center(
                                  child: SizedBox(
                                    height: 25.h,
                                    width: 25.h,
                                    child: FittedBox(
                                      child: Icon(_isPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow),
                                    ),
                                  ),
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  checkInternet(
                                    context: context,
                                    function: () async {
                                      // if (path == null) {
                                      //   isLoading = true;
                                      //   Get.find<DBController>().uiUpdate();
                                      //   print("objectArun  2");
                                      //   await Get.find<DBController>()
                                      //       .dowloadMediaToDB(
                                      //           messageId: widget.messageId,
                                      //           url: widget.content,
                                      //           type: "audio");
                                      //   path = await Get.find<DBController>()
                                      //       .getFilePathByFileName(
                                      //           url: widget.content,
                                      //           type: "audio");

                                      //   waveData = await playerController
                                      //       .extractWaveformData(
                                      //           path: path!, noOfSamples: 20);

                                      //   isLoading = false;

                                      //   await playerController.preparePlayer(
                                      //     path: path!,
                                      //   );

                                      //   _audioDuration = totalDuration =
                                      //       Duration(
                                      //           milliseconds:
                                      //               await playerController
                                      //                   .getDuration(
                                      //                       DurationType.max));

                                      //   await Controller
                                      //       .dowloadAudioWaveDataToDB(
                                      //           messageId: widget.messageId,
                                      //           audioData: waveData!,
                                      //           duration:
                                      //               _audioDuration!.toString(),
                                      //           type: "audio");

                                      //   Get.find<DBController>().uiUpdate();
                                      // }

                                      path = null;

                                      if (path == null) {
                                        try {
                                          isLoading = true;
                                          Get.find<FeedDBController>()
                                              .uiUpdate();
                                          print("start working ----------- 1");
                                          await Get.find<FeedDBController>()
                                              .dowloadMediaToDB(
                                                  messageId: widget.messageId,
                                                  url: widget.content,
                                                  type: "audio")
                                              .then(
                                            (value) async {
                                              print(
                                                  "start working ----------- 2");
                                              path = await Get.find<
                                                      FeedDBController>()
                                                  .getFilePathByFileName(
                                                      url: widget.content,
                                                      type: "audio");
                                            },
                                          ).then(
                                            (value) async {
                                              print(
                                                  "start working ----------- 3");
                                              waveData = await playerController
                                                  .extractWaveformData(
                                                      path: path!,
                                                      noOfSamples: 20);
                                            },
                                          ).then(
                                            (value) async {
                                              print(
                                                  "start working ----------- 4");
                                              print(
                                                  "start working ----------- 4 --- $path");

                                              await audioS
                                                  .setSourceDeviceFile(path!);

                                              _audioDuration =
                                                  await audioS.getDuration();
                                              print(
                                                  "start working ----------- $_audioDuration");

                                              // final duration =
                                              //     await playerController
                                              //         .getDuration(
                                              //             DurationType.max);

                                              // print(
                                              //     "start working ----------- $duration");

                                              // _audioDuration = Duration(
                                              //     milliseconds: duration);

                                              totalDuration = _audioDuration;
                                              print(
                                                  "start working ----------- 5");
                                              await Controller
                                                  .dowloadAudioWaveDataToDB(
                                                      messageId:
                                                          widget.messageId,
                                                      audioData: waveData!,
                                                      duration: _audioDuration!
                                                          .toString(),
                                                      type: "audio");
                                              print(
                                                  "start working ----------- 6");
                                              isLoading = false;

                                              await playerController
                                                  .preparePlayer(
                                                path: path!,
                                              );

                                              Get.find<FeedDBController>()
                                                  .uiUpdate();
                                            },
                                          );
                                        } catch (e) {
                                          print("start working ----------- $e");
                                        }
                                      }
                                    },
                                  );
                                },
                                child: SizedBox(
                                  width: 25.w,
                                  height: 25.w,
                                  child: const Icon(
                                    Icons.download_rounded,
                                    color: Colorutils.userdetailcolor,
                                  ),
                                ),
                              )),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: _audioDuration == null
                      ? Text(
                          "00:00",
                          style: TextStyle(fontSize: 10.w),
                        )
                      : Text(
                          formatDuration(_audioDuration!),
                          style: TextStyle(fontSize: 10.w),
                        ),
                ),
                waveData == null
                    ? Padding(
                        padding: EdgeInsets.all(4.w),
                        child: SizedBox(
                          width: 117.w,
                          height: 10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(
                              20,
                              (index) {
                                return Container(
                                  height: 3.2,
                                  width: 3.2,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colorutils.black.withOpacity(.25)),
                                );
                              },
                            ),
                          ),
                        ),
                      )
                    : Expanded(
                        child: AudioFileWaveforms(
                          waveformData: waveData!,
                          size: Size(200.w, 30.h),
                          playerController: playerController,
                          enableSeekGesture: true,
                          waveformType: WaveformType.fitWidth,
                          playerWaveStyle: PlayerWaveStyle(
                            fixedWaveColor: Colorutils.black.withOpacity(.25),
                            // liveWaveColor: Colors.blueAccent,
                            liveWaveColor: Colorutils.userdetailcolor,
                            spacing: 6.w,
                          ),
                        ),
                      ),
                _isPlaying
                    ? InkWell(
                        onTap: () {
                          setState(() {
                            if (seek == "1") {
                              seek = "1.5";
                            } else if (seek == "1.5") {
                              seek = "2";
                            } else {
                              seek = "1";
                            }
                          });
                          switch (seek) {
                            case "1":
                              {
                                playerController.setRate(1.0);
                              }
                            case "1.5":
                              {
                                playerController.setRate(1.5);
                              }
                            case "2":
                              {
                                playerController.setRate(2.0);
                              }
                          }
                        },
                        child: Container(
                          width: 40.w,
                          height: 30.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.h),
                            color: Colorutils.white,
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 2,
                                color: Colorutils.grey,
                              )
                            ],
                          ),
                          child: Center(
                            child: Text(
                              "x$seek",
                              style: TeacherAppFonts.interW600_14sp_textWhite
                                  .copyWith(color: Colorutils.black),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox()
              ],
            ),
          ),
        );
      }),
    );
  }

  // Future<void> _playAudio(String content) async {
  //   if (!_isPlaying) {
  //     // await playerController.stopPlayer();
  //     await playerController.startPlayer(finishMode: FinishMode.pause);
  //   } else {
  //     await playerController.pausePlayer();
  //     // player.play;
  //   }
  // }

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




// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';
// import 'package:teacherapp/Utils/Colors.dart';

// class AudioWidget extends StatefulWidget {
//   final String content;
//   const AudioWidget({super.key, required this.content});

//   @override
//   State<AudioWidget> createState() => _AudioWidgetState();
// }

// class _AudioWidgetState extends State<AudioWidget> {
//   final player = AudioPlayer();
//   Duration _audioPosition = Duration.zero;
//   Duration _audioDuration = Duration.zero;
//   bool _isPlaying = false;

//   @override
//   void initState() {
//     _initAudioPlayer();
//     super.initState();
//   }

//   @override
//   void didUpdateWidget(covariant AudioWidget oldWidget) {
//     if (widget.content != oldWidget.content) {
//       _audioPosition = Duration.zero;
//       _audioDuration = Duration.zero;
//     }
//     _initAudioPlayer();
//     super.didUpdateWidget(oldWidget);
//   }

//   @override
//   void dispose() {
//     player.dispose();
//     super.dispose();
//   }

//   void _initAudioPlayer() async {
//     player.onPlayerStateChanged.listen((state) {
//       if (mounted) {
//         setState(() => _isPlaying = state == PlayerState.playing);
//       }
//     });

//     player.onDurationChanged.listen((Duration duration) {
//       if (mounted) {
//         setState(() => _audioDuration = duration);
//       }
//     });

//     player.onPositionChanged.listen((Duration duration) {
//       if (mounted) {
//         setState(() => _audioPosition = duration);
//       }
//     });

//     player.onPlayerComplete.listen((event) {
//       if (mounted) {
//         setState(() => _audioPosition = Duration.zero);
//       }
//     });

//     await player.setSourceUrl(widget.content);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.transparent,
//       child: Container(
//         width: 230,
//         height: 70,
//         decoration: BoxDecoration(
//             color: Colors.white, borderRadius: BorderRadius.circular(10)),
//         child: Row(
//           children: [
//             SizedBox(
//               width: 180,
//               height: 40,
//               child: SliderTheme(
//                 data: const SliderThemeData(
//                     thumbShape: RoundSliderThumbShape(
//                         enabledThumbRadius: 8, disabledThumbRadius: 8)),
//                 child: Slider(
//                   thumbColor: Colorutils.userdetailcolor,
//                   activeColor: Colorutils.userdetailcolor,
//                   min: 0,
//                   max: _audioDuration.inSeconds.toDouble(),
//                   value: _audioPosition.inSeconds.toDouble(),
//                   onChanged: (value) async {
//                     final position = Duration(seconds: value.toInt());
//                     await player.seek(position);
//                     await player.resume();
//                   },
//                 ),
//               ),
//             ),
//             Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 if (_audioDuration != Duration.zero)
//                   IconButton(
//                     onPressed: () => _playAudio(widget.content),
//                     icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
//                   ),
//                 if (_audioDuration == Duration.zero)
//                   const Padding(
//                     padding: EdgeInsets.all(13.0),
//                     child: SizedBox(
//                       width: 20,
//                       height: 20,
//                       child: CircularProgressIndicator(),
//                     ),
//                   ),
//                 Text(
//                   formatDuration(_audioDuration - _audioPosition),
//                   style: const TextStyle(fontSize: 10),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _playAudio(String content) async {
//     if (_isPlaying) {
//       await player.pause();
//     } else {
//       await player.play(UrlSource(content));
//     }
//   }

//   String formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     String threeDigits(int n) => n.toString().padLeft(3, '0');

//     String hours = twoDigits(duration.inHours);
//     String minutes = twoDigits(duration.inMinutes.remainder(60));
//     String seconds = twoDigits(duration.inSeconds.remainder(60));
//     String milliseconds = threeDigits(duration.inMilliseconds.remainder(1000));

//     if (hours == "00") {
//       return '$minutes:$seconds';
//     } else {
//       return '$hours:$minutes:$seconds';
//     }
//   }
// }
