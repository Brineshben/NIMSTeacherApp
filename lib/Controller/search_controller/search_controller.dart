import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:teacherapp/Controller/api_controllers/feedViewController.dart';
import 'package:teacherapp/Controller/api_controllers/groupedViewController.dart';
import 'package:teacherapp/Controller/api_controllers/parentChatController.dart';
import 'package:teacherapp/Models/api_models/parent_chatting_model.dart';
import 'package:teacherapp/Services/common_services.dart';
import 'package:teacherapp/Services/snackBar.dart';
import 'package:teacherapp/Utils/Colors.dart';

// class ChatRoomSearchController extends GetxController {
//   //chat room search //

//   List<RoomList> searchList = [];
//   List<RoomList> tempSearchList = [];

//   search({required String searchValue}) {
//     searchList = tempSearchList
//         .where((element) =>
//             element.subject!
//                 .toLowerCase()
//                 .contains(searchValue.toLowerCase()) ||
//             element.teacherName!
//                 .toLowerCase()
//                 .contains(searchValue.toLowerCase()))
//         .toList();
//     update();
//   }
// }

class ChatSearchController extends GetxController {
  // chat search //

  TextEditingController searchCtr = TextEditingController();

  bool isSearch = false;

  Set<int> messageListIndex = {};

  RxString searchValue = "".obs;

  int? searchIndex;

  bool isShowSnackBar = false;

  showSearch() {
    isSearch = true;
    update();
  }

  hideSearch() {
    isSearch = false;
    update();
  }

  searchChat(
      {required String text,
      required BuildContext context,
      required String searchListType}) {
    // on change function for seach //
    searchValue.value =
        text; // for building the ui  so set the value to rx string //
    messageListIndex = {}; // for setting emty for on search new value //
    getSearchChatLsit(context: context, searchListType: searchListType);
    if (messageListIndex.isNotEmpty && searchValue.isNotEmpty) {
      // for going first message //
      searchIndex = 0;

      goToText(
          index: messageListIndex.elementAt(searchIndex!),
          searchListType: searchListType);
    }
  }

  // List<TextSpan> getSearchText(
  //     {required String message,
  //     required String searchTerm,
  //     required int index}) {
  //   // for showing the text heighlight in ui //
  //   final List<TextSpan> spans = [];
  //   String lowerText = message.toLowerCase();
  //   String lowerSearchTerm = searchTerm.toLowerCase();

  //   int start = 0;
  //   int index = lowerText.indexOf(lowerSearchTerm);

  //   print("searchList ========== index $index");

  //   while (index != -1) {
  //     // Add the text before the search term
  //     if (index > start) {
  //       spans.add(TextSpan(
  //         text: message.substring(start, index),
  //         style: TextStyle(
  //             color: !Get.find<MessageController>().checkIsURL(text: message)
  //                 ? ColorUtil.black
  //                 : ColorUtil.urlColor),
  //       ));
  //     }

  //     // Add the highlighted search term
  //     spans.add(TextSpan(
  //       text: message.substring(index, index + searchTerm.length),
  //       style: const TextStyle(
  //         color: ColorUtil.white, // Highlight color
  //         backgroundColor: ColorUtil.green, // Background highlight color
  //       ),
  //     ));

  //     start = index + searchTerm.length;
  //     index = lowerText.indexOf(lowerSearchTerm, start);
  //   }

  //   // Add the remaining text after the last search term
  //   if (start < message.length) {
  //     spans.add(TextSpan(
  //       text: message.substring(start),
  //       style: TextStyle(
  //           color: !Get.find<MessageController>().checkIsURL(text: message)
  //               ? ColorUtil.black
  //               : ColorUtil.urlColor),
  //     ));
  //   }

  //   print("searchList $messageListIndex");

  //   return spans;
  // }

