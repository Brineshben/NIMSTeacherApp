
import 'package:flutter/material.dart';
import 'package:teacherapp/View/Leave_Page/leave_approval.dart';
import 'package:teacherapp/View/OldScreens/reportListScreen.dart';
import '../../View/Chat_List/chat_list.dart';
import '../../View/Home_Page/leader_home.dart';
import '../../View/Home_Page/teacher_home.dart';
import '../../View/Leave_Page/Leave_Request.dart';
import '../../View/MorePage/more_page.dart';
import '../../View/MyTimeTable/TimeTableScreen.dart';
import '../../View/ObsResult/obs_result.dart';
import '../../View/Reports/report_page.dart';

class MenuItemsModel {
  final int index;
  final String title;
  final String svg;
  final Widget page;
  const MenuItemsModel({required this.index, required this.title, required this.svg, required this.page});
}

List<MenuItemsModel> leaderMenuItems = [
  const MenuItemsModel(index: 0, title: "Home", svg: "assets/images/house-bottom.svg", page: Leader()),
  const MenuItemsModel(index: 1, title: "Leave", svg: "assets/images/clock-three 1.svg", page: LeaveApproval()),
  const MenuItemsModel(index: 2, title: "Chat", svg: "assets/images/chat_selected_icon.svg", page: ChatWithParentsPage()),
  const MenuItemsModel(index: 3, title: "Reports", svg: "assets/images/leaderboard-svgrepo-com.svg", page: ReportListView()),
  const MenuItemsModel(index: 4, title: "More", svg: "assets/images/apps 2.svg", page: MorePage()),
  const MenuItemsModel(index: 0, title: "Home", svg: "assets/images/house-bottom.svg", page: Leader()),
  const MenuItemsModel(index: 3, title: "Reports", svg: "assets/images/leaderboard-svgrepo-com.svg", page: ReportListView()),
  const MenuItemsModel(index: 1, title: "Leave Approval", svg: "assets/images/levae_approval.svg", page: LeaveApproval()),
];

List<MenuItemsModel> teacherMenuItems = [
  const MenuItemsModel(index: 0, title: "Home", svg: "assets/images/house-bottom.svg", page: Teacher()),
  const MenuItemsModel(index: 1, title: "Leave", svg: "assets/images/clock-three 1.svg", page: LeaveRequest()),
  const MenuItemsModel(index: 2, title: "Chat", svg: "assets/images/chat_selected_icon.svg", page: ChatWithParentsPage()),
  const MenuItemsModel(index: 3, title: "OBS Result", svg: "assets/images/chart-pie-alt.svg", page: ObsResult()),
  const MenuItemsModel(index: 4, title: "More", svg: "assets/images/apps 2.svg", page: MorePage()),
  const MenuItemsModel(index: 0, title: "Home", svg: "assets/images/house-bottom.svg", page: Teacher()),
  const MenuItemsModel(index: 6, title: "My Timetable", svg: "assets/images/timetable.svg", page: MyTimeTable()),
  const MenuItemsModel(index: 1, title: "Leave Apply", svg: "assets/images/clock-three 1.svg", page: LeaveRequest()),
  const MenuItemsModel(index: 8, title: "Leave Approval", svg: "assets/images/levae_approval.svg", page: LeaveApproval()),
  const MenuItemsModel(index: 3, title: "OBS Result", svg: "assets/images/chart-pie-alt.svg", page: ObsResult()),
];

List<MenuItemsModel> choiceTeacherMenuItems = [
  const MenuItemsModel(index: 0, title: "Home", svg: "assets/images/house-bottom.svg", page: Teacher()),
  // const MenuItemsModel(index: 1, title: "Leave", svg: "assets/images/clock-three 1.svg", page: LeaveRequest()),
  const MenuItemsModel(index: 1, title: "OBS Result", svg: "assets/images/chart-pie-alt.svg", page: ObsResult()),
  const MenuItemsModel(index: 2, title: "Chat", svg: "assets/images/chat_selected_icon.svg", page: ChatWithParentsPage()),
  const MenuItemsModel(index: 3, title: "More", svg: "assets/images/apps 2.svg", page: MorePage()),
  const MenuItemsModel(index: 0, title: "Home", svg: "assets/images/house-bottom.svg", page: Teacher()),
  const MenuItemsModel(index: 5, title: "My Timetable", svg: "assets/images/timetable.svg", page: MyTimeTable()),
  // const MenuItemsModel(index: 7, title: "Leave Apply", svg: "assets/images/clock-three 1.svg", page: LeaveRequest()),
  const MenuItemsModel(index: 1, title: "OBS Result", svg: "assets/images/chart-pie-alt.svg", page: ObsResult()),
];