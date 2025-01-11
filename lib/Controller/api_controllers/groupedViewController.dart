import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:teacherapp/Controller/db_controller/group_db_controller.dart';
import 'package:teacherapp/Services/api_services.dart';
import 'package:teacherapp/Services/common_services.dart';
import 'package:teacherapp/Utils/Colors.dart';
import 'package:teacherapp/Utils/constant_function.dart';
import '../../Models/api_models/chat_feed_view_model.dart';

class GroupedViewController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoaded = false.obs;
  RxBool isError = false.obs;
  bool isPeriodicFetching = false;
  RxList<MsgData> chatMsgList = <MsgData>[].obs;
  late Rx<AutoScrollController> chatGroupedViewScrollController;

  Rx<FocusNode> focusNode = FocusNode().obs;
  String? lastMessageId;

  late int chatMsgCount;
  int messageCount = 30;
  bool showScrollIcon = true;
  int? previousMessageListLenght;
  RxBool showLoaderMoreMessage = true.obs;

  void resetStatus() {
    isLoading.value = false;
    isError.value = false;
  }

  void resetData() {
    isLoading.value = false;
    isError.value = false;
    isLoaded.value = false;
    chatMsgList.value = [];
  }

  Future<void> fetchFeedViewMsgList(
      ChatFeedViewReqModel reqBody, BuildContext context) async {
    isLoading.value = true;
    isError.value = false;
    chatMsgList.value = await Get.find<GroupDbController>().getAllMessages(
        subId: reqBody.subjectId ?? "",
        studentclass: reqBody.classs ?? "",
        batch: reqBody.batch ?? "");
    if (chatMsgList.isNotEmpty) {
      chatMsgList.add(chatMsgList[chatMsgList.length - 1]);
    }
    // isLoading.value = false;
    await checkInternetWithReturnBool(
      context: context,
      function: () async {
        try {
          Map<String, dynamic> resp =
              await ApiServices.getChatFeedView(reqBodyData: reqBody);

          print("-----------grouped view ewsp-------------$resp");
          if (resp['status']['code'] == 200) {
            ChatFeedViewModel chatFeedData = ChatFeedViewModel.fromJson(resp);
            // chatMsgList.value = chatFeedData.data?.data ?? [];
            await Get.find<GroupDbController>().storeMessageDatatoDB(
                messageList: chatFeedData.data?.data ?? [],
                subId: reqBody.subjectId ?? "",
                studentclass: reqBody.classs ?? "",
                batch: reqBody.batch ?? "");
            chatMsgList.value = await Get.find<GroupDbController>()
                .getAllMessages(
                    subId: reqBody.subjectId ?? "",
                    studentclass: reqBody.classs ?? "",
                    batch: reqBody.batch ?? "");
            if (chatMsgList.isNotEmpty) {
              chatMsgList.add(chatMsgList[chatMsgList.length - 1]);
              print(
                  "Chat list -- worked----------------- ${chatMsgList.length}");
            }

            // update();
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

          // update();

          print('--------grouped view error--------');
        } finally {
          isLoading.value = false;
          // update();
        }
      },
    );
    isLoading.value = false;
    // .then(
    //   (value) async {
    //     if (!value) {
    //       chatMsgList.value = await Get.find<GroupDbController>()
    //           .getAllMessages(
    //               subId: reqBody.subjectId ?? "",
    //               studentclass: reqBody.classs ?? "",
    //               batch: reqBody.batch ?? "");
    //       if (chatMsgList.isNotEmpty) {
    //         chatMsgList.add(chatMsgList[chatMsgList.length - 1]);
    //         print("Chat list -- worked----------------- ${chatMsgList.length}");
    //       }
    //       isLoading.value = false;
    //     }
    //   },
    // );
  }

  // Future<void> fetchFeedViewMsgList(ChatFeedViewReqModel reqBody) async {
  //   isLoading.value = true;
  //   isError.value = false;
  //   try {
  //     Map<String, dynamic> resp =
  //         await ApiServices.getChatFeedView(reqBodyData: reqBody);

  //     print("-----------grouped view ewsp-------------$resp");
  //     if (resp['status']['code'] == 200) {
  //       ChatFeedViewModel chatFeedData = ChatFeedViewModel.fromJson(resp);
  //       chatMsgList.value = chatFeedData.data?.data ?? [];
  //       if (chatMsgList.isNotEmpty) {
  //         chatMsgList.add(chatMsgList[chatMsgList.length - 1]);
  //         print("Chat list -- worked----------------- ${chatMsgList.length}");
  //       }

  //       // update();
  //       // chatMsgList.sort((a, b) {
  //       //   DateTime dateA = DateTime.parse(a.sendAt!);
  //       //   DateTime dateB = DateTime.parse(b.sendAt!);
  //       //   return dateA.compareTo(dateB);
  //       // });
  //     }
  //     isLoaded.value = true;
  //   } catch (e) {
  //     isLoaded.value = false;
  //     isError.value = true;

  //     // update();

  //     print('--------grouped view error--------');
  //   } finally {
  //     isLoading.value = false;
  //     // update();
  //   }
  // }

  Future<void> fetchFeedViewMsgListPeriodically(
      ChatFeedViewReqModel reqBody) async {
    print("periodic working 1");
    // ChatFeedViewModel? chatFeedData;

    if (isPeriodicFetching) {
      return; // Prevent overlapping calls
    }

    isPeriodicFetching = true;

    reqBody.limit = chatMsgCount;

    try {
      Map<String, dynamic> resp =
          await ApiServices.getChatFeedView(reqBodyData: reqBody);
      if (resp['status']['code'] == 200) {
        ChatFeedViewModel chatFeedData = ChatFeedViewModel.fromJson(resp);
        // chatMsgList.value = chatFeedData.data?.data ?? [];
        await Get.find<GroupDbController>().storeMessageDatatoDB(
            messageList: chatFeedData.data?.data ?? [],
            subId: reqBody.subjectId ?? "",
            studentclass: reqBody.classs ?? "",
            batch: reqBody.batch ?? "");
        // chatMsgList.value = await Get.find<GroupDbController>().getAllMessages(
        //     subId: reqBody.subjectId ?? "",
        //     studentclass: reqBody.classs ?? "",
        //     batch: reqBody.batch ?? "");

        // if (chatMsgList.isNotEmpty) {
        //   chatMsgList.add(chatMsgList[chatMsgList.length - 1]);
        //   print("Chat list -- worked----------------- ${chatMsgList.length}");
        // }

        final newMessageList = await Get.find<GroupDbController>()
            .getAllMessages(
                subId: reqBody.subjectId ?? "",
                studentclass: reqBody.classs ?? "",
                batch: reqBody.batch ?? "");

        if (newMessageList.isNotEmpty) {
          newMessageList.add(newMessageList[newMessageList.length - 1]);
          print(
              "Chat list -- worked----------------- ${newMessageList.length}");
        }

        chatMsgList.assignAll(newMessageList);

        print("message number = chat list lenth = ${chatMsgList.length}");

        update();
      }
    } catch (e) {
      print('--------grouped view error--------');
    } finally {
      isPeriodicFetching = false;
    }
    // MsgData? lastMsg = chatFeedData?.data?.data?.first;
    // String? newLastMessageId =
    //     "${lastMsg?.messageId}${lastMsg?.messageFromId}${lastMsg?.sendAt}";

    // if (lastMessageId == null || newLastMessageId != lastMessageId) {
    //   lastMessageId = newLastMessageId;
    //   chatMsgList.value = chatFeedData?.data?.data ?? [];
    //   // chatMsgList.sort((a, b) {
    //   //   DateTime dateA = DateTime.parse(a.sendAt!);
    //   //   DateTime dateB = DateTime.parse(b.sendAt!);
    //   //   return dateA.compareTo(dateB);
    //   // });
    //   // Future.delayed(
    //   //   const Duration(milliseconds: 50),
    //   //   () {
    //   //     chatGroupedViewScrollController.value.animateTo(
    //   //       chatGroupedViewScrollController.value.position.maxScrollExtent,
    //   //       duration: const Duration(milliseconds: 200),
    //   //       curve: Curves.easeOut,
    //   //     );
    //   //   },
    //   // );
    // }
  }

  Future<int?> findMessageIndex(
      {required ChatFeedViewReqModel reqBody,
      required int? msgId,
      required BuildContext context}) async {
    print(reqBody.limit);

    for (int i = 0; i < chatMsgList.length; i++) {
      MsgData element = chatMsgList[i];
      print("message number = i = ${element.messageId}");
      if (element.messageId == msgId.toString()) {
        print("message number = i = $i");

        return i;
      }
    }

    if (chatMsgList.length < 100) {
      context.loaderOverlay.show();
      chatMsgCount = 100;
      await fetchFeedViewMsgListPeriodically(reqBody);
      context.loaderOverlay.hide();
    }

    print("message number = lenth = ${chatMsgList.length}");
    for (int i = 0; i < chatMsgList.length; i++) {
      MsgData element = chatMsgList[i];
      print("message number = i = ${element.messageId}");
      if (element.messageId == msgId.toString()) {
        print("message number = i = $i");

        return i;
      }
    }
    return null;
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
      limit: chatMsgCount,
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
      // update();
    } catch (e) {
      print("periodicGetMsgList Error :-------------- $e");
    }
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
