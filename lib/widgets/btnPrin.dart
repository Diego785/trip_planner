import 'package:flutter/material.dart';
import 'package:trip_planner/screens/screens.dart';

class Btnprincipales extends StatelessWidget {
  //VoidCallback? onOk;
  const Btnprincipales({
    Key? key,

    //   this.onOk = null,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: CircleAvatar(
            backgroundColor: Colors.green[800],
            maxRadius: 25,
            child: IconButton(
                icon: const Icon(
                  Icons.place,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context)=>SearchScreen(),
                      fullscreenDialog: true,
                    ),
                  );
                }),
          ),
        ),
      ],
    );
  }
}
