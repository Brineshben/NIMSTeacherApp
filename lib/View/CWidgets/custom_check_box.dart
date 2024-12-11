

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCheckbox extends StatefulWidget {
  final Function? onChange;
  final bool? isChecked;
  final double? size;
  final double? iconSize;
  final Color? selectedColor;
  final Color? selectedIconColor;
  final Color? borderColor;
  final Icon? checkIcon;
  final BorderRadiusGeometry? borderRadius;

  const CustomCheckbox(
      {super.key,
        this.isChecked,
        this.onChange,
        this.size,
        this.iconSize,
        this.selectedColor,
        this.selectedIconColor,
        this.borderColor,
        this.checkIcon,
        this.borderRadius});

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  bool _isSelected = false;

  @override
  void initState() {
    _isSelected = widget.isChecked ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _isSelected = !_isSelected;
          widget.onChange!(_isSelected);
        });
      },
      child: AnimatedContainer(
        margin: const EdgeInsets.all(4),
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastLinearToSlowEaseIn,
        decoration: BoxDecoration(
            color: _isSelected
                ? widget.selectedColor ?? Colors.blue
                : Colors.transparent,
            borderRadius: widget.borderRadius,
            border: Border.all(
              color: widget.borderColor ?? widget.selectedColor ?? Colors.black,
              width: 1.w,
            )),
        width: widget.size?.w ?? 18.w,
        height: widget.size?.w ?? 18.w,
        child: _isSelected
            ? Icon(
          Icons.check,
          color: widget.selectedIconColor ?? Colors.white,
          size: widget.iconSize?.w ?? 14.w,
        )
            : null,
      ),
    );
  }
}