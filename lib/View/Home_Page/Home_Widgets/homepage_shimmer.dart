
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:teacherapp/View/Home_Page/Home_Widgets/my_class.dart';

class HomeScreenShimmer extends StatelessWidget {
  const HomeScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
       height: MediaQuery.of(context).size.height * 0.8,
       child: Column(
        children: [
         const  MyClass(),
         Shimmer.fromColors(
          baseColor: Colors.grey[200]!,
          highlightColor: Colors.grey[400]!,
           child: Column(
            children: [
               SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Container(
                    width: 160.w,
                  height: 130.w,
                     decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25).r,
                    color: Colors.lightBlue,
                  ),
                      margin: const EdgeInsets.only(top: 3, bottom: 4, left: 6, right: 4),
              
                  ),   Container(
                    width: 160.w,
                  height: 130.w,
                     decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25).r,
                    color: Colors.lightBlue,
                  ),
                      margin: const EdgeInsets.only(top: 3, bottom: 4, left: 6, right: 4),
              
                  ),   Container(
                    width: 160.w,
                  height: 130.w,
                     decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25).r,
                    color: Colors.lightBlue,
                  ),
                      margin: const EdgeInsets.only(top: 3, bottom: 4, left: 6, right: 4),
              
                  ),
                ],
              ),
            ),
            // SizedBox(height: 20.h,),
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 8).w,
              child: Row(
                children: [
                  Container(
                  height: 50.h,
                  width: 190.w,
                decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(15.0).r,
              ),
                  ),
                  SizedBox(width: 20.w,),
                  Container(
               height: 50.h,
                  width: 190.w,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(15.0).r,
              ),
                  ),
                ],
              ),
            ), 
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 8).w,
              child: Row(
                children: [
                  Container(
                  height: 50.h,
                  width: 190.w,
                decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(15.0).r,
              ),
                  ),
                  SizedBox(width: 20.w,),
                  Container(
               height: 50.h,
                  width: 190.w,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(15.0).r,
              ),
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 8).w,
              child: Row(
                children: [
                  Container(
                  height: 50.h,
                  width: 190.w,
                decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(15.0).r,
              ),
                  ),
                  SizedBox(width: 20.w,),
                  Container(
               height: 50.h,
                  width: 190.w,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(15.0).r,
              ),
                  ),
                ],
              ),
            ),
           
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 8).w,
              child: Row(
                children: [
                  Container(
                  height: 50.h,
                  width: 190.w,
                decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(15.0).r,
              ),
                  ),
                  SizedBox(width: 20.w,),
                  Container(
               height: 50.h,
                  width: 190.w,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(15.0).r,
              ),
                  ),
                ],
              ),
            ),
                SizedBox(height: 10,),
            Container(
              height: 200.h,
              width: 400.w,
            decoration:  BoxDecoration(
             color:  Colors.red,
             borderRadius:  BorderRadius.circular(12.r)
            ),
            )
            ],
           ),
         )
        ],
       ),
    );
  }
}