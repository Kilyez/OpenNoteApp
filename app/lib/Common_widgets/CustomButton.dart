
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {Key? key,
      required this.child,
      required this.color,
      this.borderRadius = 6.0,
      this.height = 40.0,
      this.width = 177,
      required this.onPressed})
      : super(key: key);
  final double height;
  final double width;
  final Widget child;
  final Color color;
  final double borderRadius;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        child: child,
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: color,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadius)))),
    ));
  }
}