  nextIndex(BuildContext context, String searchListType) {
    // for go to next msg //
    // print("searchList ========== $searchIndex");
    // print("searchList  lenth ========== ${messageListIndex.length}");
    if (messageListIndex.isNotEmpty) {
      if (searchIndex == null) {
        searchIndex = 0;

        goToText(
            index: messageListIndex.elementAt(searchIndex!),
            searchListType: searchListType);
      } else {
        if (searchIndex! < messageListIndex.length) {
          if (searchIndex! < messageListIndex.length - 1) {
            searchIndex = searchIndex! + 1;
          } else {
            snackBar(
                context: context,
                message: "Not found",
                color: Colorutils.black);
          }
          goToText(
              index: messageListIndex.elementAt(searchIndex!),
              searchListType: searchListType);
        } else {
          snackBar(
              context: context, message: "Not found", color: Colorutils.black);
        }
      }
    } else {
      snackBar(context: context, message: "Not found", color: Colorutils.black);
    }
  }

  previousIndex(BuildContext context, String searchListType) {
    // for go to previous msg //
    // print("searchList ========== $searchIndex");
    // print("searchList  lenth ========== ${messageListIndex.length}");
    if (messageListIndex.isNotEmpty) {
      if (searchIndex == null) {
        searchIndex = 0;

        goToText(
            index: messageListIndex.elementAt(searchIndex!),
            searchListType: searchListType);
      } else {
        if (searchIndex! < messageListIndex.length) {
          if (searchIndex! > 0) {
            searchIndex = searchIndex! - 1;
          } else {
            snackBar(
                context: context,
                message: "Not found",
                color: Colorutils.black);
          }
          goToText(
              index: messageListIndex.elementAt(searchIndex!),
              searchListType: searchListType);
        } else {
          snackBar(
              context: context, message: "Not found", color: Colorutils.black);
        }
      }
    } else {
      snackBar(context: context, message: "Not found", color: Colorutils.black);
    }
  }

  getSearchChatLsit(
      {required BuildContext context, required String searchListType}) {
    late Timer timer;
    final messageList;
    // for search values contails in msg //
    if (searchListType == "parentMsgList") {
      messageList = Get.find<ParentChattingController>().chatMsgList;
    } else if (searchListType == "feedMsgList") {
      messageList = Get.find<FeedViewController>().chatMsgList;
    } else if (searchListType == "groupMsgList") {
      messageList = Get.find<GroupedViewController>().chatMsgList;
    } else {
      messageList = [];
    }

    for (int i = 0; i < messageList.length; i++) {
      if (messageList[i].message != null) {
        if (messageList[i]
            .message!
            .toLowerCase()
            .contains(searchValue.toLowerCase())) {
          messageListIndex.add(i);
        }
      }
    }

    if (!isShowSnackBar) {
      int count = 2;
      if (messageListIndex.isEmpty) {
        isShowSnackBar = true;
        timer = Timer.periodic(
          const Duration(seconds: 1),
          (timer) {
            count--;
            if (count <= 0) {
              timer.cancel();
              isShowSnackBar = false;
            }
          },
        );
        snackBar(
            context: context, message: "Not found", color: Colorutils.black);
      }
    } else {
      print("success -------------- ");
    }

    // if (messageListIndex.isEmpty) {
    //   snackBar(context: context, message: "Not found", color: Colorutils.black);
    // }
    // print("searchList ========== ${messageListIndex}");
  }

  goToText({required int index, required String searchListType}) async {
    AutoScrollController controller;
    if (searchListType == "parentMsgList") {
      controller =
          Get.find<ParentChattingController>().parentChatScrollController.value;
    } else if (searchListType == "feedMsgList") {
      controller =
          Get.find<FeedViewController>().chatFeedViewScrollController.value;
    } else if (searchListType == "groupMsgList") {
      controller = Get.find<GroupedViewController>()
          .chatGroupedViewScrollController
          .value;
    } else {
      controller = AutoScrollController();
    }

    // for animation //
    await controller.scrollToIndex(
      index,
      preferPosition: AutoScrollPosition.middle,
    );
    await controller.highlight(index,
        highlightDuration: const Duration(seconds: 1), animated: true);
  }

