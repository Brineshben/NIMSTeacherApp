import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart' as audio;
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sqflite/sqflite.dart';
import 'package:teacherapp/Controller/db_controller/Feed_db_controller.dart';
import 'package:teacherapp/Services/common_services.dart';
import 'package:teacherapp/Utils/Colors.dart';
import 'package:teacherapp/Utils/audio.dart';
import 'package:teacherapp/Utils/constant_function.dart';
import 'package:teacherapp/Utils/font_util.dart';

class AudioFileWidget extends StatefulWidget {
  final String content;
  final String messageId;
  ValueNotifier<double> progress = ValueNotifier(0.0);
  AudioFileWidget({
    super.key,
    required this.content,
    required this.messageId,
  });

  @override
  State<AudioFileWidget> createState() => _AudioFileWidgetState();
}

class _AudioFileWidgetState extends State<AudioFileWidget>
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
      // _audioDuration = totalDuration! - Duration(milliseconds: duration);
      _audioDuration = Duration(milliseconds: duration);
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
              // color: Colorutils.bgcolor10.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10.h),
              boxShadow: const [
                // BoxShadow(
                //   blurRadius: 1,
                //   color: ColorUtil.grey.withOpacity(0.5),
                // )
              ]),
          child: Padding(
            padding: EdgeInsets.all(8.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                                child: ValueListenableBuilder(
                                  valueListenable: widget.progress,
                                  builder: (context, value, child) {
                                    print(
                                        "rebuilding ----------------- dowuload ${value}");
                                    // return DownloadProgress(
                                    //     progress: widget.progress.value);
                                    return Stack(
                                      children: [
                                        Center(
                                          child: CircularProgressIndicator(
                                            value: value /
                                                100, // Use the progress value (0.0 to 1.0)
                                            strokeWidth: 2.0,
                                            valueColor:
                                                const AlwaysStoppedAnimation<
                                                    Color>(Colors.blue),
                                            backgroundColor: Colors.grey[200],
                                          ),
                                        ),
                                        Center(
                                            child: Text(
                                          "${value.toStringAsFixed(0)}%",
                                          style: TeacherAppFonts
                                              .interW400_8sp_textWhite
                                              .copyWith(color: Colors.blue),
                                        ))
                                      ],
                                    );
                                  },
                                ),
                                // const CircularProgressIndicator(
                                //   strokeWidth: 2,
                                // ),
                              )
                            : path != null &&
                                    // waveData != null &&
                                    _audioDuration != null
                                ? InkWell(
                                    // onTap: () => _playAudio(path!),
                                    onTap: () async {
                                      SingleAudio.playSingleAudio(
                                          playerController, _isPlaying, path!);
                                    },
                                    child: Icon(_isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow),
                                  )
                                : InkWell(
                                    onTap: () {
                                      checkInternet(
                                        context: context,
                                        function: () async {
                                          path = null;

                                          if (path == null) {
                                            try {
                                              isLoading = true;
                                              Get.find<FeedDBController>()
                                                  .uiUpdate();
                                              print(
                                                  "start working ----------- 1");
                                              // await Get.find<DBController>()
                                              //     .
                                              await dowloadMediaToDB(
                                                      messageId:
                                                          widget.messageId,
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
                                                  print(
                                                      "start working ----------- $path");
                                                },
                                              ).then(
                                                (value) async {
                                                  print(
                                                      "start working ----------- 4");
                                                  print(
                                                      "start working ----------- 4 --- $path");

                                                  await audioS
                                                      .setSourceDeviceFile(
                                                          path!);

                                                  _audioDuration = await audioS
                                                      .getDuration();
                                                  print(
                                                      "start working ----------- $_audioDuration");

                                                  totalDuration =
                                                      _audioDuration;
                                                  print(
                                                      "start working ----------- 5");
                                                  await Controller
                                                      .dowloadAudioWaveDataToDB(
                                                          messageId:
                                                              widget.messageId,
                                                          audioData: [],
                                                          duration:
                                                              _audioDuration!
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
                                              print(
                                                  "start working ----------- $e");
                                            }
                                          }
                                        },
                                      );
                                    },
                                    child: SizedBox(
                                      width: 25.w,
                                      height: 25.w,
                                      child: const Icon(Icons.download_rounded,
                                          color: Colorutils.userdetailcolor),
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
                    path != null &&
                            _audioDuration != null &&
                            totalDuration != null
                        ? Expanded(
                            child: SliderTheme(
                              data: SliderThemeData(
                                thumbColor: Colorutils.userdetailcolor,
                                activeTrackColor: Colorutils.userdetailcolor,
                                trackHeight: 1.h,
                                thumbShape: RoundSliderThumbShape(
                                    enabledThumbRadius: 8.h),
                              ),
                              child: Slider(
                                min: 0,
                                max: totalDuration!.inMilliseconds.toDouble(),
                                value:
                                    _audioDuration!.inMilliseconds.toDouble(),
                                onChanged: (value) {
                                  final newPosition =
                                      Duration(milliseconds: value.toInt());
                                  playerController
                                      .seekTo(newPosition.inMilliseconds);
                                  // _audioPlayer.seek(newPosition); // Seek to the new position
                                },
                              ),
                            ),
                          )
                        : Expanded(
                            child: SliderTheme(
                              data: SliderThemeData(
                                activeTrackColor: Colorutils.userdetailcolor,
                                thumbColor: Colorutils.userdetailcolor,
                                trackHeight: 1.h,
                                thumbShape: RoundSliderThumbShape(
                                    enabledThumbRadius: 8.h),
                              ),
                              child: Slider(
                                value: 0,
                                onChanged: (value) {},
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
                                  style: TeacherAppFonts.interW600_14sp_letters1
                                      .copyWith(color: Colorutils.black),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox()
                  ],
                ),
                hSpace(5.h),
                Text(widget.content.split('/').last,
                    style:
                        TeacherAppFonts.interW400_12sp_topicbackground.copyWith(
                      color: Colorutils.black,
                    ))
              ],
            ),
          ),
        );
      }),
    );
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

  Future<void> dowloadMediaToDB({
    required String messageId,
    required String url,
    required String type,
  }) async {
    String mediaTableName = "mediatable$type";

    await Get.find<FeedDBController>().db.execute('''
    CREATE TABLE IF NOT EXISTS $mediaTableName (
     id INTEGER PRIMARY KEY AUTOINCREMENT,
      filePath TEXT,
      message_id TEXT,
      file_name TEXT UNIQUE, 
      file_url TEXT,
      type TEXT
     )
    ''');
    final fileName = url.split("/").last;
    final path = await downloadFile(url, fileName);

    Map<String, dynamic> values = {
      'filePath': path,
      'message_id': messageId,
      'file_name': fileName,
      'file_url': url,
      'type': type
    };

    await Get.find<FeedDBController>().db.insert(
          mediaTableName,
          values,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
  }

  Future<String> downloadFile(String url, String fileName) async {
    await requestStoragePermission(); // Ensure storage permission is granted

    try {
      // Define the download directory and create a new folder if it doesn't exist
      // Directory downloadDirectory = Directory('/storage/emulated/0/Download');
      Directory? downloadDirectory = await getApplicationDocumentsDirectory();
      Directory schoolDiaryFolder =
          Directory('${downloadDirectory.path}/School Diary');

      // Create the SchoolDiary folder
      if (!(await schoolDiaryFolder.exists())) {
        await schoolDiaryFolder.create(recursive: true);
      }

      // Set the path where the file will be saved
      String savePath = '${schoolDiaryFolder.path}/$fileName';

      // Download the file from the URL
      var response = await Dio().download(
        url,
        savePath,
        onReceiveProgress: (count, total) {
          double value = count / total * 100;
          widget.progress.value = value;
          // ChangeNotifier();

          // print(
          // "on receive progress ====================== $count  and $total = $value %");
          print(
              "on receive progress ====================== ${widget.progress.value}%");
        },
      );

      // Check if the download was successful
      if (response.statusCode == 200) {
        print('File downloaded to: $savePath');
        // Notify the media scanner to make the file visible in the gallery
        // await _scanFile(savePath);
      } else {
        print('Failed to download file: ${response.statusCode}');
      }

      return savePath; // Return the path of the downloaded file
    } catch (e) {
      print('Failed to download file: $e');
      throw e; // Rethrow the error for further handling
    }
  }
}

