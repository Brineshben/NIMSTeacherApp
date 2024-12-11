import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:teacherapp/Controller/api_controllers/lessonLearningController.dart';
import 'package:teacherapp/View/Learning_Walk/learning_walk_widgets/rubrics_info.dart';
import '../../../Models/api_models/learning_observation_api_model.dart';
import '../../../Utils/Colors.dart';

class QuestionRadioObsfields extends StatefulWidget {
  const QuestionRadioObsfields({super.key});

  @override
  State<QuestionRadioObsfields> createState() => _QuestionRadioObsfieldsState();
}

class _QuestionRadioObsfieldsState extends State<QuestionRadioObsfields> {
  LessonLearningController lessonObservationController =
  Get.find<LessonLearningController>();
  List<int?> selectedValues = [];

  @override
  void initState() {
    selectedValues = List.generate(
        lessonObservationController.lessonObservationList.length, (_) => null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetX<LessonLearningController>(
      builder: (LessonLearningController controller) {
        List<ListElement> lessonObservationList = controller.lessonObservationList.value;
        return Column(
          children: [
            for (int i = 0; i < lessonObservationList.length; i++)
              Expanded(
                flex: 0,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 20.w, top: 5.h, right: 20.w, bottom: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 1),
                      ],
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    child: FormField(
                      // validator: (value) {
                      //   //print(value);
                      //   if (value != true) {
                      //     isvalid = false;
                      //     print('isvalid learning= false $isvalid');
                      //     return null;
                      //   } else {
                      //     isvalid = true;
                      //     print('isvalid learning= true $isvalid');
                      //   }
                      //   // return null;
                      // },
                      builder: (FormFieldState<bool> state) => Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: 10.w,
                              right: 5,
                              top: 15.h,
                              bottom: 20.h,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 20.h,
                                  width: 20.h,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Center(
                                    child: Text(
                                      (i + 1).toString(),
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                Expanded(
                                  child: Text(
                                      lessonObservationList[i].indicator ?? '--'),
                                )
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding:
                                EdgeInsets.only(left: 5.w, right: 5.w),
                                child: Container(
                                  // height: 170.h,
                                  width: 155.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    color: const Color(0xffFEE68B).withOpacity(0.2),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 15.h),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Theme(
                                              data: ThemeData(
                                                unselectedWidgetColor:
                                                Colors.red[700],
                                              ),
                                              child: Radio(
                                                activeColor: Colors.red[700],
                                                fillColor: WidgetStateProperty
                                                    .resolveWith((states) {
                                                  return Colors.red[700];
                                                }),
                                                value: 0,
                                                groupValue: selectedValues[i],
                                                onChanged: (int? value) {
                                                  setState(() {
                                                    selectedValues[i] = value;
                                                  });
                                                },
                                              ),
                                            ),
                                            const Text("N/A"),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Theme(
                                              data: ThemeData(
                                                unselectedWidgetColor:
                                                Colors.yellow[900],
                                              ),
                                              child: Radio(
                                                activeColor: Colors.yellow[900],
                                                fillColor: WidgetStateProperty
                                                    .resolveWith((states) {
                                                  return Colors.yellow[900];
                                                }),
                                                value: 3,
                                                groupValue: selectedValues[i],
                                                onChanged: (int? value) {
                                                  setState(() {
                                                    selectedValues[i] = value;
                                                  });
                                                },
                                              ),
                                            ),
                                            const Text("Weak"),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Theme(
                                              data: ThemeData(
                                                unselectedWidgetColor:
                                                Colors.yellow[700],
                                              ),
                                              child: Radio(
                                                activeColor: Colors.yellow[700],
                                                fillColor: WidgetStateProperty
                                                    .resolveWith((states) {
                                                  return Colors.yellow[700];
                                                }),
                                                value: 5,
                                                groupValue: selectedValues[i],
                                                onChanged: (int? value) {
                                                  setState(() {
                                                    selectedValues[i] = value;
                                                  });
                                                },
                                              ),
                                            ),
                                            const Text("Acceptable"),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                // height: 170.h,
                                width: 155.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  color: const Color(0xff79CF62).withOpacity(0.2),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(top: 15.h),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Theme(
                                            data: ThemeData(
                                              unselectedWidgetColor:
                                              Colors.green,
                                            ),
                                            child: Radio(
                                              activeColor: Colors.green,
                                              fillColor: WidgetStateProperty
                                                  .resolveWith((states) {
                                                return Colors.green;
                                              }),
                                              value: 7,
                                              groupValue: selectedValues[i],
                                              onChanged: (int? value) {
                                                setState(() {
                                                  selectedValues[i] = value;
                                                });
                                              },
                                            ),
                                          ),
                                          const Text("Good"),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Theme(
                                            data: ThemeData(
                                              unselectedWidgetColor:
                                              Colors.green[700],
                                            ),
                                            child: Radio(
                                              activeColor: Colors.green[700],
                                              fillColor: WidgetStateProperty
                                                  .resolveWith((states) {
                                                return Colors.green[700];
                                              }),
                                              value: 9,
                                              groupValue: selectedValues[i],
                                              onChanged: (int? value) {
                                                setState(() {
                                                  selectedValues[i] = value;
                                                });
                                              },
                                            ),
                                          ),
                                          const Text("Very Good"),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Theme(
                                            data: ThemeData(
                                              unselectedWidgetColor:
                                              Colors.green[900],
                                            ),
                                            child: Radio(
                                              activeColor: Colors.green[900],
                                              fillColor: WidgetStateProperty
                                                  .resolveWith((states) {
                                                return Colors.green[900];
                                              }),
                                              hoverColor:
                                              Colorutils.userdetailcolor,
                                              value: 10,
                                              groupValue: selectedValues[i],
                                              onChanged: (int? value) {
                                                setState(() {
                                                  selectedValues[i] = value;
                                                });
                                              },
                                            ),
                                          ),
                                          const Text("Outstanding"),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 12.w, top: 10.h),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RubricsInfo(rubricslessonob: lessonObservationList[i].rubrix ?? [])));
                                },
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.info_outline,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(
                                      width: 15.w,
                                    ),
                                    const Text(
                                      'Rubrics',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 12,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
