import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:teacherapp/Controller/api_controllers/chat_push_notification.dart';
import 'package:teacherapp/Controller/api_controllers/userAuthController.dart';
import 'package:teacherapp/Controller/db_controller/Feed_db_controller.dart';
import 'package:teacherapp/Models/api_models/sent_msg_by_teacher_model.dart';
import 'package:teacherapp/Services/api_services.dart';
import 'package:teacherapp/Services/common_services.dart';
import 'package:teacherapp/Utils/Colors.dart';
import 'package:teacherapp/Utils/constant_function.dart';
import '../../Models/api_models/chat_feed_view_model.dart';
import '../../Models/api_models/parent_list_api_model.dart';
import '../../Services/check_connectivity.dart';
import '../../Services/dialog_box.dart';
import '../../Services/snackBar.dart';

class FeedViewController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoaded = false.obs;
  RxBool isError = false.obs;
  RxBool dbLoader = false.obs;
  bool isPeriodicFetching = false;
  // Rx<ChatFeedViewModel> chatFeedData = ChatFeedViewModel().obs;
  Rx<ParentListApiModel> parentListApiData = ParentListApiModel().obs;
  RxList<MsgData> chatMsgList = RxList([]);
  RxList<ParentData> parentDataList = <ParentData>[].obs;
  // RxList<ParentData> parentDataListCopy = <ParentData>[].obs;
  // RxList<String> allParentDataList = <String>[].obs;
  RxList<ParentDataSelected> tempList = <ParentDataSelected>[].obs;
  RxList<ParentDataSelected> selectedParentDataList =
      <ParentDataSelected>[].obs;
  RxList<ParentDataSelected> selectedParentDataStack =
      <ParentDataSelected>[].obs;
  RxList<ParentDataSelected> showSelectedParentDataStack =
      <ParentDataSelected>[].obs;
  // RxList<ParentDataSelected> selectedParentDataListCopy = <ParentDataSelected>[].obs;
  // RxList<String> finalParentDataList = <String>[].obs;
  RxInt feedUnreadCount = 0.obs;
  late Rx<AutoScrollController> chatFeedViewScrollController;

  Rx<FocusNode> focusNode = FocusNode().obs;
  Rx<String?> isReplay = Rx(null);
  MsgData replayMessage = MsgData();
  RxString replayName = "".obs;
  Rx<String?> filePath = Rx(null);
  Rx<String?> audioPath = Rx(null);
  Rx<String?> cameraImagePath = Rx(null);
  RxList<String> filePathList = RxList([]);

  RxBool isSentLoading = false.obs;
  RxString ontype = "".obs;
  RxBool showAudioRecordWidget = false.obs;
  RxBool showAudioPlayingWidget = false.obs;
  MsgData? seletedMsgData;
  String? lastMessageId;
  RxInt tabControllerIndex = 0.obs;
  RxInt selectedParentCount = 0.obs; // for showing selected parent count //
  RxBool showSelectAllIcon = true.obs; // for showing selected parent count //

  late int chatMsgCount;
  int messageCount = 30;
  bool showScrollIcon = true;
  int? previousMessageListLenght;
  RxBool showLoaderMoreMessage = true.obs;
  bool isShowDialogShow = false;

  @override
  void onClose() {
    chatFeedViewScrollController.value.dispose();
    super.onClose();
  }

  // void resetStatus() {
  //   isLoading.value = false;
  //   isError.value = false;
  // }

  // Future<void> fetchFeedViewMsgList(ChatFeedViewReqModel reqBody) async {
  //   isLoading.value = true;
  //   isError.value = false;
  //   ChatFeedViewReqModel chatFeedViewReqModel = ChatFeedViewReqModel(
  //     teacherId: reqBody.teacherId,
  //     schoolId: reqBody.schoolId,
  //     classs: reqBody.classs,
  //     batch: reqBody.batch,
  //     subjectId: reqBody.subjectId,
  //     offset: 0,
  //     limit: Get.find<FeedViewController>().chatMsgCount,
  //   );

  //   final messageList1 = await Get.find<FeedDBController>().getAllMessages(
  //       batch: reqBody.batch ?? "",
  //       studentclass: reqBody.classs ?? "",
  //       subId: reqBody.subjectId ?? "");
  //   final unsentList = [];
  //   //await Get.find<FeedDBController>()
  //   //     .getUnSentMessage(teacherId: teacherId, subId: subId);

  //   chatMsgList.value = [...unsentList.reversed, ...messageList1];
  //   if (chatMsgList.isNotEmpty) {
  //     chatMsgList.add(chatMsgList[chatMsgList.length - 1]);
  //   }
  //   isLoading.value = false;

  //   try {
  //     Map<String, dynamic> resp =
  //         await ApiServices.getChatFeedView(reqBodyData: chatFeedViewReqModel);
  //     if (resp['status']['code'] == 200) {
  //       ChatFeedViewModel chatFeedData = ChatFeedViewModel.fromJson(resp);
  //       feedUnreadCount.value = chatFeedData.data?.count ?? 0;
  //       chatMsgList.value = chatFeedData.data?.data ?? [];
  //       if (chatMsgList.isNotEmpty) {
  //         chatMsgList.add(chatMsgList[chatMsgList.length - 1]);
  //         print("Chat list -- worked----------------- ${chatMsgList.length}");
  //       }
  //       update();
  //     }
  //     await fetchParentList(
  //       classs: reqBody.classs ?? '--',
  //       batch: reqBody.batch ?? '--',
  //       subId: reqBody.subjectId ?? '--',
  //       schoolId: reqBody.schoolId ?? '--',
  //     );
  //     isLoaded.value = true;
  //   } catch (e) {
  //     isLoaded.value = false;
  //     isError.value = true;
  //     print('--------feed view error--------');
  //   } finally {
  //     isLoading.value = false;
  //     print("Finaly worked");
  //   }
  // }

  Future<void> fetchFeedViewMsgList(
      ChatFeedViewReqModel reqBody, BuildContext context) async {
    isLoading.value = true;
    isError.value = false;
    ChatFeedViewReqModel chatFeedViewReqModel = ChatFeedViewReqModel(
      teacherId: reqBody.teacherId,
      schoolId: reqBody.schoolId,
      classs: reqBody.classs,
      batch: reqBody.batch,
      subjectId: reqBody.subjectId,
      offset: 0,
      limit: Get.find<FeedViewController>().chatMsgCount,
    );

    final messageList1 = await Get.find<FeedDBController>().getAllMessages(
        batch: reqBody.batch ?? "",
        studentclass: reqBody.classs ?? "",
        subId: reqBody.subjectId ?? "");

    final unsentList = await Get.find<FeedDBController>().getUnSentMessage(
        studentclass: reqBody.classs ?? "",
        batch: reqBody.batch ?? "",
        subId: reqBody.subjectId ?? "");

    chatMsgList.value = [...unsentList.reversed, ...messageList1];
    if (chatMsgList.isNotEmpty) {
      chatMsgList.add(chatMsgList[chatMsgList.length - 1]);
    }

    if (chatMsgList.isEmpty) {
      dbLoader.value = true;
    }
    isLoading.value = false;

    await checkInternetWithReturnBool(
      context: context,
      function: () async {
        try {
          Map<String, dynamic> resp = await ApiServices.getChatFeedView(
              reqBodyData: chatFeedViewReqModel);
          if (resp['status']['code'] == 200) {
            ChatFeedViewModel chatFeedData = ChatFeedViewModel.fromJson(resp);
            print(
                "Chat list -- worked----------------- ${chatFeedData.data?.data}");

            feedUnreadCount.value = chatFeedData.data?.count ?? 0;
            // chatMsgList.value = chatFeedData.data?.data ?? [];
            await Get.find<FeedDBController>().storeMessageDatatoDB(
                messageList: chatFeedData.data?.data ?? [],
                subId: reqBody.subjectId ?? "",
                studentclass: reqBody.classs ?? "",
                batch: reqBody.batch ?? "");
            chatMsgList.value = await Get.find<FeedDBController>()
                .getAllMessages(
                    subId: reqBody.subjectId ?? "",
                    studentclass: reqBody.classs ?? "",
                    batch: reqBody.batch ?? "");
            print("Chat list -- worked----------------- ${chatMsgList.length}");
            if (chatMsgList.isNotEmpty) {
              chatMsgList.add(chatMsgList[chatMsgList.length - 1]);
              print(
                  "Chat list -- worked----------------- ${chatMsgList.length}");
            }
            // update();
          }
          // await fetchParentList(
          //   classs: reqBody.classs ?? '--',
          //   batch: reqBody.batch ?? '--',
          //   subId: reqBody.subjectId ?? '--',
          //   schoolId: reqBody.schoolId ?? '--',
          // );
          // isLoaded.value = false;
        } catch (e) {
          isLoaded.value = false;
          isError.value = true;
          print('--------feed view error--------');
        } finally {
          dbLoader.value = false;
          isLoading.value = false;
          print("Finaly worked");
        }
      },
    );
    dbLoader.value = false;
    isLoading.value = false;
    // .then(
    //   (value) async {
    //     final messageList1 = await Get.find<FeedDBController>().getAllMessages(
    //         batch: reqBody.batch ?? "",
    //         studentclass: reqBody.classs ?? "",
    //         subId: reqBody.subjectId ?? "");

    //     final unsentList = await Get.find<FeedDBController>().getUnSentMessage(
    //         studentclass: reqBody.classs ?? "",
    //         batch: reqBody.batch ?? "",
    //         subId: reqBody.subjectId ?? "");

    //     chatMsgList.value = [...unsentList.reversed, ...messageList1];
    //     if (chatMsgList.isNotEmpty) {
    //       chatMsgList.add(chatMsgList[chatMsgList.length - 1]);
    //     }

    //     dbLoader.value = false;
    //     isLoading.value = false;
    //   },
    // );
  }

  Future<void> fetchFeedViewMsgListPeriodically(
      ChatFeedViewReqModel reqBody) async {
    if (isPeriodicFetching) {
      return; // Prevent overlapping calls
    }

    isPeriodicFetching = true;

    ChatFeedViewModel? chatFeedData;
    ChatFeedViewReqModel chatFeedViewReqModel = ChatFeedViewReqModel(
      teacherId: reqBody.teacherId,
      schoolId: reqBody.schoolId,
      classs: reqBody.classs,
      batch: reqBody.batch,
      subjectId: reqBody.subjectId,
      offset: 0,
      limit: Get.find<FeedViewController>().chatMsgCount,
    );
    try {
      Map<String, dynamic> resp =
          await ApiServices.getChatFeedView(reqBodyData: chatFeedViewReqModel);
      if (resp['status']['code'] == 200) {
        chatFeedData = ChatFeedViewModel.fromJson(resp);
        feedUnreadCount.value = chatFeedData.data?.count ?? 0;
        // chatMsgList.value = chatFeedData.data?.data ?? [];
        // chatMsgList.value = chatFeedData.data?.data ?? [];
        await Get.find<FeedDBController>().storeMessageDatatoDB(
            messageList: chatFeedData.data?.data ?? [],
            subId: reqBody.subjectId ?? "",
            studentclass: reqBody.classs ?? "",
            batch: reqBody.batch ?? "");
        chatMsgList.value = await Get.find<FeedDBController>().getAllMessages(
            subId: reqBody.subjectId ?? "",
            studentclass: reqBody.classs ?? "",
            batch: reqBody.batch ?? "");

        print("chat list lenght ---------------------- ${chatMsgList.length}");

        if (chatMsgList.isNotEmpty) {
          chatMsgList.add(chatMsgList[chatMsgList.length - 1]);
        }
      }
    } catch (e) {
      print('--------feed view error--------');
    } finally {
      isPeriodicFetching = false;
      // feedUnreadCount.value = chatFeedData?.data?.count ?? 0;
      // chatMsgList.value = chatFeedData?.data?.data ?? [];

      // print("chat list lenght ---------------------- ${chatMsgList.length}");

      // if (chatMsgList.isNotEmpty) {
      //   chatMsgList.add(chatMsgList[chatMsgList.length - 1]);
      // }
      // }
      // update();
    }
  }

  void fetchMoreMessage({required ChatFeedViewReqModel reqBody}) async {
    ChatFeedViewModel? chatFeedData;
    ChatFeedViewReqModel chatFeedViewReqModel = ChatFeedViewReqModel(
      teacherId: reqBody.teacherId,
      schoolId: reqBody.schoolId,
      classs: reqBody.classs,
      batch: reqBody.batch,
      subjectId: reqBody.subjectId,
      offset: 0,
      limit: Get.find<FeedViewController>().chatMsgCount,
    );
    try {
      Map<String, dynamic> resp =
          await ApiServices.getChatFeedView(reqBodyData: chatFeedViewReqModel);
      if (resp['status']['code'] == 200) {
        chatFeedData = ChatFeedViewModel.fromJson(resp);

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
    print("Arun Msg Sent working ------------------------------");

    try {
      Map<String, dynamic> resp = await ApiServices.sentMsgByTeacher(
        teacherMsg: sentMsgData,
      );

      if (resp['status']['code'] == 200) {
        Get.find<PushNotificationController>().sendNotification(
            teacherId: sentMsgData.messageFrom ?? "",
            message: sentMsgData.message,
            teacherName:
                Get.find<UserAuthController>().userData.value.name ?? "",
            teacherImage:
                Get.find<UserAuthController>().userData.value.image ?? "",
            messageFrom: sentMsgData.messageFrom ?? "",
            studentClass: sentMsgData.classs ?? "",
            batch: sentMsgData.batch ?? "",
            subId: sentMsgData.subjectId ?? "",
            subjectName: sentMsgData.subject ?? "",
            fileName: sentMsgData.fileData?.name ?? "",
            parentData: setFinalParentListForNotification());
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
      // for updating list after sent msg //
      await fetchFeedViewMsgListPeriodically(ChatFeedViewReqModel(
          classs: sentMsgData.classs ?? "",
          batch: sentMsgData.batch ?? "",
          teacherId: sentMsgData.messageFrom ?? "",
          subjectId: sentMsgData.subjectId ?? "",
          schoolId:
              Get.find<UserAuthController>().userData.value.schoolId ?? "",
          offset: 0,
          limit: Get.find<FeedViewController>().chatMsgCount));

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
      filePath,
      String? message}) async {
    // print("--------rgte4ght------------${finalParentDataList.length}");
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
          parents: setFinalParentList(),
          subject: sub,
          replyId: isReplay.value,
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
      print("delete -------------- msg id - $msgId , teacher id - $teacherId");
      var resp = await ApiServices.deleteSenderMsg(
          msgId: msgId!, teacherId: teacherId!);
      if (resp['status']['code'] == 200) {
        print("delete success");
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

  selectedDoneFunction() {
    showSelectedParentDataStack.value = [];
    for (ParentDataSelected element in selectedParentDataList) {
      if (element.isSelected == true) {
        showSelectedParentDataStack.add(element);
      }
    }
    update();
  }

  search(String value) {
    tempList.value = selectedParentDataList
        .where((parent) => parent.studentName
            .toString()
            .toUpperCase()
            .contains(value.toUpperCase()))
        .toList();
    update();
  }

  showParentListFilteredToSelectedList() {
    for (ParentDataSelected element in selectedParentDataList) {
      if (showSelectedParentDataStack.contains(element)) {
        element.isSelected = true;
      } else {
        element.isSelected = false;
      }
    }
  }

  void focusTextField() {
    if (focusNode.value.hasFocus) {
      focusNode.value = FocusNode();
    }
    focusNode.value.requestFocus();
  }

  // Future<void> fetchParentList(
  //     {required String classs,
  //     required String batch,
  //     required String subId,
  //     required String schoolId}) async {
  //   try {
  //     Map<String, dynamic> resp = await ApiServices.getParentList(
  //       classs: classs,
  //       batch: batch,
  //       subId: subId,
  //       schoolId: schoolId,
  //     );
  //     if (resp['status']['code'] == 200) {
  //       parentListApiData.value = ParentListApiModel.fromJson(resp);
  //       parentDataList.value = parentListApiData.value.data?.parentData ?? [];
  //       selectedParentDataList.value = List.generate(
  //         parentDataList.length,
  //         (index) {
  //           return ParentDataSelected(
  //             name: parentDataList[index].name,
  //             gender: parentDataList[index].gender,
  //             sId: parentDataList[index].sId,
  //             studentId: parentDataList[index].studentId,
  //             studentName: parentDataList[index].studentName,
  //             username: parentDataList[index].username,
  //             image: parentDataList[index].image,
  //             isSelected: true,
  //           );
  //         },
  //       );
  //       selectedParentDataStack.value = selectedParentDataList;
  //       showSelectedParentDataStack.value = selectedParentDataList;
  //       tempList.value = selectedParentDataList;
  //       update();
  //       // for (var parent in parentDataList) {
  //       //   allParentDataList.add(parent.sId.toString());
  //       // }
  //     }
  //   } catch (e) {
  //     print("----------parent list error---------");
  //   }
  // }

  Future<void> fetchParentList({
    required String classs,
    required String batch,
    required String subId,
    required String schoolId,
  }) async {
    selectedParentDataList.value = await Get.find<FeedDBController>()
        .getParentList(subId: subId, batch: batch, studentClass: classs);
    if (selectedParentDataList.isNotEmpty) {
      selectedParentDataList.sort(
        (a, b) => a.studentName!.compareTo(b.studentName!),
      );
    }
    selectedParentDataStack.value = selectedParentDataList;
    showSelectedParentDataStack.value = selectedParentDataList;
    tempList.value = selectedParentDataList;

    update();
    checkInternetWithOutSnacksbar(
      function: () async {
        try {
          Map<String, dynamic> resp = await ApiServices.getParentList(
            classs: classs,
            batch: batch,
            subId: subId,
            schoolId: schoolId,
          );
          if (resp['status']['code'] == 200) {
            parentListApiData.value = ParentListApiModel.fromJson(resp);
            parentDataList.value =
                parentListApiData.value.data?.parentData ?? [];
            selectedParentDataList.value = List.generate(
              parentDataList.length,
              (index) {
                return ParentDataSelected(
                  name: parentDataList[index].name,
                  gender: parentDataList[index].gender,
                  sId: parentDataList[index].sId,
                  studentId: parentDataList[index].studentId,
                  studentName: parentDataList[index].studentName,
                  username: parentDataList[index].username,
                  image: parentDataList[index].image,
                  isSelected: true,
                );
              },
            );
            await Get.find<FeedDBController>().storeParentDatatoDB(
                subId: subId,
                batch: batch,
                studentClass: classs,
                parentList: selectedParentDataList);
            selectedParentDataList.value = await Get.find<FeedDBController>()
                .getParentList(
                    subId: subId, batch: batch, studentClass: classs);

            selectedParentDataStack.value = selectedParentDataList;
            showSelectedParentDataStack.value = selectedParentDataList;
            tempList.value = selectedParentDataList;
            update();
            // for (var parent in parentDataList) {
            //   allParentDataList.add(parent.sId.toString());
            // }
          }
        } catch (e) {
          print("----------parent list error---------");
        }
      },
    );
  }

  Future<void> fetchParentListLocally({
    required String classs,
    required String batch,
    required String subId,
    required String schoolId,
  }) async {
    final finalParentList = await Get.find<FeedDBController>()
        .getParentList(subId: subId, batch: batch, studentClass: classs);
    print("finalParentList ----------------- ${finalParentList}");
    selectedParentDataList.value = finalParentList;
    selectedParentDataStack.value = finalParentList;
    showSelectedParentDataStack.value = finalParentList;
    tempList.value = finalParentList;
    update();
  }

  void addParentList(ParentDataSelected parent) {
    parent.isSelected = !parent.isSelected;
    update();
    getSelectedParentCount();
    getSelectAllIconData();
    // List<ParentData> parents = selectedParentDataList.where((emp) => emp.sId == parent.sId).toList();
    // if (parents.isEmpty) {
    //   selectedParentDataList.add(parent);
    // } else {
    //   removeParentList(parent);
    // }
  }

  void removeParentList(ParentDataSelected parent) {
    parent.isSelected = false;
    update();
    getSelectedParentCount();
  }

  List<String> setFinalParentList() {
    List<String> finalList = [];
    List.generate(
      showSelectedParentDataStack.length,
      (index) {
        // if(selectedParentDataStack[index].isSelected == true) {
        finalList.add(showSelectedParentDataStack[index].sId.toString());
        // }
      },
    );
    return finalList;
    // for (var parent in selectedParentDataList) {
    //   finalParentDataList.add(parent.sId ?? '');
    // }
  }

  List<Map<String, String>> setFinalParentListForNotification() {
    List<Map<String, String>> finalList = [];
    List.generate(
      showSelectedParentDataStack.length,
      (index) {
        // if(selectedParentDataStack[index].isSelected == true) {
        final data = {
          "parent_id": showSelectedParentDataStack[index].sId.toString(),
          "student_id": showSelectedParentDataStack[index].studentId.toString()
        };
        finalList.add(data);
        // }
      },
    );
    return finalList;
    // for (var parent in selectedParentDataList) {
    //   finalParentDataList.add(parent.sId ?? '');
    // }
  }

  void takeSelectedListForSubmit() {
    selectedParentDataStack.value = [];
    for (var parent in selectedParentDataList) {
      if (parent.isSelected == true) {
        selectedParentDataStack.add(parent);
      }
    }
  }

  void rebuildSelectedParentList() {
    selectedParentDataList.clear();
    selectedParentDataList.value = selectedParentDataStack;
    for (var parent in parentDataList) {
      ParentDataSelected parentDataSelected = ParentDataSelected(
        name: parent.name,
        gender: parent.image,
        sId: parent.sId,
        studentId: parent.studentId,
        studentName: parent.studentName,
        username: parent.username,
        image: parent.image,
        isSelected: true,
      );
      if (!selectedParentDataList.contains(parentDataSelected)) {
        selectedParentDataList.add(ParentDataSelected(
          name: parent.name,
          gender: parent.image,
          sId: parent.sId,
          studentId: parent.studentId,
          studentName: parent.studentName,
          username: parent.username,
          image: parent.image,
          isSelected: false,
        ));
      }
    }
    update();
  }

  unselectAll() {
    showSelectedParentDataStack.value = [];
    update();
  }

  void addAllSelectedParents() {}

  // bool showSelectionIcon(ParentData parent) {
  //   return selectedParentDataList.contains(parent);
  // }

  Future<int?> findMessageIndex({
    required ChatFeedViewReqModel reqBody,
    required int? msgId,
  }) async {
    print(reqBody.limit);
    // chatMsgCount = 1000;
    await fetchFeedViewMsgListPeriodically(reqBody);
    print(chatMsgList.length);
    for (int i = 0; i < chatMsgList.length; i++) {
      MsgData element = chatMsgList[i];

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

  getSelectedParentCount() {
    selectedParentCount.value = 0;
    selectedParentDataList.forEach(
      (element) {
        if (element.isSelected) {
          selectedParentCount.value++;
        }
      },
    );
    update();
  }

  selectAllParents() {
    for (var element in selectedParentDataList) {
      element.isSelected = true;
      // addParentList(element);
    }
    update();
    getSelectAllIconData();
  }

  unselectAllParents() {
    for (var element in selectedParentDataList) {
      element.isSelected = false;
      // addParentList(element);
    }
    update();
    getSelectAllIconData();
  }

  getSelectAllIconData() {
    for (var element in selectedParentDataList) {
      if (element.isSelected == false) {
        showSelectAllIcon.value = false;
        return;
      }
    }
    showSelectAllIcon.value = true;
  }

  sortSelectedParent() {
    selectedParentDataList.sort(
        (a, b) => a.studentName.toString().compareTo(b.studentName.toString()));
    selectedParentDataList.sort(
        (a, b) => b.isSelected.toString().compareTo(a.isSelected.toString()));
    update();
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
            color: Colorutils.letters1, decoration: TextDecoration.underline,
            // decoration: TextDecoration.underline,
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
