
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:teacherapp/Controller/ui_controllers/page_controller.dart';
import 'package:teacherapp/Utils/Colors.dart';
import 'package:teacherapp/View/CWidgets/AppBarBackground.dart';
import 'package:teacherapp/View/RoleNavigation/hos_listing.dart';

import '../../Controller/api_controllers/userAuthController.dart';
import '../CWidgets/TeacherAppPopUps.dart';
import '../Menu/drawer.dart';

class ChoicePage extends StatefulWidget {
  const ChoicePage({super.key});

  @override
  State<ChoicePage> createState() => _ChoicePageState();
}

class _ChoicePageState extends State<ChoicePage> {
  TextEditingController? _usernameController;
  TextEditingController? _passwordController;
  PageIndexController pageIndexController = Get.find<PageIndexController>();
  UserAuthController userAuthController = Get.find<UserAuthController>();
  bool isSpinner = false;
  bool googleSignIn = false;
  FocusNode? _usernameFocusNode;
  FocusNode? _passwordFocusNode;
  final bool _obscureText = true;
  String? employeeNumbers;
  String? userIds;
  String? names;
  String? schoolIds;
  String? images;
  var designation = [];

  List<String> rolename = [];

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _usernameFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    initialize();
    // _progressDialog = ProgressDialog(context);
  }

  @override
  void dispose() {
    _usernameController?.dispose();
    _passwordController?.dispose();
    _usernameFocusNode?.dispose();
    _passwordFocusNode?.dispose();
    super.dispose();
  }

  Future<void> initialize() async {
    setState(() {
      isSpinner = true;
    });
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      isSpinner = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          backgroundColor: Colors.white,
          body: SizedBox(
            height: ScreenUtil().screenHeight,
            width: ScreenUtil().screenWidth,
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  const AppBarBackground(),
                  Container(
                    margin: EdgeInsets.only(left: 20.w, top: 100.h, right: 20.w, bottom: 20.w),
                    // width: 550.w,
                    height: ScreenUtil().screenHeight * 0.85,
                    decoration: BoxDecoration(
                      color: Colorutils.Whitecolor,
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colorutils.userdetailcolor.withOpacity(0.15),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: isSpinner
                        ? Center(
                      child: _Loader(),
                    )
                        : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Lottie.asset("assets/images/select_role.json"),
                        const Spacer(flex: 2),
                        Center(
                          child: SizedBox(
                            child: Text(
                              "Select your role",
                              style: TextStyle(
                                  fontSize: 14.sp, color: Colors.cyan),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        // teacherData == null || teacherData.isEmpty
                        //     ? Text("")
                        GestureDetector(
                            onTap: () async {
                              pageIndexController.changePage(currentPage: 0);
                              pageIndexController.setMenuItems(userRole: UserRole.teacher, isClassTeacher: true);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const DrawerScreen()));
                            },
                            child: SvgPicture.asset(
                                "assets/images/hoslogin.svg")),
                        GestureDetector(
                            onTap: () {
                              pageIndexController.changePage(currentPage: 0);
                              pageIndexController.setMenuItems(userRole: UserRole.leader, isClassTeacher: true);
                              List<String>? rolIds = userAuthController.userData.value.roleIds ?? [];
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const DrawerScreen()));
                              // if((rolIds.contains("rolepri12") || rolIds.contains("role12123")) && !rolIds.contains("role121234")) {
                              //   Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //           builder: (context) => const HosListing()));
                              // } else {
                              //   userAuthController.setSelectedHosData(
                              //     hosName: userAuthController.userData.value.name ?? '--',
                              //     hosId: userAuthController.userData.value.userId ?? '--',
                              //     isHos: true,
                              //   );
                              //   Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //           builder: (context) => const DrawerScreen()));
                              // }
                            },
                            child: SvgPicture.asset(
                                "assets/images/teacherLogin.svg")),
                        SizedBox(height: 30.w,),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 15, right: 15).w,
                            child: FloatingActionButton(
                              backgroundColor: Colors.white,
                              elevation: 0,
                              child: Center(
                                child: SvgPicture.asset(
                                  "assets/images/logout.svg",
                                  width: 30.h,
                                  height: 30.h,
                                  color: Colors.red,
                                ),
                              ),
                              onPressed: () {
                                TeacherAppPopUps.logOutPopUp(context: context);
                              },
                            ),
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}

Widget _Loader() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Center(
        child: Image.asset(
          height: 100.h,
          "assets/images/loader1.gif",
          fit: BoxFit.fitHeight,
        ),
      ),
      SizedBox(height: 200.h),
      SizedBox(
        height: 100.h,
        width: 280.w,
        child: DefaultTextStyle(
          style: const TextStyle(
            color: Colorutils.userdetailcolor,
            fontSize: 13.0,
            fontFamily: 'Agne',
          ),
          child: AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                  'Teaching is a calling too. And I have always thought that teachers in their way are holy-angels leading their flocks out of the darkness. \n :- Jeannette Walls'),
              TypewriterAnimatedText(
                  'Better than a thousand days of diligent study is one day with a great Teacher. \n :- Japanese Proverb'),
              TypewriterAnimatedText(
                  'Education does not mean teaching people what they do not know. It means teaching them to behave as they do not behave. \n :- Abraham Lincoln'),
              TypewriterAnimatedText(
                  'Education is not the filling of a pail, but the lighting of a fire. \n :- William Butler Yeats'),
              TypewriterAnimatedText(
                  'The function of education is to teach one to think intensively and to think critically. Intelligence plus character - that is the goal of true Education. \n :- Martin Luther King Jr'),
              TypewriterAnimatedText(
                  'One child, one teacher, one book, and one pen change the world. \n :- Malala Yousafzai'),
              TypewriterAnimatedText(
                  'The fact that you worry about being a good teacher, means that you already are one. \n :- Jodi Picoult'),
              TypewriterAnimatedText(
                  'A well educated mind will always have more questions than answers. \n :- Helen Keller'),
            ],
            onTap: () {
              print("Tap Event");
            },
          ),
        ),
      ),
      SizedBox(height: 20.h),
      Padding(
        padding: const EdgeInsets.only(right: 40, top: 20).w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {},
              child: CircleAvatar(
                radius: 15,
                backgroundColor: Colors.white,
                child: SvgPicture.asset(
                  "assets/images/logout.svg",
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      )
    ],
  );
}
