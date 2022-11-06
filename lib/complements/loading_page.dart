import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
      width: double.infinity,
      height: double.infinity,
       decoration: const BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Colors.white,
                Colors.lightGreen,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            )),
        child:  Center(
          child: SpinKitCircle(
            size: 140,
            color: Colors.green[900],
          ),
        ),
      ),
    );
  }


}