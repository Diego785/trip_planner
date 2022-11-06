import 'dart:ffi';

import 'package:flutter/material.dart';

class MyFloatActionButton extends StatelessWidget {
  final void Function()? onTap;
  final IconData icon;
  MyFloatActionButton({
    super.key,
    required this.onTap,
    required this.icon,
  });
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height - 180,
      left: MediaQuery.of(context).size.width - 80,
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.9),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 10), // changes position of shadow
          ),
        ]),
        width: 80,
        height: 80,
        color: Colors.green[800],
        child: InkWell(onTap: onTap, child: Icon(icon)),
      ),
    );
  }
}
