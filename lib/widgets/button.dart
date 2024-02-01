import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    this.buttonText,
    this.buttonColor,
    this.buttonSize,
    this.buttonHeight, // Added buttonHeight property
    this.buttonWidth, // Added buttonWidth property
    this.textColor = Colors.white,
    this.borderColor = Colors.transparent,
    this.onTap,
    this.icon,
    this.isCircular = false,
  });

  final String? buttonText;
  final Color? buttonColor;
  final double? buttonSize;
  final double? buttonHeight; // Added buttonHeight property
  final double? buttonWidth; // Added buttonWidth property
  final Color? textColor;
  final Color? borderColor;
  final Function()? onTap;
  final Icon? icon;
  final bool isCircular;

  @override
  Widget build(BuildContext context) {
    Widget? buttonContent = buttonText != null
        ? Text(
            buttonText!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "Kameron",
              fontSize: 35.spMin,
              color: textColor ?? Colors.white,
            ),
          )
        : (icon ?? const SizedBox());

    return GestureDetector(
      onTap: onTap,
      child: isCircular
          ? ClipOval(
              child: Container(
                width: buttonSize ?? 50.0.w,
                height: buttonSize ?? 50.0.h,
                decoration: BoxDecoration(
                  border: Border.all(color: borderColor ?? Colors.transparent),
                  color: buttonColor ?? Colors.transparent,
                ),
                child: Center(child: buttonContent),
              ),
            )
          : Container(
              width:
                  buttonWidth ?? double.infinity.w, // Default width is infinity
              height: buttonHeight ?? 50.0.h, // Default height is 50.0
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.r),
                border: Border.all(color: borderColor ?? Colors.transparent),
                color: buttonColor ?? Colors.transparent,
              ),
              child: Center(child: buttonContent),
            ),
    );
  }
}