class AudioFileWidget2 extends StatefulWidget {
  final String content;
  final String messageId;
  ValueNotifier<double> progress = ValueNotifier(0.0);
  AudioFileWidget2({
    super.key,
    required this.content,
    required this.messageId,
  });

  @override
  State<AudioFileWidget2> createState() => _AudioFileWidget2State();
}

class _AudioFileWidget2State extends State<AudioFileWidget2>
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
      // _audioDuration = totalDuration! - Duration(milliseconds: duration);
      _audioDuration = Duration(milliseconds: duration);
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                                child: ValueListenableBuilder(
                                  valueListenable: widget.progress,
                                  builder: (context, value, child) {
                                    print(
                                        "rebuilding ----------------- dowuload ${value}");
                                    // return DownloadProgress(
                                    //     progress: widget.progress.value);
                                    return Stack(
                                      children: [
                                        Center(
                                          child: CircularProgressIndicator(
                                            value: value /
                                                100, // Use the progress value (0.0 to 1.0)
                                            strokeWidth: 2.0,
                                            valueColor:
                                                const AlwaysStoppedAnimation<
                                                    Color>(Colors.blue),
                                            backgroundColor: Colors.grey[200],
                                          ),
                                        ),
                                        Center(
                                            child: Text(
                                          "${value.toStringAsFixed(0)}%",
                                          style: TeacherAppFonts
                                              .interW400_8sp_textWhite
                                              .copyWith(color: Colors.blue),
                                        ))
                                      ],
                                    );
                                  },
                                ),
                                // const CircularProgressIndicator(
                                //   strokeWidth: 2,
                                // ),
                              )
                            : path != null &&
                                    // waveData != null &&
                                    _audioDuration != null
                                ? InkWell(
                                    // onTap: () => _playAudio(path!),
                                    onTap: () async {
                                      SingleAudio.playSingleAudio(
                                          playerController, _isPlaying, path!);
                                    },
                                    child: Icon(_isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow),
                                  )
                                : InkWell(
                                    onTap: () {
                                      checkInternet(
                                        context: context,
                                        function: () async {
                                          path = null;

                                          if (path == null) {
                                            try {
                                              isLoading = true;
                                              Get.find<FeedDBController>()
                                                  .uiUpdate();
                                              print(
                                                  "start working ----------- 1");
                                              // await Get.find<DBController>()
                                              //     .
                                              await dowloadMediaToDB(
                                                      messageId:
                                                          widget.messageId,
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
                                                  print(
                                                      "start working ----------- $path");
                                                },
                                              ).then(
                                                (value) async {
                                                  print(
                                                      "start working ----------- 4");
                                                  print(
                                                      "start working ----------- 4 --- $path");

                                                  await audioS
                                                      .setSourceDeviceFile(
                                                          path!);

                                                  _audioDuration = await audioS
                                                      .getDuration();
                                                  print(
                                                      "start working ----------- $_audioDuration");

                                                  totalDuration =
                                                      _audioDuration;
                                                  print(
                                                      "start working ----------- 5");
                                                  await Controller
                                                      .dowloadAudioWaveDataToDB(
                                                          messageId:
                                                              widget.messageId,
                                                          audioData: [],
                                                          duration:
                                                              _audioDuration!
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
                                              print(
                                                  "start working ----------- $e");
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
                    path != null &&
                            _audioDuration != null &&
                            totalDuration != null
                        ? Expanded(
                            child: SliderTheme(
                              data: SliderThemeData(
                                thumbColor: Colorutils.userdetailcolor,
                                activeTrackColor: Colorutils.userdetailcolor,
                                trackHeight: 1.h,
                                thumbShape: RoundSliderThumbShape(
                                    enabledThumbRadius: 8.h),
                              ),
                              child: Slider(
                                min: 0,
                                max: totalDuration!.inMilliseconds.toDouble(),
                                value:
                                    _audioDuration!.inMilliseconds.toDouble(),
                                onChanged: (value) {
                                  final newPosition =
                                      Duration(milliseconds: value.toInt());
                                  playerController
                                      .seekTo(newPosition.inMilliseconds);
                                  // _audioPlayer.seek(newPosition); // Seek to the new position
                                },
                              ),
                            ),
                          )
                        : Expanded(
                            child: SliderTheme(
                              data: SliderThemeData(
                                thumbColor: Colorutils.userdetailcolor,
                                trackHeight: 1.h,
                                thumbShape: RoundSliderThumbShape(
                                    enabledThumbRadius: 8.h),
                              ),
                              child: Slider(
                                value: 0,
                                onChanged: (value) {},
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
                                  style: TeacherAppFonts.interW600_14sp_letters1
                                      .copyWith(color: Colorutils.black),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox()
                  ],
                ),
                hSpace(5.h),
                Text(widget.content.split('/').last,
                    style:
                        TeacherAppFonts.interW400_12sp_topicbackground.copyWith(
                      color: Colorutils.black,
                    ))
              ],
            ),
          ),
        );
      }),
    );
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

  Future<void> dowloadMediaToDB({
    required String messageId,
    required String url,
    required String type,
  }) async {
    String mediaTableName = "mediatable$type";

    await Get.find<FeedDBController>().db.execute('''
    CREATE TABLE IF NOT EXISTS $mediaTableName (
     id INTEGER PRIMARY KEY AUTOINCREMENT,
      filePath TEXT,
      message_id TEXT,
      file_name TEXT UNIQUE, 
      file_url TEXT,
      type TEXT
     )
    ''');
    final fileName = url.split("/").last;
    final path = await downloadFile(url, fileName);

    Map<String, dynamic> values = {
      'filePath': path,
      'message_id': messageId,
      'file_name': fileName,
      'file_url': url,
      'type': type
    };

    await Get.find<FeedDBController>().db.insert(
          mediaTableName,
          values,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
  }

  Future<String> downloadFile(String url, String fileName) async {
    await requestStoragePermission(); // Ensure storage permission is granted

    try {
      // Define the download directory and create a new folder if it doesn't exist
      // Directory downloadDirectory = Directory('/storage/emulated/0/Download');
      Directory? downloadDirectory = await getApplicationDocumentsDirectory();
      Directory schoolDiaryFolder =
          Directory('${downloadDirectory.path}/School Diary');

      // Create the SchoolDiary folder
      if (!(await schoolDiaryFolder.exists())) {
        await schoolDiaryFolder.create(recursive: true);
      }

      // Set the path where the file will be saved
      String savePath = '${schoolDiaryFolder.path}/$fileName';

      // Download the file from the URL
      var response = await Dio().download(
        url,
        savePath,
        onReceiveProgress: (count, total) {
          double value = count / total * 100;
          widget.progress.value = value;
          // ChangeNotifier();

          // print(
          // "on receive progress ====================== $count  and $total = $value %");
          print(
              "on receive progress ====================== ${widget.progress.value}%");
        },
      );

      // Check if the download was successful
      if (response.statusCode == 200) {
        print('File downloaded to: $savePath');
        // Notify the media scanner to make the file visible in the gallery
        // await _scanFile(savePath);
      } else {
        print('Failed to download file: ${response.statusCode}');
      }

      return savePath; // Return the path of the downloaded file
    } catch (e) {
      print('Failed to download file: $e');
      throw e; // Rethrow the error for further handling
    }
  }
}
