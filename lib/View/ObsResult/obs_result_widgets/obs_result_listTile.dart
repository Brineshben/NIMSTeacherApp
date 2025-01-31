import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../Controller/api_controllers/userAuthController.dart';
import '../../../Models/api_models/obs_result_api_model.dart';
import '../../../Utils/Colors.dart';
import '../../../Utils/api_constants.dart';
import '../Obsresult_display.dart';

class ObsResultListTile extends StatelessWidget {
  final ObsResultData? obsData;
  const ObsResultListTile({super.key, this.obsData});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ObsResultdisplay(
                      name: obsData?.observerName,
                      images: '',
                      loginedUserName: Get.find<UserAuthController>().userData.value.name,
                      Subject_name: obsData?.subjectName,
                      Doneby: obsData?.observerName,
                      Date: obsData?.dateOfObservation,
                      Observerid: obsData?.sId,
                    )));
      },
      child: Padding(
        padding:
            EdgeInsets.only(top: 10.h, left: 15.w, right: 15.w, bottom: 5.h),
        child: Container(
          height: 160.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10).r,
              color: Colorutils.chatcolor.withOpacity(0.05),
              border: Border.all(color: Colorutils.chatcolor)),
          child: Padding(
            padding: EdgeInsets.only(left: 8.w, top: 2.h),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 5.h),
                  child: Text(
                    capitalizeFirstLetters(obsData?.type),
                    style:
                        TextStyle(fontSize: 15.h, fontWeight: FontWeight.w900),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(45),
                      child: Container(
                        width: 50.h,
                        height: 50.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colorutils.chatcolor),
                        ),
                        child: Center(
                          child: CachedNetworkImage(
                            
                            imageUrl:
                                "${ApiConstants.downloadUrl}${Get.find<UserAuthController>().userData.value.image}",
                            errorWidget: (context, url, error) => Text(
                              obsData?.subjectName.toString().substring(0, 1) ??
                                  '--',
                              style: TextStyle(
                                  color: const Color(0xFFB1BFFF),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22.h),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: 200.w,
                              child: Text(
                                obsData?.subjectName ?? '--',
                                // 'Subject',
                                style: TextStyle(
                                    fontSize: 16.h,
                                    fontWeight: FontWeight.w700),
                              )),
                          SizedBox(
                            height: 5.h,
                          ),
                          SizedBox(
                              width: 230.w,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 70.w,
                                    child: Text(
                                      'Done By',
                                      // 'Observer Name',
                                      style: TextStyle(
                                          fontSize: 15.h,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                    child: Text(
                                      ':',
                                      // 'Observer',
                                      style: TextStyle(
                                        fontSize: 15.h,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 140.w,
                                    child: Text(
                                      obsData?.observerName ?? '--',
                                      // 'Observer',
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontSize: 15.h,
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                          SizedBox(
                            height: 5.h,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 70.w,
                                child: Text(
                                  'On',
                                  // 'Observer Name',
                                  style: TextStyle(
                                      fontSize: 15.h,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              SizedBox(
                                width: 10.w,
                                child: Text(
                                  ':',
                                  // 'Observer',
                                  style: TextStyle(
                                    fontSize: 15.h,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 140.w,
                                child: Text(
                                  " ${obsData?.dateOfObservation?.split('T')[0].split('-').last}-${obsData?.dateOfObservation?.split('T')[0].split('-')[1]}-${obsData?.dateOfObservation?.split('T')[0].split('-').first}",
                                  // 'Observer',
                                  style: TextStyle(
                                    fontSize: 15.h,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String capitalizeFirstLetters(String? sentence) {
    if (sentence == null || sentence.isEmpty) {
      return '--';
    }
    sentence.replaceAll(" ", "_");

    List<String> words = sentence.split('_');
    List<String> capitalizedWords = [];

    for (String word in words) {
      if (word.isNotEmpty) {
        String capitalizedWord =
            word[0].toUpperCase() + word.substring(1).toLowerCase();
        capitalizedWords.add(capitalizedWord);
      }
    }

    return capitalizedWords.join(' ');
  }
}
