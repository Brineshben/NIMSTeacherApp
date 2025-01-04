import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:teacherapp/Controller/api_controllers/chat_push_notification.dart';
import 'package:teacherapp/Controller/api_controllers/userAuthController.dart';
import 'package:teacherapp/Controller/db_controller/parent_db_controller.dart';
import 'package:teacherapp/Models/api_models/sent_msg_by_teacher_model.dart';
import 'package:teacherapp/Services/api_services.dart';
import 'package:teacherapp/Services/common_services.dart';
import 'package:teacherapp/Utils/Colors.dart';
import 'package:teacherapp/Utils/constant_function.dart';
import '../../Models/api_models/parent_chatting_model.dart';
import '../../Services/check_connectivity.dart';
import '../../Services/dialog_box.dart';
import '../../Services/snackBar.dart';

class ParentChattingController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoaded = false.obs;
  RxBool isError = false.obs;
  RxBool dbLoader = false.obs;
  bool isPeriodicFetching = false;
  RxList<ParentMsgData> chatMsgList = <ParentMsgData>[].obs;
  RxInt parentChatsUnreadCount = 0.obs;
  late Rx<AutoScrollController> parentChatScrollController;
  Rx<FocusNode> focusNode = FocusNode().obs;
  Rx<String?> isReplay = Rx(null);
  ParentMsgData replayMessage = ParentMsgData();
  RxString replayName = "".obs;
  Rx<String?> filePath = Rx(null);
  Rx<String?> audioPath = Rx(null);
  Rx<String?> cameraImagePath = Rx(null);
  RxList<String> filePathList = RxList([]);

  RxBool isSentLoading = false.obs;
  RxString ontype = "".obs;
  RxBool showAudioRecordWidget = false.obs;
  RxBool showAudioPlayingWidget = false.obs;
  ParentMsgData? seletedMsgData;
  String? lastMessageId;
  RxInt tabControllerIndex = 0.obs;

  late int chatMsgCount;
  int messageCount = 30;
  bool showScrollIcon = true;
  int? previousMessageListLenght;
  RxBool showLoaderMoreMessage = true.obs;
  bool isShowDialogShow = false;

  void resetStatus() {
    isLoading.value = false;
    isError.value = false;
  }

  Future<void> fetchParentMsgList(ParentChattingReqModel reqBody,
      BuildContext context, String subId) async {
    ParentChattingReqModel chattingReqModel = ParentChattingReqModel(
      teacherId: reqBody.teacherId,
      schoolId: reqBody.schoolId,
      classs: reqBody.classs,
      batch: reqBody.batch,
      parentId: reqBody.parentId,
      offset: 0,
      limit: chatMsgCount,
    );
    isLoading.value = true;
    isError.value = false;

    // for get message locally //
    chatMsgList.value = await Get.find<ParentDbController>().getAllMessages(
        parentId: reqBody.parentId ?? "",
        studentclass: reqBody.classs ?? "",
        batch: reqBody.batch ?? "");

    final unsentList = await Get.find<ParentDbController>().getUnSentMessage(
        teacherId: Get.find<UserAuthController>().userData.value.userId!,
        subId: subId,
        parentId: reqBody.parentId ?? "",
        className: reqBody.classs ?? "",
        batch: reqBody.batch ?? "");

    chatMsgList.value = [...unsentList.reversed, ...chatMsgList];
    if (chatMsgList.isNotEmpty) {
      chatMsgList.add(chatMsgList[chatMsgList.length - 1]);
    }
    if (chatMsgList.isEmpty) {
      dbLoader.value = true;
    }
    print("lust chat ----------------------- ${chatMsgList}");
    isLoading.value = false;
    await checkInternet(
      context: context,
      function: () async {
        try {
          Map<String, dynamic> resp = await ApiServices.getParentChatting(
              reqBodyData: chattingReqModel);
          if (resp['status']['code'] == 200) {
            ParentChattingModel parentChattingData =
                ParentChattingModel.fromJson(resp);
            parentChatsUnreadCount.value = parentChattingData.data?.count ?? 0;
            await Get.find<ParentDbController>().storeMessageDatatoDB(
                messageList: parentChattingData.data?.data ?? [],
                parentId: reqBody.parentId ?? "",
                studentclass: reqBody.classs ?? "",
                batch: reqBody.batch ?? "");
            chatMsgList.value = await Get.find<ParentDbController>()
                .getAllMessages(
                    parentId: reqBody.parentId ?? "",
                    studentclass: reqBody.classs ?? "",
                    batch: reqBody.batch ?? "");
            print("lust chat ----------------------- ${chatMsgList}");
            // chatMsgList.value = parentChattingData.data?.data ?? [];
            if (chatMsgList.isNotEmpty) {
              chatMsgList.add(chatMsgList[chatMsgList.length - 1]);
            }
            // chatMsgList.sort((a, b) => a.sendAt!.compareTo(b.sendAt!));
            // chatMsgList.sort((a, b) {
            //   DateTime dateA = DateTime.parse(a.sendAt!);
            //   DateTime dateB = DateTime.parse(b.sendAt!);
            //   return dateA.compareTo(dateB);
            // });
          }
          isLoaded.value = true;
        } catch (e) {
          isLoaded.value = false;
          isError.value = true;
          print('--------parent chatting error--------');
        } finally {
          isLoading.value = false;
          dbLoader.value = false;
        }
      },
    );

    isLoading.value = false;
    dbLoader.value = false;
  }

  Future<void> fetchParentMsgListPeriodically(
      ParentChattingReqModel reqBody) async {
    if (isPeriodicFetching) {
      return; // Prevent overlapping calls
    }

    isPeriodicFetching = true;

    ParentChattingReqModel chattingReqModel = ParentChattingReqModel(
      teacherId: reqBody.teacherId,
      schoolId: reqBody.schoolId,
      classs: reqBody.classs,
      batch: reqBody.batch,
      parentId: reqBody.parentId,
      offset: 0,
      limit: chatMsgCount,
    );
    ParentChattingModel? parentChatData;
    try {
      Map<String, dynamic> resp =
          await ApiServices.getParentChatting(reqBodyData: chattingReqModel);
      if (resp['status']['code'] == 200) {
        parentChatData = ParentChattingModel.fromJson(resp);
        parentChatsUnreadCount.value = parentChatData.data?.count ?? 0;
        // chatMsgList.value = parentChatData.data?.data ?? [];
        await Get.find<ParentDbController>().storeMessageDatatoDB(
            messageList: parentChatData.data?.data ?? [],
            parentId: reqBody.parentId ?? "",
            studentclass: reqBody.classs ?? "",
            batch: reqBody.batch ?? "");
        chatMsgList.value = await Get.find<ParentDbController>().getAllMessages(
            parentId: reqBody.parentId ?? "",
            studentclass: reqBody.classs ?? "",
            batch: reqBody.batch ?? "");

        if (chatMsgList.isNotEmpty) {
          chatMsgList.add(chatMsgList[chatMsgList.length - 1]);
        }
      }
    } catch (e) {
      print('--------parent chatting error--------');
    } finally {
      isPeriodicFetching = false;
    }
  }

  // Future<void> fetchParentMsgListPeriodically(
  //     ParentChattingReqModel reqBody) async {
  //   ParentChattingReqModel chattingReqModel = ParentChattingReqModel(
  //     teacherId: reqBody.teacherId,
  //     schoolId: reqBody.schoolId,
  //     classs: reqBody.classs,
  //     batch: reqBody.batch,
  //     parentId: reqBody.parentId,
  //     offset: 0,
  //     limit: chatMsgCount,
  //   );
  //   ParentChattingModel? parentChatData;
  //   try {
  //     Map<String, dynamic> resp =
  //         await ApiServices.getParentChatting(reqBodyData: chattingReqModel);
  //     if (resp['status']['code'] == 200) {
  //       parentChatData = ParentChattingModel.fromJson(resp);
  //       parentChatsUnreadCount.value = parentChatData.data?.count ?? 0;
  //       chatMsgList.value = parentChatData.data?.data ?? [];
  //       if (chatMsgList.isNotEmpty) {
  //         chatMsgList.add(chatMsgList[chatMsgList.length - 1]);
  //       }
  //     }
  //   } catch (e) {
  //     print('--------parent chatting error--------');
  //   }
  //   // ParentMsgData? lastMsg = parentChatData?.data?.data?.first;
  //   // String? newLastMessageId =
  //   //     "${lastMsg?.messageId}${lastMsg?.messageFromId}${lastMsg?.sendAt}";

  //   // parentChatsUnreadCount.value = parentChatData?.data?.count ?? 0;
  //   // chatMsgList.value = parentChatData?.data?.data ?? [];
  //   // if (chatMsgList.isNotEmpty) {
  //   //   chatMsgList.add(chatMsgList[chatMsgList.length - 1]);
  //   // }

  //   // if (lastMessageId == null || newLastMessageId != lastMessageId) {
  //   //   lastMessageId = newLastMessageId;
  //   //   parentChatsUnreadCount.value = parentChatData?.data?.count ?? 0;
  //   //   chatMsgList.value = parentChatData?.data?.data ?? [];
  //   //   // chatMsgList.sort((a, b) {
  //   //   //   DateTime dateA = DateTime.parse(a.sendAt!);
  //   //   //   DateTime dateB = DateTime.parse(b.sendAt!);
  //   //   //   return dateA.compareTo(dateB);
  //   //   // });
  //   //   // chatMsgList.sort(
  //   //   //   (a, b) => a.sendAt!.compareTo(b.sendAt!),
  //   //   // );
  //   //   // Future.delayed(
  //   //   //   const Duration(milliseconds: 50),
  //   //   //   () {
  //   //   //     parentChatScrollController.value.animateTo(
  //   //   //       parentChatScrollController.value.position.maxScrollExtent,
  //   //   //       duration: const Duration(milliseconds: 200),
  //   //   //       curve: Curves.easeOut,
  //   //   //     );
  //   //   //   },
  //   //   // );
  //   // }
  // }

  void fetchMoreMessage({required ParentChattingReqModel reqBody}) async {
    ParentChattingModel? chatFeedData;
    ParentChattingReqModel chatFeedViewReqModel = ParentChattingReqModel(
      teacherId: reqBody.teacherId,
      schoolId: reqBody.schoolId,
      classs: reqBody.classs,
      batch: reqBody.batch,
      parentId: reqBody.parentId,
      offset: 0,
      limit: chatMsgCount,
    );
    try {
      Map<String, dynamic> resp = await ApiServices.getParentChatting(
          reqBodyData: chatFeedViewReqModel);
      if (resp['status']['code'] == 200) {
        chatFeedData = ParentChattingModel.fromJson(resp);

        chatMsgList.value = chatFeedData.data?.data ?? [];
        print("Chat list -- worked----------------- ${chatMsgList.length}");
        if (chatMsgList.isNotEmpty) {
          chatMsgList.add(chatMsgList[chatMsgList.length - 1]);
        }
        if (previousMessageListLenght == null ||
            chatMsgList.length == previousMessageListLenght) {
          showLoaderMoreMessage.value = false;
          // print("working show no");
        } else {
          showLoaderMoreMessage.value = true;
          // print("working show");
        }
        previousMessageListLenght = chatMsgList.length;
      }
      update();
    } catch (e) {
      print("periodicGetMsgList Error :-------------- $e");
    }
  }

  /////////////////////////////
  selectAttachment({required BuildContext context}) async {
    filePath.value = null;
    bool connected = await CheckConnectivity().check();

    try {
      FilePickerResult? data = await FilePicker.platform
          .pickFiles(type: FileType.any, allowMultiple: true
              // allowedExtensions: [
              //   'pdf',
              //   'jpg',
              //   'jpeg',
              //   'png',
              //   'mp4',
              //   'mov',
              //   'avi',
              //   'mkv',
              //   'mp3',
              //   'wav',
              //   'opus',
              //   'm4a',
              // ],
              )
          .whenComplete(() {
        if (!connected) {
          snackBar(
              context: context,
              message: "No Internet Connection.",
              color: Colors.red);
        }
      });

      if (data != null) {
        List<File> result = data.paths.map((path) => File(path!)).toList();
        if (result.length == 1) {
          File file = File(result[0].path);

          int fileSizeInBytes = await file.length();

          if (fileSizeInBytes < 30 * 1024 * 1024) {
            filePath.value = result[0].path;
          } else {
            filePath.value = null;
            snackBar(
                context: context,
                message: "The selected file is above 30 MB",
                color: Colors.red);
          }
        } else if (result.length > 10) {
          snackBar(
              context: context,
              message: "You cannot select more than 10 attachments.",
              color: Colors.red);
        } else {
          if (result.isNotEmpty) {
            filePathList.value = [];
            for (final fileData in result) {
              File file = File(fileData.path);
              int fileSizeInBytes = await file.length();

              if (fileSizeInBytes < 30 * 1024 * 1024) {
                print("Loop working test");
                // filePath.value = result[0].path;

                filePathList.add(fileData.path);
              } else {
                filePath.value = null;
                snackBar(
                    context: context,
                    message:
                        "The selected file ${fileData.path} is above 30 MB",
                    color: Colors.red);
              }
            }
          }
        }
      }
    } catch (e) {
      print("selectAttachment Error :-------------- $e");
      if (await Permission.storage.status.isDenied ||
          await Permission.storage.status.isPermanentlyDenied) {
        await ShowWarnDialog()
            .showWarn(context: context, message: "Enable storage permission.");
      }
      print("--------_selectAttachment---------${e.toString()}");
    }
  }

  removeSelectedAttachment(int index) {
    filePathList.removeAt(index);
  }

  //////////////////////////////

  // selectAttachment({required BuildContext context}) async {
  //   bool connected = await CheckConnectivity().check();

  //   try {
  //     FilePickerResult? result = await FilePicker.platform
  //         .pickFiles(
  //       type: FileType.any,
  //       // allowedExtensions: [
  //       //   'pdf',
  //       //   'jpg',
  //       //   'jpeg',
  //       //   'png',
  //       //   'mp4',
  //       //   'mov',
  //       //   'avi',
  //       //   'mkv',
  //       //   'mp3',
  //       //   'wav',
  //       //   'opus',
  //       //   'm4a',
  //       // ],
  //     )
  //         .whenComplete(() {
  //       if (!connected) {
  //         snackBar(
  //             context: context,
  //             message: "No Internet Connection.",
  //             color: Colors.red);
  //       }
  //     });
  //     // const XTypeGroup typeGroup = XTypeGroup(
  //     //   label: 'images',
  //     //   extensions: <String>[
  //     //     // 'pdf',
  //     //     // 'jpg',
  //     //     // 'jpeg',
  //     //     // 'png',
  //     //     // 'mp4',
  //     //     // 'mov',
  //     //     // 'avi',
  //     //     // 'mkv',
  //     //     // 'mp3',
  //     //     // 'wav',
  //     //     // 'opus',
  //     //     // 'm4a',
  //     //     // 'xlsx',
  //     //     // 'xlsm',
  //     //     // 'xlsb',
  //     //     // 'xltx',
  //     //     // 'doc',
  //     //     // 'docm',
  //     //     // 'docx',
  //     //     // 'dot',
  //     //   ],
  //     // );

  //     // final File? result =
  //     // await openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup])
  //     //     .whenComplete(() {
  //     //   if (!connected) {
  //     //     snackBar(
  //     //         context: context,
  //     //         message: "No Internet Connection.",
  //     //         color: Colors.red);
  //     //   }
  //     // });

  //     if (result != null && result.files.isNotEmpty) {
  //       File file = File(result.files.first.path!);

  //       int fileSizeInBytes = await file.length();

  //       if (fileSizeInBytes < 30 * 1024 * 1024) {
  //         filePath.value = result.files.first.path!;
  //       } else {
  //         filePath.value = null;
  //         snackBar(
  //             context: context,
  //             message: "The selected file is above 30 MB",
  //             color: Colors.red);
  //       }
  //     }
  //   } catch (e) {
  //     print("selectAttachment Error :-------------- $e");
  //     if (await Permission.storage.status.isDenied ||
  //         await Permission.storage.status.isPermanentlyDenied) {
  //       await ShowWarnDialog()
  //           .showWarn(context: context, message: "Enable storage permission.");
  //     }
  //     print("--------_selectAttachment---------${e.toString()}");
  //   }
  // }

  Future<bool> permissionCheck(context) async {
    PermissionStatus cameraPermissionStatus = await Permission.camera.status;
    // PermissionStatus micPermissionStatus = await Permission.microphone.status;

    if (cameraPermissionStatus.isGranted) {
      return true;
    } else if (cameraPermissionStatus.isDenied) {
      await Permission.camera.request();
      cameraPermissionStatus = await Permission.camera.status;
      if (!cameraPermissionStatus.isGranted) {
        await ShowWarnDialog().showWarn(
          context: context,
          message: 'Enable camera access.',
          iconData: Icons.camera_alt,
          isCameraPage: false,
        );
      }
    }
    // else if (micPermissionStatus.isDenied) {
    //   await Permission.microphone.request();
    //   micPermissionStatus = await Permission.microphone.status;
    //   if (!micPermissionStatus.isGranted) {
    //     await ShowWarnDialog().showWarn(
    //       context: context,
    //       message: 'Audio access denied.',
    //       iconData: Icons.mic,
    //       isCameraPage: false,
    //     );
    //   }
    // }
    else {
      if (cameraPermissionStatus.isPermanentlyDenied) {
        await ShowWarnDialog().showWarn(
          context: context,
          message: 'Enable camera access.',
          iconData: Icons.camera_alt,
          isCameraPage: false,
        );
      }
      // else if (micPermissionStatus.isPermanentlyDenied) {
      //   await ShowWarnDialog().showWarn(
      //     context: context,
      //     message: 'Audio access denied.',
      //     iconData: Icons.mic,
      //     isCameraPage: false,
      //   );
      // }
    }
    return false;
  }

  Future<dynamic> sendAttachMsg({
    required BuildContext context,
    required SentMsgByTeacherModel sentMsgData,
  }) async {
    print(
        "Arun Msg Sent working ------------------------------${sentMsgData.toJson()}");

    try {
      Map<String, dynamic> resp = await ApiServices.sentMsgByTeacher(
        teacherMsg: sentMsgData,
      );

      if (resp['status']['code'] == 200) {
        // await Get.find<PushNotificationController>().sendNotification(
        //     teacherId: sentMsgData.messageFrom ?? "",
        //     message: sentMsgData.message,
        //     teacherName:
        //         Get.find<UserAuthController>().userData.value.name ?? "",
        //     teacherImage:
        //         Get.find<UserAuthController>().userData.value.image ?? "",
        //     messageFrom: sentMsgData.messageFrom ?? "",
        //     studentClass: sentMsgData.classs ?? "",
        //     batch: sentMsgData.batch ?? "",
        //     subId: sentMsgData.subjectId ?? "",
        //     subjectName: sentMsgData.subject ?? "",
        //     fileName: sentMsgData.fileData?.name ?? "",
        //     parentData: [
        //       {"parent_id": sentMsgData.parents?.first ?? "", "student_id": ""}
        //     ]);
        audioPath.value = null;
        filePath.value = null;
        showAudioRecordWidget.value =
            false; // for hiding the audio recording widget //
        showAudioPlayingWidget.value =
            false; // for hiding the audio playing widget //
        isReplay.value = null;
      } else {
        snackBar(
            context: context,
            // message: "Something went wrong.",
            message: resp['data']['message'],
            color: Colors.red);
      }
      isSentLoading.value = false;
      print("------msg-------$resp");
    } catch (e) {
      print("sendAttachMsg Error :-------------- $e");
      snackBar(
          context: context,
          message: "Something went wrong.",
          color: Colors.red);
      isSentLoading.value = false;
    }
  }

  Future<dynamic> sendAttach(
      {required BuildContext context,
      required String classs,
      required String batch,
      required String subId,
      required String sub,
      required String teacherId,
      required List<String>? parent,
      filePath,
      String? message}) async {
    try {
      Map<String, dynamic> resp =
          await ApiServices.sendAttachment(filePath: filePath);

      print("---------respdata------------$resp");

      if (resp['status']['code'] == 200) {
        SentMsgByTeacherModel sentMsgByTeacherModel = SentMsgByTeacherModel(
          subjectId: subId,
          batch: batch,
          classs: classs,
          message: message,
          messageFrom: teacherId,
          subject: sub,
          replyId: isReplay.value,
          parents: parent,
          fileData: FileData(
            name: resp['data']['file_data']['name'],
            orgName: resp['data']['file_data']['org_name'],
            extension: resp['data']['file_data']['extension'],
          ),
        );
        await sendAttachMsg(
          context: context,
          sentMsgData: sentMsgByTeacherModel,
        );
      }
      isSentLoading.value = false;
    } catch (e) {
      print("sendAttach Error :-------------- $e");
      snackBar(
          context: context,
          message: "Something went wrong.",
          color: Colors.red);
      isSentLoading.value = false;
    }
  }

  Future<dynamic> deleteMsg({
    int? msgId,
    String? teacherId,
    required BuildContext context,
  }) async {
    try {
      var resp = await ApiServices.deleteSenderMsg(
          msgId: msgId!, teacherId: teacherId!);
      if (resp['status']['code'] == 200) {
        print("-----resp-----$resp");
        snackBar(
            context: context,
            message: resp['data']['message'],
            color: Colors.green);
        Navigator.pop(context);
      }
    } catch (e) {
      print("Delete message Error :-------------- $e");
    }
  }

  bool showDelete(String dateTimeString) {
    try {
      // Parse the given date time string
      DateTime messageTime = DateTime.parse(dateTimeString);

      // Get the current time
      DateTime now = DateTime.now();

      // Calculate the difference in time
      Duration difference = now.difference(messageTime);

      // Check if the difference is less than 15 minutes
      return difference.inMinutes < 15;
    } catch (e) {
      return false;
    }
  }

  void focusTextField() {
    if (focusNode.value.hasFocus) {
      focusNode.value = FocusNode();
    }
    focusNode.value.requestFocus();
  }

  Future<int?> findMessageIndex({
    required ParentChattingReqModel reqBody,
    required int? msgId,
  }) async {
    print(reqBody.limit);
    // chatMsgCount = 1000;
    await fetchParentMsgListPeriodically(reqBody);
    print(chatMsgList.length);
    for (int i = 0; i < chatMsgList.length; i++) {
      ParentMsgData element = chatMsgList[i];

      if (element.messageId == msgId.toString()) {
        print("message number = i = $i");
        return i;
      }
    }
    return null;
  }

  setScrollerIcon() {
    update(); // for showing scroll indicator for go down side of chat list
  }

  List<TextSpan> getMessageText(
      {required String text, required BuildContext context}) {
    const urlPattern =
        r'((https?:\/\/)?(?:www\.)?[^\s]+(?:\.[^\s]+)+(?:\/[^\s]*)?)';
    // const urlPattern =
    //     r'((https?:\/\/)?(www\.)?[a-zA-Z0-9-]+\.(com|org|net|edu|gov|mil|int|info|biz|co|us|io|me|in)([\/\w\-.?&=%#]*)?)';
    final regex = RegExp(urlPattern);
    final matches = regex.allMatches(text);

    final List<TextSpan> spans = [];
    int lastMatchEnd = 0;

    for (final match in matches) {
      final url = match.group(0)!;
      final String formattedUrl;

      // Check if the URL starts with a scheme (http:// or https://)
      if (url.startsWith('http://') || url.startsWith('https://')) {
        formattedUrl = url;
      } else {
        // If not, prepend "https://" to the URL
        formattedUrl = 'https://$url';
      }

      // Add text before the URL
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(text: text.substring(lastMatchEnd, match.start)));
      }

      // Add the URL as a clickable span
      spans.add(
        TextSpan(
          text: url,
          style: const TextStyle(
            color: Colorutils.letters1,
            decoration: TextDecoration.underline,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              openUrl(message: formattedUrl, context: context);
            },
        ),
      );

      lastMatchEnd = match.end;
    }

    // Add any remaining text after the last URL
    if (lastMatchEnd < text.length) {
      spans.add(
        TextSpan(text: text.substring(lastMatchEnd)),
      );
    }

    return spans;
  }
}
