import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shimmer/shimmer.dart';
import 'package:teacherapp/Utils/Colors.dart';
import 'package:teacherapp/View/ObsResult/obs_result_widgets/obs_result_listTile.dart';
import '../../Controller/api_controllers/obsResultController.dart';
import '../../Models/api_models/obs_result_api_model.dart';
import '../../Utils/constants.dart';
import '../CWidgets/AppBarBackground.dart';
import '../CWidgets/commons.dart';
import '../Home_Page/Home_Widgets/user_details.dart';

class ObsResult extends StatefulWidget {
  const ObsResult({super.key});

  @override
  State<ObsResult> createState() => _ObsResultState();
}

class _ObsResultState extends State<ObsResult> {
  ObsResultController obsResultController = Get.find<ObsResultController>();
   TextEditingController _obsSearchConroller =  TextEditingController();
  @override
  void initState() {
    initialize();
    super.initState();
  }

  Future<void> initialize() async {
  
    await obsResultController.fetchObsResultList();
    if (!mounted) return;
 
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemUiOverlayStyleLight,
      child: Scaffold(
          backgroundColor: Colors.white,
          body: SizedBox(
            height: ScreenUtil().screenHeight,
            width: ScreenUtil().screenWidth,
            child: Stack(
              children: [
                const AppBarBackground(),
                Positioned(
                  left: 0,
                  top: -10,
                  child: Container(
                    // height: 100.w,
                    width: ScreenUtil().screenWidth,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(17.0),
                    ),
                    child: const UserDetails(
                      shoBackgroundColor: false,
                      isWelcome: true,
                      bellicon: true,
                      notificationcount: true,
                    ),
                  ),
                ),
                Container(

                  margin: EdgeInsets.only(
                      left: 10.w, top: 120.h, right: 10.w),
                  height: ScreenUtil().screenHeight,
                  decoration: themeCardDecoration2,
                  child: RefreshIndicator(
                   color: Colorutils.userdetailcolor,
                    onRefresh: () async{
                     await initialize();
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 20.w, top: 20.w),
                          child: Row(
                            children: [
                              Text(
                                'Observation Result',
                                style: TextStyle(
                                    fontSize: 20.h,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(left: 20.w, top: 20.w,right: 20.w),
                          child: TextFormField(
                                  controller: _obsSearchConroller,
                                  onChanged: (value) {
                    
                                  obsResultController.filterList(text: value);
                                  },
                                  cursorColor: Colors.grey,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      hintStyle:
                                          const TextStyle(color: Colors.grey,),
                                      hintText: "Search by Observer Name or Date",
                                      prefixIcon: const Icon(
                                        Icons.search,
                                        color: Colorutils.userdetailcolor,
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 20.0),
                                      border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(2.0),
                                        ),
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colorutils.chatcolor,
                                            width: 1.0),
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(15)),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colorutils.chatcolor,
                                            width: 1.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15.0)),
                                      ),
                                      fillColor:
                                          Colorutils.chatcolor.withOpacity(0.15),
                                      filled: true),
                                ),
                        ),

                        GetX<ObsResultController>(
                          builder: (ObsResultController controller) {
                            List<ObsResultData> obsList =
                                controller.obsResultList.value;
                            // (controller.isLoading.value) {
                            //   return const Center(child: CircularProgressIndicator(color: Colors.teal));
                            // } else if
                           if(controller.isLoading.value) {
                            return  Expanded(
                              child: SizedBox(
                                height: 900.h,
                                child: ListView.builder(
                       
                                  itemCount: 10,
                                  
                                  
                                  itemBuilder: (context,index) {
                                    return const ObservationShimmer();
                                  }
                                ),
                              ),
                            );
                           }else if(!controller.connection.value){
                             return SizedBox(
                              height:  400.h,
                              child: ListView(
                                                  children :[
                                                    SizedBox(height: 200.h,),
                                                     Center(
                                                    child:   Text('Internet Not Connected..',style: TextStyle(
                                color:  Colors.red,fontSize: 19.h
                              )
                                                  ),
                                    )]
                                                ),
                             );
                           }  else if(controller.isError.value){
                            return  SizedBox(
                              height:  400.h,
                              child: ListView(
                                                  children :[
                                                    SizedBox(height: 200.h,),
                                                     Center(
                                                    child:   Text('Somthing Went Wrong.',style: TextStyle(
                                color:  Colors.red,fontSize: 19.h
                              )
                                                  ),
                                    )]
                                                ),
                             );
                           }  else if (!controller.isLoaded.value&&
                                obsList.isEmpty) {
                              return Expanded(
                                child: SizedBox(
                                  height: 900.h,
                                  child: ListView.builder(
                                    itemCount: 1,
                                      itemBuilder: (context, index) => Center(child: Image.asset("assets/images/nodata.gif")),
                                    ),
                                ),
                              );
                            } else if (!controller.isLoading.value &&
                                obsList.isNotEmpty) {
                              // return Column(
                                                            
                              //   children: [
                              //     for (int i = 0; i < obsList.length; i++)
                              //       ObsResultListTile(obsData: obsList[i]),
                              //   ],
                              // );
                              return Expanded(
                                child: SizedBox(
                                 height: 900.h,
                                  child: ListView.separated(
                                    separatorBuilder: (context, index) => const SizedBox(),
                                    
                                     itemCount: obsList.length,
                                    itemBuilder: (context,index){
                                 
                                     return ObsResultListTile(obsData: obsList[index]);
                                      
                                  }),
                                ),
                              );
                            } else if(obsResultController.obsResultList.isEmpty) {
                              return Center(child: Image.asset("assets/images/nodata.gif"));
                            }else{
                                    return Container();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

}


class ObservationShimmer extends StatelessWidget {
  const ObservationShimmer({super.key});

  @override
  Widget build(BuildContext context) {
     return SizedBox(
      height: 200.h,
       child: Padding(
         padding:EdgeInsets.only(top: 10.h, left: 15.w, right: 15.w, bottom: 5.h),
         child: Container(
           height:  160.h,
           
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color:  Colors.grey[50]!
            ),
            child: Shimmer.fromColors(baseColor: Colors.grey[200]!,
            highlightColor: Colors.grey[300]!,
              child: Column(
                children: [
                  SizedBox(height: 20.h,),
                Container(
                         height: 13.h,
                         width: 120.w,
                    
                         decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: Colors.lightBlue
                         ),
                         ),
                  SizedBox(height: 20.h,),
                  Row(
                    children: [
                      SizedBox(
                        width: 10.w,
                      ),
                      Container(
                        height: 45.h,
                        width: 45.w,
                    
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(45.r),
              
                        ),
                      ),
                      SizedBox(width: 10.w,),
                     
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                         Container(
                         height: 13.h,
                         width: 80.w,
                    
                         decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: Colors.lightBlue
                         ),
                         ),
                         SizedBox(height: 10.h,),
                             Row(
                               children: [
                                Container(
                         height: 13.h,
                         width: 80.w,
                    
                         decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: Colors.lightBlue
                         ),
                         ),
                         
                                 SizedBox(width: 20.w,),
                                Container(
                         height: 13.h,
                         width: 80.w,
                    
                         decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: Colors.lightBlue
                         ),
                         ),
                         
                               ],
                             ),
                             SizedBox(height: 10.h,),
                          Row(
                            children: [
                            Container(
                         height: 13.h,
                         width: 80.w,
                    
                         decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: Colors.lightBlue
                         ),
                         ),
                        SizedBox(height: 10.h,),
                                 SizedBox(width: 20.w,),
                             Container(
                         height: 13.h,
                         width: 80.w,
                    
                         decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: Colors.lightBlue
                         ),
                         ),
                            ],
                          ),
                        
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
         ),
       ),
     );
  }
}