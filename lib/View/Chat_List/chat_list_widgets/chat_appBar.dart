import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teacherapp/Controller/api_controllers/parentChatListController.dart';
import 'package:teacherapp/Utils/Colors.dart';
import 'package:teacherapp/View/Chat_List/chat_list_widgets/new_parentChat_bottomSheet.dart';
import '../../../Controller/api_controllers/chatClassGroupController.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      color: Colorutils.userdetailcolor,
      padding: const EdgeInsets.symmetric(horizontal: 16).w,
      alignment: Alignment.bottomLeft,
      child: Row(
        children: [
          Text(
            'Chat with Parents',
            style: GoogleFonts.inter(
              fontSize: 25.h,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          SvgPicture.asset(
            'assets/images/MagnifyingGlass.svg',
            width: 27.h,
            fit: BoxFit.fitWidth,
          ),
          GetX<ChatClassGroupController>(
            builder: (ChatClassGroupController controller) {
              if (controller.currentChatTab.value == 1) {
                return Padding(
                  padding: const EdgeInsets.only(left: 6).w,
                  child: InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        barrierColor: Colors.transparent,
                        context: context,
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        builder: (context) {
                          return const NewParentChat();
                        },
                      ).then(
                        (value) {
                          Get.find<ParentChatListController>()
                              .isTextField
                              .value = "";
                        },
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4.0).w,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100).w),
                      child: Icon(
                        Icons.add,
                        color: Colorutils.letters1,
                      ),
                    ),
                  ),
                );
              } else {
                return SizedBox(
                  width: 0,
                  height: 0,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(100.h);
}
