import 'dart:async';

import 'package:flutter/cupertino.dart';

class SwapeToWidget extends StatefulWidget {
  const SwapeToWidget({
    super.key,
    required this.child,
    required this.function,
    required this.iconWidget,
  });
  final Widget child;
  final Widget iconWidget;

  final Function function;

  @override
  State<SwapeToWidget> createState() => _SwapeToWidgetState();
}

class _SwapeToWidgetState extends State<SwapeToWidget> {
  late ValueNotifier<double> value;

  @override
  void initState() {
    value = ValueNotifier(0.0);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        // print("woring = ${details.primaryVelocity!}");
        // if (details.primaryVelocity! > 1500) {
        //   // print("woring success = ${details.primaryVelocity!}");
        //   widget.function();
        // }
        if (value.value >= 45) {
          widget.function();
        }

        Timer.periodic(const Duration(milliseconds: 5), (timer) {
          if (value.value <= 0) {
            value.value += 10;
            if (value.value >= 0) {
              timer.cancel();
              value.value = 0;
            }
          } else {
            value.value -= 10;
            if (value.value <= 0) {
              timer.cancel();
              value.value = 0;
            }
          }
        });
      },
      onHorizontalDragUpdate: (details) {
        if (value.value >= 0 && value.value <= size.width / 8) {
          value.value = value.value + details.delta.dx;
          print("working value == $value");
        } else {
          value.value = value.value + details.delta.dx / 5;
        }
      },
      child: ValueListenableBuilder(
        valueListenable: value,
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(value, 0),
            child: IntrinsicHeight(
              child: Stack(
                children: [
                  Transform.translate(
                    offset: const Offset(-50, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [widget.iconWidget],
                    ),
                  ),
                  widget.child,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
