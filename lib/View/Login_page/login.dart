import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:lottie/lottie.dart';
import 'package:teacherapp/Controller/api_controllers/userAuthController.dart';
import 'package:teacherapp/Services/controller_handling.dart';
import 'package:teacherapp/Utils/Colors.dart';
import 'package:teacherapp/Utils/api_constants.dart';
import 'package:teacherapp/View/CWidgets/AppBarBackground.dart';
import 'package:teacherapp/View/CWidgets/TeacherAppPopUps.dart';
import 'package:teacherapp/View/RoleNavigation/choice_page.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../Controller/ui_controllers/page_controller.dart';
import '../../Services/check_connectivity.dart';
import '../CWidgets/commons.dart';
import '../Forgot_password/Forgot_password.dart';
import '../Menu/drawer.dart';
import '../RoleNavigation/hos_listing.dart';
import 'google_signin_api.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  UserAuthController userAuthController = Get.find<UserAuthController>();
  TextEditingController? _usernameController;
  TextEditingController? _passwordController;
  FocusNode? _usernameFocusNode;
  FocusNode? _passwordFocusNode;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _usernameFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();

  }

  @override
  void dispose() {
    _usernameController?.dispose();
    _passwordController?.dispose();
    _usernameFocusNode?.dispose();
    _passwordFocusNode?.dispose();
    super.dispose();
  }

  Future signIn() async {
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    // preferences.setString('GoogleUser', Guser.email.toString());
    // //  print(preferences.getString('GoogleUser'));
    // GoogleUser = preferences.getString('GoogleUser');

    try {
      if (await GoogleSignInApi.isSignedIn()) {
        await GoogleSignInApi.logout();
      }
      final gUser = await GoogleSignInApi.login();
      print(gUser?.email);
      if (gUser!.email.isEmpty) {
        print("No User found");
        TeacherAppPopUps.submitFailed(
          title: 'Failed',
          message: 'Something went wrong.',
          actionName: 'Close',
          iconData: Icons.error_outline,
          iconColor: Colorutils.svguicolour2,
        );
      } else {
        await userAuthController.googleSignInUser(username: gUser.email);
      }
    } catch (e) {
      print(e);
      TeacherAppPopUps.submitFailed(
        title: 'Failed',
        message: 'You are not an authorized user.',
        actionName: 'Close',
        iconData: Icons.error_outline,
        iconColor: Colorutils.red,
      );
    }
  }

  Future<void> _handleAppleIn() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      print("Account: ${credential.email}");
      if (credential.email!.length == 0) {
        print('Invalid Email');
      } else {
        await userAuthController.googleSignInUser(username: credential.email!);
      }
      // validateGoogleSignIn();
    } catch (error) {
      print(error);
      // showSnackBar(context, "Something went wrong", Colors.red);
    }
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
                    margin: EdgeInsets.only(
                        left: 20.w, top: 120.h, right: 20.w, bottom: 10.h),
                    // width: 550.w,
                    // height: ScreenUtil().screenHeight * 0.85,
                    decoration: themeCardDecoration,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 20.h),
                              child: SizedBox(
                                height: 200.h,
                                // height: 180.h,
                                child: Lottie.asset(
                                  "assets/images/loginimage.json",
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 25.h),
                          Container(
                            margin: EdgeInsets.only(left: 30.w),
                            child: Text(
                              'Hello !',
                              style: GoogleFonts.roboto(
                                  color: Colors.black,
                                  fontSize: 30.h,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 30.w),
                            child: Text(
                              'Sign in to your account',
                              style: GoogleFonts.roboto(
                                  color: Colors.grey,
                                  fontSize: 13.h,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30.w, vertical: 2.h),
                            child: TextFormField(
                              cursorColor: Colorutils.userdetailcolor,
                              controller: _usernameController,
                              autofillHints: const [AutofillHints.username],
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colorutils.userdetailcolor,
                                          width: 2)),
                                  enabledBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colorutils.userdetailcolor)),
                                  // border: UnderlineInputBorder(),
                                  labelText: 'Username',
                                  labelStyle: TextStyle(
                                      color: Colorutils.userdetailcolor,
                                      fontSize: 16.h)),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30.w, vertical: 5.h),
                            child: TextFormField(
                              cursorColor: Colorutils.userdetailcolor,
                              textInputAction: TextInputAction.done,
                              obscureText: _obscureText,
                              controller: _passwordController,
                              autofillHints: const [AutofillHints.password],
                              onEditingComplete: () =>
                                  TextInput.finishAutofillContext(),
                              decoration: InputDecoration(
                                  focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colorutils.userdetailcolor,
                                          width: 2)),
                                  enabledBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colorutils.userdetailcolor)),
                                  // border: UnderlineInputBorder(borderSide: BorderSide(color: Colorutils.userdetailcolor)),
                                  labelText: 'Password',
                                  labelStyle: TextStyle(
                                      color: Colorutils.userdetailcolor,
                                      fontSize: 16.h),
                                  suffixIcon: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _obscureText = !_obscureText;
                                        });
                                      },
                                      child: Icon(_obscureText
                                          ? Icons.visibility_off
                                          : Icons.visibility))),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                    horizontal: 40.w, vertical: 5.h)
                                .w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ForgotPassword()));
                                  },
                                  child: Text(
                                    "Forgot Password?",
                                    style: TextStyle(
                                        fontSize: 11.h,
                                        color: Colors.blue[900],
                                        fontStyle: FontStyle.italic),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 30.h),
                          Center(
                              child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30).w,
                            child: GestureDetector(
                              onTap: () async {
                                checkInternet2(
                                  context: context,
                                  function: () async {
                                    String? user =
                                        _usernameController?.text.trim() != ""
                                            ? _usernameController?.text.trim()
                                            : null;
                                    String? psw =
                                        _passwordController?.text.trim() != ""
                                            ? _passwordController?.text.trim()
                                            : null;
                                    if(user != null) {
                                      if(psw != null) {
                                        context.loaderOverlay.show();
                                        await userAuthController.fetchUserData(
                                          username: user,
                                          password: psw,
                                        );
                                        context.loaderOverlay.hide();
                                        if (userAuthController.isLoaded.value) {
                                          UserRole? userRole =
                                              userAuthController.userRole.value;
                                          if (userRole != null) {
                                            if (userRole == UserRole.leader) {
                                              List<String>? rolIds =
                                                  userAuthController.userData
                                                      .value.roleIds ??
                                                      [];
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                      const DrawerScreen()));
                                              // if((rolIds.contains("rolepri12") || rolIds.contains("role12123")) && !rolIds.contains("role121234")) {
                                              //   Navigator.push(
                                              //       context,
                                              //       MaterialPageRoute(
                                              //           builder: (context) =>
                                              //           const HosListing()));
                                              // } else {
                                              //   userAuthController
                                              //       .setSelectedHosData(
                                              //     hosName: userAuthController
                                              //         .userData.value.name ??
                                              //         '--',
                                              //     hosId: userAuthController
                                              //         .userData
                                              //         .value
                                              //         .userId ??
                                              //         '--',
                                              //     isHos: true,
                                              //   );
                                              //   Navigator.pushReplacement(
                                              //       context,
                                              //       MaterialPageRoute(
                                              //           builder: (context) =>
                                              //           const DrawerScreen()));
                                              // }
                                            }
                                            if (userRole ==
                                                UserRole.bothTeacherAndLeader) {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                      const ChoicePage()));
                                            }
                                            if (userRole == UserRole.teacher) {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                      const DrawerScreen()));
                                            }
                                          } else {
                                            TeacherAppPopUps.submitFailed(
                                              title: "Failed",
                                              message: "You are not an authorized user.",
                                              actionName: "Close",
                                              iconData: Icons.error_outline,
                                              iconColor: Colorutils.svguicolour2,
                                            );
                                          }
                                        }
                                      } else {
                                        TeacherAppPopUps.submitFailed(
                                          title: "Failed",
                                          message: "Please Enter your Password.",
                                          actionName: "Close",
                                          iconData: Icons.error_outline,
                                          iconColor: Colorutils.svguicolour2,
                                        );
                                      }
                                    } else {
                                      if(user == null && psw == null) {
                                        TeacherAppPopUps.submitFailed(
                                          title: "Failed",
                                          message: "Please Enter Your Username and Password",
                                          actionName: "Close",
                                          iconData: Icons.error_outline,
                                          iconColor: Colorutils.svguicolour2,
                                        );
                                      } else {
                                        TeacherAppPopUps.submitFailed(
                                          title: "Failed",
                                          message: "Please Enter Your Username.",
                                          actionName: "Close",
                                          iconData: Icons.error_outline,
                                          iconColor: Colorutils.svguicolour2,
                                        );
                                      }
                                    }
                                  },
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colorutils.userdetailcolor,
                                  borderRadius: BorderRadius.circular(30.r),
                                ),
                                // width: 250.w,
                                height: 50.h,
                                child: Center(
                                  child: Text(
                                    'Login',
                                    style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 18.h,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          )),
                          SizedBox(height: 20.h),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Divider(
                                  indent: 30.w,
                                  thickness: 0.5,
                                  color: Colors.grey[400],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.w),
                                child: Text(
                                  'or',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12.h,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  thickness: 0.5,
                                  color: Colors.grey[400],
                                  endIndent: 30.w,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30).w,
                              child: GestureDetector(
                                onTap: () async {
                                  context.loaderOverlay.show();
                                  await signIn().then(
                                      (_) => context.loaderOverlay.hide());
                                  if (userAuthController.isLoaded.value) {
                                    UserRole? userRole =
                                        userAuthController.userRole.value;
                                    if (userRole != null) {
                                      if (userRole == UserRole.leader) {
                                        List<String>? rolIds =
                                            userAuthController.userData
                                                .value.roleIds ??
                                                [];
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                const DrawerScreen()));
                                        // if((rolIds.contains("rolepri12") || rolIds.contains("role12123")) && !rolIds.contains("role121234")) {
                                        //   Navigator.push(
                                        //       context,
                                        //       MaterialPageRoute(
                                        //           builder: (context) =>
                                        //           const HosListing()));
                                        // } else {
                                        //   userAuthController
                                        //       .setSelectedHosData(
                                        //     hosName: userAuthController
                                        //         .userData.value.name ??
                                        //         '--',
                                        //     hosId: userAuthController
                                        //         .userData
                                        //         .value
                                        //         .userId ??
                                        //         '--',
                                        //     isHos: true,
                                        //   );
                                        //   Navigator.pushReplacement(
                                        //       context,
                                        //       MaterialPageRoute(
                                        //           builder: (context) =>
                                        //           const DrawerScreen()));
                                        // }
                                      }
                                      if (userRole ==
                                          UserRole.bothTeacherAndLeader) {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                const ChoicePage()));
                                      }
                                      if (userRole == UserRole.teacher) {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                const DrawerScreen()));
                                      }
                                    } else {
                                      TeacherAppPopUps.submitFailed(
                                        title: "Failed",
                                        message: "You are not an authorized user.",
                                        actionName: "Close",
                                        iconData: Icons.error_outline,
                                        iconColor: Colorutils.svguicolour2,
                                      );
                                    }
                                    Get.put(()=>PageIndexController());
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.r),
                                    border: Border.all(
                                      color: Colorutils.userdetailcolor,
                                      width: 0.8,
                                    ),
                                  ),
                                  // width: 250.w,
                                  height: 50.h,
                                  child: Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset(
                                          height: 25.h,
                                          "assets/images/google_logo.png",
                                          fit: BoxFit.fitHeight,
                                        ),
                                        SizedBox(width: 8.w),
                                        Text(
                                          'Sign in with Google',
                                          style: GoogleFonts.inter(
                                            fontSize: 16.h,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 30.h),
                          if(Platform.isIOS)
                            Center(
                              child: Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 30).w,
                                child: GestureDetector(
                                  onTap: () async {
                                    context.loaderOverlay.show();
                                    await _handleAppleIn().then(
                                          (value) {
                                        if (userAuthController.isLoaded.value) {
                                          UserRole? userRole =
                                              userAuthController.userRole.value;
                                          if (userRole != null) {
                                            if (userRole == UserRole.leader) {
                                              List<String>? rolIds =
                                                  userAuthController.userData
                                                      .value.roleIds ??
                                                      [];
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                      const DrawerScreen()));
                                              // if((rolIds.contains("rolepri12") || rolIds.contains("role12123")) && !rolIds.contains("role121234")) {
                                              //   Navigator.push(
                                              //       context,
                                              //       MaterialPageRoute(
                                              //           builder: (context) =>
                                              //           const HosListing()));
                                              // } else {
                                              //   userAuthController
                                              //       .setSelectedHosData(
                                              //     hosName: userAuthController
                                              //         .userData.value.name ??
                                              //         '--',
                                              //     hosId: userAuthController
                                              //         .userData
                                              //         .value
                                              //         .userId ??
                                              //         '--',
                                              //     isHos: true,
                                              //   );
                                              //   Navigator.pushReplacement(
                                              //       context,
                                              //       MaterialPageRoute(
                                              //           builder: (context) =>
                                              //           const DrawerScreen()));
                                              // }
                                            }
                                            if (userRole ==
                                                UserRole.bothTeacherAndLeader) {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                      const ChoicePage()));
                                            }
                                            if (userRole == UserRole.teacher) {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                      const DrawerScreen()));
                                            }
                                          } else {
                                            TeacherAppPopUps.submitFailed(
                                              title: "Failed",
                                              message: "You are not an authorized user.",
                                              actionName: "Close",
                                              iconData: Icons.error_outline,
                                              iconColor: Colorutils.svguicolour2,
                                            );
                                          }
                                        }
                                      },
                                    );
                                    context.loaderOverlay.hide();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30.r),
                                      border: Border.all(
                                        color: Colorutils.userdetailcolor,
                                        width: 0.8,
                                      ),
                                    ),
                                    // width: 250.w,
                                    height: 50.h,
                                    child: Center(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.asset(
                                            height: 30.h,
                                            "assets/images/ic_apple.png",
                                            fit: BoxFit.fitHeight,
                                          ),
                                          SizedBox(width: 8.w),
                                          Text(
                                            'Sign in with Apple',
                                            style: GoogleFonts.inter(
                                              fontSize: 16.h,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          // SizedBox(height: 30.h),
                          // // const Spacer(),
                          SizedBox(
                            height: Platform.isIOS ? ScreenUtil().screenHeight * 0.04 : ScreenUtil().screenHeight * 0.07,
                          ),
                          Center(
                            child: Text(
                              ApiConstants.appVersion,
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 10.h,
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}

Future<void> checkInternet2(
    {required BuildContext context, required Function() function}) async {
  bool connected = await CheckConnectivity().check();
  print("internect connection is $connected");
  if (connected) {
    function();
  } else {
    TeacherAppPopUps.submitFailed(
      title: "Warning",
      message: "No internet connection. Please check your network and try again.",
      actionName: "Close",
      iconData: Icons.info_outline,
      iconColor: Colors.red,
    );
  }
}
