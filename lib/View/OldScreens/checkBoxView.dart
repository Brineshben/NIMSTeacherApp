
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teacherapp/Utils/Colors.dart';

class CheckBoxView extends StatefulWidget {
  final bool isChecked;
  final double size;
  final double borderRadius;

  const CheckBoxView({super.key, this.isChecked = true, this.size = 30, this.borderRadius = 13});

  @override
  _CheckBoxViewState createState() => _CheckBoxViewState();
}

class _CheckBoxViewState extends State<CheckBoxView> {
  @override
  Widget build(BuildContext context) {
    return widget.isChecked ? _getCheckedView() : _getUnCheckedView();
  }

  Widget _getCheckedView() => Container(
    width: widget.size.w,
    height: widget.size.w,
    decoration: BoxDecoration(
        borderRadius:
        BorderRadius.all(Radius.circular(widget.borderRadius)),
        border: Border.all(color: Colorutils.userdetailcolor, width: 1)),
    child: Icon(
      Icons.done,
      color: Colorutils.userdetailcolor,
      size: widget.size / 2,
    ),
  );

  Widget _getUnCheckedView() => Container(
    width: widget.size.w,
    height: widget.size.w,
    decoration: BoxDecoration(
        borderRadius:
        BorderRadius.all(Radius.circular(widget.borderRadius)),
        border: Border.all(color: Colorutils.userdetailcolor, width: 1)),
    child: Icon(
      Icons.done,
      color: Colors.transparent,
      size: widget.size / 2,
    ),
  );
}
