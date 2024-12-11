import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:teacherapp/Controller/home_controller/home_controller.dart';
import 'package:teacherapp/Utils/Colors.dart';
import 'package:teacherapp/Utils/font_util.dart';
import '../../../Controller/ui_controllers/page_controller.dart';
import '../../../Models/ui_models/menu_item_model.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80.h,
      child: Theme(
        data: Theme.of(context).copyWith(splashFactory: NoSplash.splashFactory),
        child: GetX<PageIndexController>(
          builder: (PageIndexController controller) {
            int currentIndex = controller.pageIndex.value;
            List<MenuItemsModel> menuItems = controller.menuItemsPerRole;
            int isFromChoice = Get.find<PageIndexController>().navLength.value;
            return BottomNavigationBar(
                currentIndex: isFromChoice - 1,
                selectedLabelStyle: const TextStyle(fontSize: 0),
                backgroundColor: Colorutils.Whitecolor,
                type: BottomNavigationBarType.fixed,
                items: <BottomNavigationBarItem>[
                  for (int i = 0; i < isFromChoice; i++)
                    if (menuItems[i].index == 2)
                      BottomNavigationBarItem(
                        icon: InkWell(
                          onTap: () {
                            Get.find<HomeController>().currentIndex.value =
                                menuItems[i].index;
                            controller.changePage(
                                currentPage: menuItems[i].index);
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                // currentIndex == menuItems[i].index
                                //     ? "assets/images/ChatCircleTextcolor.svg"
                                //     : "assets/images/chat_outline.svg",
                                getSvg(
                                    title: menuItems[i].title,
                                    isFilled:
                                        currentIndex == menuItems[i].index),
                                // color: currentIndex == menuItems[i].index
                                //     ? Colorutils.letters1
                                //     : Colorutils.bottomiconcolor,
                                height: currentIndex == menuItems[i].index
                                    ? 30.h
                                    : 26.h,
                                fit: BoxFit.fitHeight,
                              ),
                              SizedBox(height: 1.w),
                              Text(
                                menuItems[i].title,
                                style: currentIndex == menuItems[i].index
                                    ? TeacherAppFonts.poppinsW500_16sp_letters1
                                    : TeacherAppFonts
                                        .poppinsW400_13sp_bottomiconcolor,
                              )
                            ],
                          ),
                        ),
                        label: "",
                      )
                    else
                      BottomNavigationBarItem(
                        icon: GestureDetector(
                          onTap: () {
                            Get.find<HomeController>().currentIndex.value =
                                menuItems[i].index;
                            controller.changePage(
                                currentPage: menuItems[i].index);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                // menuItems[i].svg,
                                getSvg(title: menuItems[i].title, isFilled: currentIndex == menuItems[i].index),
                                height: 25.h,
                                fit: BoxFit.fitHeight,
                                // color: currentIndex == menuItems[i].index
                                //     ? Colorutils.letters1
                                //     : Colorutils.bottomiconcolor,
                              ),
                              SizedBox(height: 3.w),
                              Text(
                                menuItems[i].title,
                                style: currentIndex == menuItems[i].index
                                    ? TeacherAppFonts.poppinsW500_16sp_letters1
                                    : TeacherAppFonts
                                    .poppinsW400_13sp_bottomiconcolor,
                              )
                            ],
                          ),
                        ),
                        label: "",
                      ),
                  // BottomNavigationBarItem(
                  //   icon: GestureDetector(
                  //     onTap: () {
                  //       controller.changePage(currentPage: 1);
                  //       // showModalBottomSheet(
                  //       //   context: context,
                  //       //   isScrollControlled: true,
                  //       //   shape: RoundedRectangleBorder(
                  //       //     borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  //       //   ),
                  //       //   builder: (context) => ParentSelectionBottomSheet(),
                  //       // );
                  //     },
                  //     child: Column(
                  //       mainAxisSize: MainAxisSize.min,
                  //       children: [
                  //         SvgPicture.asset(
                  //           'assets/images/clock-three 1.svg',
                  //           height: 26.w,
                  //           fit: BoxFit.fitHeight,
                  //           color: currentIndex == 1 ? Colorutils.letters1 : Colorutils.bottomiconcolor,
                  //         ),
                  //         SizedBox(height: 3.w),
                  //         Text(
                  //           'Leave',
                  //           style: currentIndex == 1 ? TeacherAppFonts.poppinsW500_13sp_letters1 : TeacherAppFonts.poppinsW400_12sp_bottomiconcolor,
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  //   label: '',
                  // ),
                  // BottomNavigationBarItem(
                  //   icon: GestureDetector(
                  //     onTap: () {
                  //       controller.changePage(currentPage: 2);
                  //       // Navigator.pushReplacement(
                  //       //     context,
                  //       //     MaterialPageRoute(builder: (context) =>  ChatWithParentsPage(zoomDrawerController:zoomDrawerController,)));
                  //     },
                  //     child: CircleAvatar(
                  //       radius: 25.r,
                  //       backgroundColor: Colorutils.userdetailcolor,
                  //       child: SvgPicture.asset(
                  //         currentIndex == 2 ? "assets/images/chat_selected_icon.svg" : "assets/images/chat_icon.svg",
                  //         alignment: Alignment.center,
                  //         height: 21.w,
                  //         fit: BoxFit.fitHeight,
                  //       ),
                  //     ),
                  //   ),
                  //   label: "",
                  // ),
                  // BottomNavigationBarItem(
                  //   icon: GestureDetector(
                  //     onTap: () {
                  //       controller.changePage(currentPage: 3);
                  //     },
                  //     child: Column(
                  //       children: [
                  //         SvgPicture.asset(
                  //           'assets/images/chart-pie-alt.svg',
                  //           height: 26.w,
                  //           fit: BoxFit.fitHeight,
                  //           color: currentIndex == 3 ? Colorutils.letters1 : Colorutils.bottomiconcolor,
                  //         ),
                  //         SizedBox(height: 3.w),
                  //         Text(
                  //           'OBS Result',
                  //           style: currentIndex == 3 ? TeacherAppFonts.poppinsW500_13sp_letters1 : TeacherAppFonts.poppinsW400_12sp_bottomiconcolor,
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  //   label: '',
                  // ),
                  // BottomNavigationBarItem(
                  //   icon: GestureDetector(
                  //     onTap: (){
                  //       controller.changePage(currentPage: 4);
                  //       // showModalBottomSheet(
                  //       //   context: context,
                  //       //   isScrollControlled: true,
                  //       //   shape: RoundedRectangleBorder(
                  //       //     borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  //       //   ),
                  //       //   builder: (context) => BottomSheetContent(),
                  //       // );
                  //     },
                  //     child: Column(
                  //       children: [
                  //         SvgPicture.asset(
                  //           'assets/images/apps 2.svg',
                  //           height: 26.w,
                  //           fit: BoxFit.fitHeight,
                  //           color: currentIndex == 4 ? Colorutils.letters1 : Colorutils.bottomiconcolor,
                  //         ),
                  //         SizedBox(height: 3.w),
                  //         Text(
                  //           'More',
                  //           style: currentIndex == 4 ? TeacherAppFonts.poppinsW500_13sp_letters1 : TeacherAppFonts.poppinsW400_12sp_bottomiconcolor,
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  //   label: '',
                  // ),
                ],
                unselectedItemColor: Colors.grey,
                selectedItemColor: Colorutils.userdetailcolor);
          },
        ),
      ),
    );
  }

  String getSvg({required String title, required bool isFilled}) {
    if (isFilled) {
      switch (title) {
        case "Home": return "assets/images/fill_home.svg";
        case "Leave": return "assets/images/fill_leave.svg";
        case "Reports": return "assets/images/reports-filled.svg";
        case "More": return "assets/images/fill_more.svg";
        case "OBS Result": return "assets/images/fill_result.svg";
        case "Chat": return "assets/images/ChatCircleTextcolor.svg";
        default: return "assets/images/fill_home.svg";
      }
    } else {
      switch (title) {
        case "Home": return "assets/images/house-bottom.svg";
        case "Leave": return "assets/images/clock-three 1.svg";
        case "Reports": return "assets/images/leaderboard-svgrepo-com.svg";
        case "More": return "assets/images/apps 2.svg";
        case "OBS Result": return "assets/images/chart-pie-alt.svg";
        case "Chat": return "assets/images/chat_outline.svg";
        default: return "assets/images/house-bottom.svg";
      }
    }
  }
}
