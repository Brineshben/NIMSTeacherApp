import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:teacherapp/Controller/db_controller/Feed_db_controller.dart';
import 'package:teacherapp/Services/common_services.dart';
import 'package:teacherapp/Utils/Colors.dart';
import 'package:teacherapp/Utils/constant_function.dart';
import 'package:sqflite/sqflite.dart';

import '../../../Utils/font_util.dart';

class FileWidget1 extends StatefulWidget {
  FileWidget1({
    super.key,
    required this.fileName,
    required this.fileType,
    required this.fileLink,
    required this.messageId,
  });

  final String fileName;
  final String fileType;
  final String fileLink;
  final String messageId;
  ValueNotifier<double> progress = ValueNotifier(0.0);

  @override
  State<FileWidget1> createState() => _FileWidget1State();
}

class _FileWidget1State extends State<FileWidget1> {
  String? path;

  String? previousPath;

  bool isLoading = false;
  String appZize = "";

  @override
  void didUpdateWidget(covariant FileWidget1 oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    previousPath = previousPath;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        // Get.find<DBController>().uiUpdate();
        path = await Get.find<FeedDBController>()
            .getFilePathByFileName(url: widget.fileLink, type: "file");

        if (path != null) {
          appZize = await getFormattedFileSize(path!);
        }

        Get.find<FeedDBController>().uiUpdate();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        // Get.find<DBController>().uiUpdate();
        if (previousPath == null) {
          path = await Get.find<FeedDBController>()
              .getFilePathByFileName(url: widget.fileLink, type: "file");
          if (path != null) {
            appZize = await getFormattedFileSize(path!);
          }

          Get.find<FeedDBController>().uiUpdate();
        }
      },
    );

    return Material(
      color: Colorutils.transparent,
      child: InkWell(
        onTap: () async {
          // await launchUrlString(fileLink);
          if (path == null) {
            checkInternet(
              context: context,
              function: () async {
                isLoading = true;
                Get.find<FeedDBController>().uiUpdate();
                // await Get.find<FeedDBController>().
                await dowloadMediaToDB(
                    messageId: widget.messageId,
                    url: widget.fileLink,
                    type: "file");
                path = await Get.find<FeedDBController>()
                    .getFilePathByFileName(url: widget.fileLink, type: "file");
                if (path != null) {
                  appZize = await getFormattedFileSize(path!);
                }

                isLoading = false;
                Get.find<FeedDBController>().uiUpdate();
              },
            );
          } else {
            try {
              await OpenFile.open(path);
              print("object $path");
            } catch (e) {
              print("object error $e");
            }
          }
        },
        child: IntrinsicHeight(
          child: Container(
            width: 230.w,
            // height: 50,
            decoration: BoxDecoration(
              color: Colorutils.fontColor17,
              borderRadius: BorderRadius.circular(10.h),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  Container(
                    width: 35.w,
                    height: 40.w,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage("assets/images/new-document.png"),
                      ),
                    ),
                    // child: Center(
                    //   child: Text(
                    //     widget.fileType,
                    //     style: TeacherAppFonts.interW500_10sp_userdetailcolor,
                    //   ),
                    // ),
                  ),
                  wSpace(5),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          widget.fileName,
                          style: TeacherAppFonts.interW400_16sp_letters1
                              .copyWith(color: Colorutils.black),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          children: [
                            Text(
                              appZize,
                              style: TeacherAppFonts.interW500_12sp_textWhite
                                  .copyWith(
                                fontSize: 10.sp,
                                color: Colors.black.withOpacity(0.25),
                              ),
                            ),
                            Text(
                              widget.fileType.toUpperCase(),
                              style: TeacherAppFonts.interW500_12sp_textWhite
                                  .copyWith(
                                fontSize: 10.sp,
                                color: Colors.black.withOpacity(0.25),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  wSpace(5),
                  GetBuilder<FeedDBController>(
                    builder: (controller) {
                      return path != null
                          ? const SizedBox()
                          : isLoading
                              ? SizedBox(
                                  width: 35.w,
                                  height: 35.w,
                                  child: Center(
                                    child: SizedBox(
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
                                              CircularProgressIndicator(
                                                value: value /
                                                    100, // Use the progress value (0.0 to 1.0)
                                                strokeWidth: 2.0,
                                                valueColor:
                                                    const AlwaysStoppedAnimation<
                                                        Color>(Colors.blue),
                                                backgroundColor: Colors.white,
                                              ),
                                              Center(
                                                  child: Text(
                                                "${value.toStringAsFixed(0)}%",
                                                style: TeacherAppFonts
                                                    .interW400_8sp_textWhite
                                                    .copyWith(
                                                        color: Colors.blue),
                                              ))
                                            ],
                                          );
                                        },
                                      ),
                                      //  const CircularProgressIndicator(
                                      //   strokeWidth: 2,
                                      // ),
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  width: 35.w,
                                  height: 35.w,
                                  // decoration: const BoxDecoration(
                                  //   image: DecorationImage(
                                  //     fit: BoxFit.fill,
                                  //     image: AssetImage("assets/png/new-document.png"),
                                  //   ),
                                  // ),
                                  child: Icon(
                                    Icons.download_rounded,
                                    color: Colors.black.withOpacity(0.25),
                                  ),
                                );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
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

class FileWidget2 extends StatefulWidget {
  FileWidget2({
    super.key,
    required this.fileName,
    required this.fileType,
    required this.fileLink,
    required this.messageId,
  });

  final String fileName;
  final String fileType;
  final String fileLink;
  final String messageId;

  ValueNotifier<double> progress = ValueNotifier(0.0);

  @override
  State<FileWidget2> createState() => _FileWidget2State();
}

class _FileWidget2State extends State<FileWidget2> {
  String? path;

  String? previousPath;

  bool isLoading = false;
  String appZize = "";

  @override
  void didUpdateWidget(covariant FileWidget2 oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    previousPath = previousPath;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        // Get.find<DBController>().uiUpdate();
        path = await Get.find<FeedDBController>()
            .getFilePathByFileName(url: widget.fileLink, type: "file");
        if (path != null) {
          appZize = await getFormattedFileSize(path!);
        }

        Get.find<FeedDBController>().uiUpdate();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        // Get.find<DBController>().uiUpdate();
        if (previousPath == null) {
          path = await Get.find<FeedDBController>()
              .getFilePathByFileName(url: widget.fileLink, type: "file");
          if (path != null) {
            appZize = await getFormattedFileSize(path!);
          }

          Get.find<FeedDBController>().uiUpdate();
        }
      },
    );

    return Material(
      color: Colorutils.transparent,
      child: InkWell(
        onTap: () async {
          // await launchUrlString(fileLink);
          if (path == null) {
            checkInternet(
              context: context,
              function: () async {
                isLoading = true;
                Get.find<FeedDBController>().uiUpdate();
                // await Get.find<FeedDBController>().
                await dowloadMediaToDB(
                    messageId: widget.messageId,
                    url: widget.fileLink,
                    type: "file");
                path = await Get.find<FeedDBController>()
                    .getFilePathByFileName(url: widget.fileLink, type: "file");
                if (path != null) {
                  appZize = await getFormattedFileSize(path!);
                }

                isLoading = false;
                Get.find<FeedDBController>().uiUpdate();
              },
            );
          } else {
            try {
              await OpenFile.open(path);
              print("object $path");
            } catch (e) {
              print("object error $e");
            }
          }
        },
        child: IntrinsicHeight(
          child: Container(
            width: 230.w,
            // height: 50,
            decoration: BoxDecoration(
              color: Colorutils.replayBg,
              borderRadius: BorderRadius.circular(10.h),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  Container(
                    width: 35.w,
                    height: 40.w,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage("assets/images/new-document.png"),
                      ),
                    ),
                    // child: Center(
                    //   child: Text(
                    //     widget.fileType,
                    //     style: TeacherAppFonts.interW500_10sp_userdetailcolor,
                    //   ),
                    // ),
                  ),
                  wSpace(5),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          widget.fileName,
                          style: TeacherAppFonts.interW400_16sp_letters1
                              .copyWith(color: Colorutils.black),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          children: [
                            Text(
                              appZize,
                              style: TeacherAppFonts.interW500_12sp_textWhite
                                  .copyWith(
                                fontSize: 10.sp,
                                color: Colors.black.withOpacity(0.25),
                              ),
                            ),
                            Text(
                              widget.fileType.toUpperCase(),
                              style: TeacherAppFonts.interW500_12sp_textWhite
                                  .copyWith(
                                fontSize: 10.sp,
                                color: Colors.black.withOpacity(0.25),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  wSpace(5),
                  GetBuilder<FeedDBController>(
                    builder: (controller) {
                      return path != null
                          ? const SizedBox()
                          : isLoading
                              ? SizedBox(
                                  width: 35.w,
                                  height: 35.w,
                                  child: Center(
                                    child: SizedBox(
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
                                              CircularProgressIndicator(
                                                value: value /
                                                    100, // Use the progress value (0.0 to 1.0)
                                                strokeWidth: 2.0,
                                                valueColor:
                                                    const AlwaysStoppedAnimation<
                                                        Color>(Colors.blue),
                                                backgroundColor: Colors.white,
                                              ),
                                              Center(
                                                  child: Text(
                                                "${value.toStringAsFixed(0)}%",
                                                style: TeacherAppFonts
                                                    .interW400_8sp_textWhite
                                                    .copyWith(
                                                        color: Colors.blue),
                                              ))
                                            ],
                                          );
                                        },
                                      ),
                                      // const CircularProgressIndicator(
                                      //   strokeWidth: 2,
                                      // ),
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  width: 35.w,
                                  height: 35.w,
                                  // decoration: const BoxDecoration(
                                  //   image: DecorationImage(
                                  //     fit: BoxFit.fill,
                                  //     image: AssetImage("assets/png/new-document.png"),
                                  //   ),
                                  // ),
                                  child: Icon(
                                    Icons.download_rounded,
                                    color: Colors.black.withOpacity(0.25),
                                  ),
                                );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
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

// class FileWidget1 extends StatelessWidget {
//   const FileWidget1({
//     super.key,
//     required this.fileName,
//     required this.fileType,
//     required this.fileLink,
//   });

//   final String fileName;
//   final String fileType;
//   final String fileLink;

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: () async {
//           await launchUrlString(fileLink);
//         },
//         child: IntrinsicHeight(
//           child: Container(
//             width: 230.w,
//             // height: 50,
//             decoration: BoxDecoration(
//               color: Colorutils.fontColor17,
//               borderRadius: BorderRadius.circular(10.h),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(5.0),
//               child: Row(
//                 children: [
//                   Container(
//                     width: 30.w,
//                     height: 35.w,
//                     decoration: const BoxDecoration(
//                       image: DecorationImage(
//                         fit: BoxFit.fill,
//                         image: AssetImage("assets/images/new-document.png"),
//                       ),
//                     ),
//                     // child: Center(
//                     //   child: Text(
//                     //     fileType,
//                     //     style:
//                     //         TeacherAppFonts.interW500_12sp_textWhite.copyWith(
//                     //       fontSize: 10.sp,
//                     //       color: Colors.black,
//                     //     ),
//                     //   ),
//                     // ),
//                   ),
//                   SizedBox(width: 5.w),
//                   Expanded(
//                     child: Column(
//                       children: [
//                         Text(
//                           fileName,
//                           style: TeacherAppFonts.interW400_16sp_letters1
//                               .copyWith(color: Colors.black),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         Row(
//                           children: [
//                             Text(
//                               "1.2 MB.",
//                               style: TeacherAppFonts.interW500_12sp_textWhite
//                                   .copyWith(
//                                 fontSize: 10.sp,
//                                 color: Colors.black.withOpacity(0.25),
//                               ),
//                             ),
//                             Text(
//                               fileType.toUpperCase(),
//                               style: TeacherAppFonts.interW500_12sp_textWhite
//                                   .copyWith(
//                                 fontSize: 10.sp,
//                                 color: Colors.black.withOpacity(0.25),
//                               ),
//                             ),
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                   // Expanded(
//                   //     child: Text(
//                   //   fileName,
//                   //   style: TeacherAppFonts.interW400_16sp_letters1
//                   //       .copyWith(color: Colors.black),
//                   //   overflow: TextOverflow.ellipsis,
//                   // ))
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class FileWidget2 extends StatelessWidget {
//   const FileWidget2({
//     super.key,
//     required this.fileName,
//     required this.fileType,
//     required this.fileLink,
//   });

//   final String fileName;
//   final String fileType;
//   final String fileLink;

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: () async {
//           await launchUrlString(fileLink);
//         },
//         child: Container(
//           width: 230.w,
//           // height: 50,
//           decoration: BoxDecoration(
//             color: Colorutils.replayBg,
//             borderRadius: BorderRadius.circular(10.h),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(5.0),
//             child: Row(
//               children: [
//                 Container(
//                   width: 30.w,
//                   height: 35.w,
//                   decoration: const BoxDecoration(
//                     image: DecorationImage(
//                       fit: BoxFit.fill,
//                       image: AssetImage("assets/images/new-document.png"),
//                     ),
//                   ),
//                   // child: Center(
//                   //   child: Text(
//                   //     fileType,
//                   //     style: TeacherAppFonts.interW500_12sp_textWhite.copyWith(
//                   //       fontSize: 10.sp,
//                   //       color: Colors.black,
//                   //     ),
//                   //   ),
//                   // ),
//                 ),
//                 SizedBox(width: 5.w),
//                 Expanded(
//                   child: Column(
//                     children: [
//                       Text(
//                         fileName,
//                         style: TeacherAppFonts.interW400_16sp_letters1
//                             .copyWith(color: Colors.black),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       Row(
//                         children: [
//                           Text(
//                             "1.2 MB.",
//                             style: TeacherAppFonts.interW500_12sp_textWhite
//                                 .copyWith(
//                               fontSize: 10.sp,
//                               color: Colors.black.withOpacity(0.25),
//                             ),
//                           ),
//                           Text(
//                             fileType.toUpperCase(),
//                             style: TeacherAppFonts.interW500_12sp_textWhite
//                                 .copyWith(
//                               fontSize: 10.sp,
//                               color: Colors.black.withOpacity(0.25),
//                             ),
//                           ),
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
