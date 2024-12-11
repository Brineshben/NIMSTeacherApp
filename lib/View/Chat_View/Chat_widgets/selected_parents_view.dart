import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:teacherapp/Services/warning_dialog.dart';
import 'package:teacherapp/View/Chat_View/Chat_widgets/parent_select_bottomSheet.dart';

import '../../../Controller/api_controllers/feedViewController.dart';
import '../../../Models/api_models/parent_list_api_model.dart';
import '../../../Utils/font_util.dart';

class SelectedParentsList extends StatelessWidget {
  const SelectedParentsList({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FeedViewController>(
      builder: (FeedViewController controller) {
        List<ParentDataSelected> selectedParents =
            controller.showSelectedParentDataStack;
        int stackLength = controller.showSelectedParentDataStack.length > 5
            ? 4
            : selectedParents.length;
        double stackWidth = stackLength * 44;
        return controller.showSelectedParentDataStack.isEmpty
            ? const SizedBox()
            : Row(
                children: [
                  SizedBox(width: 5.w),
                  InkWell(
                    onTap: () {
                      print("object");
                      // controller.unselectAll();

                      showParentRemoveWarningDialog(
                        context: context,
                        function: () {
                          controller.unselectAll();
                          // controller.selectAllParents();
                          // controller.selectedDoneFunction();
                          // //for updating showSelectedParentDataStack //
                        },
                      );
                    },
                    child: Container(
                      width: 20,
                      height: 20,
                      padding: const EdgeInsets.all(4).w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8).r,
                      ),
                      child: const FittedBox(
                          child: Icon(Icons.close, color: Color(0xFF118376))),
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    "Selected",
                    style: TeacherAppFonts.interW400_14sp_textWhite.copyWith(
                      fontSize: 12.sp,
                      color: const Color(0xFF118376),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    // "${selectedParents.length}",
                    "${controller.showSelectedParentDataStack.length}",
                    style: TeacherAppFonts.interW600_12sp_timecolortopicsOp80
                        .copyWith(
                      color: const Color(0xFF118376),
                    ),
                  ),
                  Text(
                    controller.showSelectedParentDataStack.length == 1
                        ? " Parent"
                        : " Parents",
                    style: TeacherAppFonts.interW600_12sp_timecolortopicsOp80
                        .copyWith(
                      color: const Color(0xFF118376),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  SizedBox(
                    width: 22 +
                        (44 *
                            (controller.showSelectedParentDataStack.length > 5
                                    ? 4
                                    : controller
                                        .showSelectedParentDataStack.length)
                                .toDouble()),
                    height: 32,
                    child: Stack(
                      children: [
                        ...List.generate(
                          controller.showSelectedParentDataStack.length > 5
                              ? 4
                              : controller.showSelectedParentDataStack.length,
                          (index) {
                            return Positioned(
                              left: index * 20,
                              child: CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 14,
                                  backgroundColor: Colors.grey.withOpacity(0.2),
                                  child: CachedNetworkImage(
                                    imageUrl: controller
                                            .showSelectedParentDataStack[index]
                                            .image ??
                                        '',
                                    errorWidget: (context, url, error) {
                                      return const Icon(Icons.person,
                                          color: Colors.grey);
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        Positioned(
                          left:
                              (controller.showSelectedParentDataStack.length > 5
                                      ? 4
                                      : controller
                                          .showSelectedParentDataStack.length) *
                                  20,
                          child: InkWell(
                            onTap: () {
                              controller.showParentListFilteredToSelectedList();
                              showModalBottomSheet(
                                barrierColor: Colors.transparent,
                                context: context,
                                backgroundColor: Colors.transparent,
                                isScrollControlled: true,
                                builder: (context) {
                                  return ParentSelectionBottomSheet();
                                },
                              );
                            },
                            child: const CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 14,
                                backgroundColor: Color(0xFF118376),
                                child: Center(
                                  child: SizedBox(
                                    height: 15,
                                    width: 15,
                                    child: FittedBox(
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
      },
    );
  }
}