  setValueDefault() {
    // set all values to default //
    searchCtr.clear();

    isSearch = false;

    messageListIndex = {};
    searchValue = "".obs;

    searchIndex = null;
  }

  List<TextSpan> getCombinedTextSpan({
    required String text,
    required String searchTerm,
    required BuildContext context,
  }) {
    // Regular expression to detect URLs
    const urlPattern =
        r'((https?:\/\/)?(www\.)?[a-zA-Z0-9-]+\.(com|org|net|edu|gov|mil|int|info|biz|co|us|io|me)([\/\w\-.?&=%#]*)?)';
    final regex = RegExp(urlPattern);
    final matches = regex.allMatches(text);

    final List<TextSpan> spans = [];
    int lastMatchEnd = 0;
    String lowerSearchTerm = searchTerm.toLowerCase();

    for (final match in matches) {
      final url = match.group(0)!;
      final String formattedUrl =
          url.startsWith('http://') || url.startsWith('https://')
              ? url
              : 'https://$url';

      // Process any text before the URL
      if (match.start > lastMatchEnd) {
        String preUrlText = text.substring(lastMatchEnd, match.start);
        spans.addAll(_highlightSearchTerms(preUrlText, lowerSearchTerm));
      }

      // Highlight search terms within the URL itself
      spans.addAll(_highlightSearchTerms(url, lowerSearchTerm,
          isUrl: true, formattedUrl: formattedUrl, context: context));

      lastMatchEnd = match.end;
    }

    // Handle any remaining text after the last URL
    if (lastMatchEnd < text.length) {
      String postUrlText = text.substring(lastMatchEnd);
      spans.addAll(_highlightSearchTerms(postUrlText, lowerSearchTerm));
    }

    return spans;
  }

  List<TextSpan> _highlightSearchTerms(String text, String lowerSearchTerm,
      {bool isUrl = false, String? formattedUrl, BuildContext? context}) {
    final List<TextSpan> spans = [];
    String lowerText = text.toLowerCase();
    int start = 0;
    int index = lowerText.indexOf(lowerSearchTerm);

    while (index != -1) {
      // Add text before the search term
      if (index > start) {
        spans.add(_createTextSpan(
            text: text.substring(start, index),
            isUrl: isUrl,
            formattedUrl: formattedUrl,
            context: context));
      }

      // Add the highlighted search term
      spans.add(_createTextSpan(
        text: text.substring(index, index + lowerSearchTerm.length),
        isHighlighted: true,
        isUrl: isUrl,
        formattedUrl: formattedUrl,
        context: context,
      ));

      start = index + lowerSearchTerm.length;
      index = lowerText.indexOf(lowerSearchTerm, start);
    }

    // Add remaining text after the last search term
    if (start < text.length) {
      spans.add(_createTextSpan(
          text: text.substring(start),
          isUrl: isUrl,
          formattedUrl: formattedUrl,
          context: context));
    }

    return spans;
  }

  TextSpan _createTextSpan(
      {required String text,
      bool isHighlighted = false,
      bool isUrl = false,
      String? formattedUrl,
      BuildContext? context}) {
    return TextSpan(
      text: text,
      style: TextStyle(
        decoration: isUrl ? TextDecoration.underline : null,
        color: isHighlighted
            ? Colors.white
            : isUrl
                ? Colorutils.letters1
                : null,
        backgroundColor: isHighlighted ? Colors.green : null,
        // decoration: isUrl ? TextDecoration.underline : null,
      ),
      recognizer: isUrl && context != null
          ? (TapGestureRecognizer()
            ..onTap = () {
              openUrl(
                message: formattedUrl!,
                context: context,
              );
            })
          : null,
    );
  }
}
