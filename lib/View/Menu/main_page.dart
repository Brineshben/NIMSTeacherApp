
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:teacherapp/Controller/ui_controllers/page_controller.dart';
import '../../Utils/constants.dart';
import '../Home_Page/Home_Widgets/bottom_navigationbar.dart';
import 'package:upgrader/upgrader.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  // Widget getScreen({required int pageIndex}) {
  //   switch(pageIndex) {
  //     case 0: return const Homepage();
  //     case 2: return const ChatWithParentsPage();
  //     case 8: return const Leader();
  //     default: return const Homepage();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: systemUiOverlayStyleDark,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: GetX<PageIndexController>(
              builder: (PageIndexController controller) {
                return controller.menuItemsPerRole[controller.pageIndex.value].page;
                // return getScreen(
                //     pageIndex: controller.pageIndex.value,
                // );
              },
          ),
          bottomNavigationBar: const CustomBottomNavigationBar(),
        ),
      ),
    );
  }
}
