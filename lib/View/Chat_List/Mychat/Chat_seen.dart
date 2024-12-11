
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:teacherapp/Utils/Colors.dart';

class SeenByBottomSheet extends StatelessWidget {
  SeenByBottomSheet({super.key});
  final List<Map<String, String>> seenByData = [
    {
      'name': 'Fatima bint Mohammed',
      'relationship': 'Daughter of Hassan  ',
      'date': '02/04/24',
      'time': '9:32PM',
      'image': 'assets/fatima.png'
    },
    {
      'name': 'Ali bin Omar',
      'relationship': 'Son of Hilal Ibrahim aqjsdhqwsuoi saqjlkidbhoiaqswdh saaoi udhbasd xasduoq',
      'date': '02/04/24',
      'time': '7:32PM',
      'image': 'assets/ali.png'
    },
    {
      'name': 'Aisha bint Ali',
      'relationship': 'Daughter of Bilal bin Saeed',
      'date': '02/04/24',
      'time': '5:32PM',
      'image': 'assets/aisha.png'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400.w,
      padding: EdgeInsets.only(top: 16,left: 8,),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(10)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 18.h,
                  width: 18.h,
                  child:
                  SvgPicture.asset("assets/images/Checks.svg"),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    'SEEN BY',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.0),
          Expanded(
            child: ListView.builder(
              itemCount: seenByData.length,
              itemBuilder: (context, index) {
                final user = seenByData[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(user['image']!),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: SingleChildScrollView(child: Text(user['name']!),

                        scrollDirection: Axis.horizontal,),
                         width: 160.w,
                      ),
                      Text(user['date']!,style: TextStyle(color: Colorutils.userdetailcolor,fontSize: 10),),
                    ],
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: SingleChildScrollView(child: Text(user['relationship']!,style: TextStyle(color: Colorutils.userdetailcolor,fontSize: 13),),

                          scrollDirection: Axis.horizontal,),
                        width: 160.w,
                      ),
                      Text(user['time']!,style: TextStyle(fontSize: 10),),

                    ],

                  ),


                );

              },

            ),
          ),
          Divider(
            thickness: 0.5,
          )
        ],
      ),
    );
  }
}