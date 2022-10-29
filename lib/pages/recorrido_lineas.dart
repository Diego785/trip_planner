import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trip_planner/utils/responsive.dart';

class RecorridoLineas extends StatefulWidget {
  const RecorridoLineas({super.key});

  @override
  State<RecorridoLineas> createState() => _RecorridoLineasState();
}

class _RecorridoLineasState extends State<RecorridoLineas> {
  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    return Scaffold(
      body: Container(
          width: double.infinity,
          height: responsive.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.white, Color.fromARGB(255, 155, 211, 157)]),
          ),
          child: Stack(alignment: Alignment.center, children: <Widget>[
            Positioned(
              left: 15,
              top: 15,
              child: SafeArea(
                child: CupertinoButton(
                  color: Colors.black26,
                  padding: EdgeInsets.all(10),
                  borderRadius: BorderRadius.circular(40),
                  child: Icon(Icons.arrow_back_outlined),
                  onPressed: () {
                    Navigator.pushNamed(context, 'home');
                  },
                ),
              ),
            ),
          ])),
    );
  }
}
