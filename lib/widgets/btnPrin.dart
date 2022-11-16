import 'package:flutter/material.dart';
import 'package:trip_planner/pages/recorrido_lineas.dart';
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
            backgroundColor: Colors.white,
            maxRadius: 25,
            child: IconButton(
                icon: const Icon(
                  Icons.place,
                  color: Colors.black,
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
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            maxRadius: 25,
            child: IconButton(
                icon: const Icon(Icons.bus_alert, color: Colors.black),
                onPressed: () {}),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            maxRadius: 25,
            child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RecorridoLineas(
                          0,
                          0,
                          null, 
                          null
                      )
                    )
                  );
                }),
          ),
        ),
      ],
    );
  }
}
