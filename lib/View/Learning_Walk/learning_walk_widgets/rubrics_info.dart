
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../Models/api_models/learning_observation_api_model.dart';

class RubricsInfo extends StatelessWidget {
  final List<Rubrix> rubricslessonob;
  const RubricsInfo({super.key,required this.rubricslessonob,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Container(child:Padding(
        padding: EdgeInsets.fromLTRB(20.w, 60.h, 20.w, 30.h),
        child: Container(
            padding: EdgeInsets.fromLTRB(10.w, 15.h, 10.w, 0),
            height: MediaQuery.of(context).size.height,
            // width: 360.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5).r,
              color: const Color(0xff312B47),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Rubrics', style: TextStyle(fontSize: 15,color: Colors.grey,fontWeight: FontWeight.w700)),
                  SizedBox(
                    height: 20.h,
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        for(int i = 0; i < rubricslessonob.length; i++)
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 7.h,
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.circle,color: Colors.deepPurpleAccent,),
                                      Padding(
                                        padding: EdgeInsets.only(left: 5.w, bottom: 5.h),
                                        child:
                                        Text(rubricslessonob[i].name?.toUpperCase() ?? '--', style: const TextStyle(fontSize: 14,color: Colors.grey,)),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.75,
                                    // width: 280.w,
                                    margin: const EdgeInsets.only(left: 30),
                                    child: Text(
                                      rubricslessonob[i].parameter ?? '--',style: const TextStyle(fontSize:12 ,color: Colors.grey,),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),

                      ],
                    ),
                  ),
                  SizedBox(height: 50.h),
                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 35.h,
                        width: 35.h,
                        decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(100),border: Border.all(color: Colors.grey)),
                        child: Icon(Icons.close,color: Colors.grey, size: 20.h,),
                      ),
                    ),
                  ),
                  SizedBox(height: 50.h),
                ],
              ),
            )),
      ),
      ),
    );
  }
}
