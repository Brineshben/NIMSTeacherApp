import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:teacherapp/Utils/Colors.dart';

import '../../Controller/api_controllers/hierarchController.dart';
import '../../Models/api_models/HierarchyModel.dart';

class Supervisorsearch extends StatefulWidget {
  final Function(Users) selectedName;

  const Supervisorsearch({super.key, required this.selectedName});

  @override
  State<Supervisorsearch> createState() => _SupervisorsearchState();
}

class _SupervisorsearchState extends State<Supervisorsearch>
    with SingleTickerProviderStateMixin {
  bool select1 = false;
  bool select2 = false;
  bool select3 = false;
  bool select4 = false;
  bool select5 = false;
  late TabController _tabController1;

  @override
  void initState() {
    super.initState();
    _tabController1 = TabController(length: 5, vsync: this);
    initialize();
    setState(() {
      select1 = _tabController1.index == 0;
      select2 = _tabController1.index == 1;
      select3 = _tabController1.index == 2;
      select4 = _tabController1.index == 3;
      select5 = _tabController1.index == 4;
    });
    _tabController1.addListener(() {
      setState(() {
        select1 = _tabController1.index == 0;
        select2 = _tabController1.index == 1;
        select3 = _tabController1.index == 2;
        select4 = _tabController1.index == 3;
        select5 = _tabController1.index == 4;
      });
    });
  }

  @override
  void dispose() {
    _tabController1.dispose();
    super.dispose();
  }

  Future<void> initialize() async {
    context.loaderOverlay.show();
    // leaveApprovalController.resetStatus();
    if (!mounted) return;
    context.loaderOverlay.hide();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.95),
      body: SafeArea(
        child: Column(children: [
          SizedBox(
            height: 60,
            child: Row(
              children: [
                Padding(
                    padding: const EdgeInsets.only(left: 18),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(
                        Icons.arrow_back_outlined,
                        size: 30,
                      ),
                    )),
                const Spacer(
                  flex: 2,
                ),
                const Text(
                  "Select Hierarchy",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const Spacer(
                  flex: 3,
                ),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: TabBar(
                padding: EdgeInsets.zero,
                indicator: const BoxDecoration(),
                dividerHeight: 0,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                indicatorPadding: EdgeInsets.zero,
                // indicator: BoxDecoration(),
                controller: _tabController1,
                labelPadding: const EdgeInsets.symmetric(horizontal: 5),
                tabs: [
                  Tab(
                    child: Container(
                      height: 40.h,
                      width: (ScreenUtil().screenWidth - 66) * 1 / 4,
                      decoration: BoxDecoration(
                        color: select1
                            ? Colorutils.bottomnaviconcolor
                            : Colors.grey[500],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          'HOS',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.h,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      height: 40.h,
                      width: (ScreenUtil().screenWidth - 66) * 1 / 4,
                      decoration: BoxDecoration(
                        color: select2
                            ? Colorutils.bottomnaviconcolor
                            : Colors.grey[500],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          "HOD",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.h,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      height: 40.h,
                      width: (ScreenUtil().screenWidth - 66) * 1 / 4,
                      decoration: BoxDecoration(
                        color: select3
                            ? Colorutils.bottomnaviconcolor
                            : Colors.grey[500],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          "SUPERVISOR",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.h,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      height: 40.h,
                      width: (ScreenUtil().screenWidth - 66) * 1.5 / 4,
                      decoration: BoxDecoration(
                        color: select4
                            ? Colorutils.bottomnaviconcolor
                            : Colors.grey[500],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          "PRINCIPAL",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.h,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      height: 40.h,
                      width: (ScreenUtil().screenWidth - 66) * 1.5 / 4,
                      decoration: BoxDecoration(
                        color: select5
                            ? Colorutils.bottomnaviconcolor
                            : Colors.grey[500],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          "VICE-PRINCIPAL",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.h,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Expanded(
            child: GetX<Hierarchcontroller>(
              builder: (Hierarchcontroller controller) {
                List<Users> Hoslist = controller.hosdata;
                List<Users> Hodlist = controller.hoddata;
                List<Users> Supervisorlist = controller.supervisordata;
                List<Users> Principallist = controller.principaldata;
                List<Users> Viceprincipallist = controller.viceprincidata;

                return TabBarView(
                  controller: _tabController1,
                  children: [
                    Hoslist.isNotEmpty
                        ? ListView.builder(
                            padding: const EdgeInsets.only(bottom: 70),
                            itemCount: Hoslist.length,
                            itemBuilder: (context, index) => GestureDetector(
                                  child:
                                      listcontainer1(HosList: Hoslist[index]),
                                  onTap: () {
                                    widget.selectedName(Users(
                                        sId: Hoslist[index].sId,
                                        name: Hoslist[index].name,
                                        role: "HOS"));
                                    Navigator.of(context).pop();
                                  },
                                ))
                        : const Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Center(
                                child: Text(
                              "Oops..No Data Found.",
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.red),
                            )),
                          ),
                    Hodlist.isNotEmpty
                        ? ListView.builder(
                            padding: const EdgeInsets.only(bottom: 70),
                            itemCount: Hodlist.length,
                            itemBuilder: (context, index) => GestureDetector(
                                  onTap: () {
                                    widget.selectedName(Users(
                                        sId: Hodlist[index].sId,
                                        name: Hodlist[index].name,
                                        role: "HOD"));
                                    Navigator.of(context).pop();
                                  },
                                  child:
                                      listcontainer1(HosList: Hodlist[index]),
                                ))
                        : const Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Center(
                                child: Text(
                              "Oops..No Data Found.",
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.red),
                            )),
                          ),
                    Supervisorlist.isNotEmpty
                        ? ListView.builder(
                            padding: const EdgeInsets.only(bottom: 70),
                            itemCount: Supervisorlist.length,
                            itemBuilder: (context, index) => GestureDetector(
                                  onTap: () {
                                    widget.selectedName(Users(
                                        sId: Supervisorlist[index].sId,
                                        name: Supervisorlist[index].name,
                                        role: "Supervisor"));
                                    Navigator.of(context).pop();
                                  },
                                  child: listcontainer1(
                                    HosList: Supervisorlist[index],
                                  ),
                                ))
                        : const Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Center(
                                child: Text(
                              "Oops..No Data Found.",
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.red),
                            )),
                          ),
                    Principallist.isNotEmpty
                        ? ListView.builder(
                            padding: const EdgeInsets.only(bottom: 70),
                            itemCount: Principallist.length,
                            itemBuilder: (context, index) => GestureDetector(
                                  onTap: () {
                                    widget.selectedName(Users(
                                        sId: Principallist[index].sId,
                                        name: Principallist[index].name,
                                        role: "Principal"));
                                    Navigator.of(context).pop();

                                  },
                                  child: listcontainer1(
                                      HosList: Principallist[index]),
                                ))
                        : const Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Center(
                                child: Text(
                              "Oops..No Data Found.",
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.red),
                            )),
                          ),
                    Viceprincipallist.isNotEmpty
                        ? ListView.builder(
                            padding: const EdgeInsets.only(bottom: 70),
                            itemCount: Viceprincipallist.length,
                            itemBuilder: (context, index) => GestureDetector(
                                  onTap: () {
                                    widget.selectedName(Users(
                                        sId: Viceprincipallist[index].sId,
                                        name: Viceprincipallist[index].name,
                                        role: "Vice-Principal"));
                                    Navigator.of(context).pop();
                                  },
                                  child: listcontainer1(
                                      HosList: Viceprincipallist[index]),
                                ))
                        : const Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Center(
                              child: Text(
                                "Oops..No Data Found.",
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.red),
                              ),
                            ),
                          )
                  ],
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}

class listcontainer1 extends StatelessWidget {
  final Users HosList;

  const listcontainer1({
    super.key,
    required this.HosList,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 8),
      child: Container(
        // height: 70.h,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.circle,
                        size: 8,
                        color: Colorutils.userdetailcolor,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 270.w,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Center(
                            child: Text("${HosList.name?.toUpperCase()}",
                                style: GoogleFonts.inter(
                                    textStyle: TextStyle(
                                        fontSize: 16.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600))),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
