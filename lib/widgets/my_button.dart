import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Color backgroundColor;
  final String text;
  final Color textColor;
  final void Function()? onTap;
  const MyButton({
    super.key,
    required this.backgroundColor,
    required this.text,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: MediaQuery.of(context).size.height / 14,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Center(
        child: ListTile(
          title: Center(
            child: Text(
              text,
              style: TextStyle(fontSize: 24, color: textColor),
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
