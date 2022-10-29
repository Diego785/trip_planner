import 'package:flutter/material.dart';
import 'package:trip_planner/utils/responsive.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black45,
        backgroundColor: Colors.green[200],
        elevation: 1,
        title: const Text(
          'Trip Planner Project',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // color: Colors.white60,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.white, Color.fromARGB(255, 155, 211, 157)])),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              top: responsive.hp(50),
              child: MaterialButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'recorrido_lineas');
                  },
                  padding: EdgeInsets.all(15),
                  elevation: 3,
                  color: Colors.lightGreen,
                  child: Row(
                    children: const <Widget>[
                      Text(
                        'Buscar Rutas   ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Icon(
                        Icons.bus_alert,
                        color: Colors.white,
                      ),
                    ],
                  )),
            ),
            Positioned(
              top: responsive.hp(60),
              child: MaterialButton(
                  onPressed: () {},
                  padding: EdgeInsets.all(15),
                  elevation: 3,
                  color: Color.fromARGB(255, 198, 231, 159),
                  child: Row(
                    children: const <Widget>[
                      Text(
                        'Planificador de viaje  ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Icon(
                        Icons.place,
                        color: Colors.green,
                      ),
                    ],
                  )),
            ),
            Positioned(
              top: responsive.hp(70),
              child: MaterialButton(
                  onPressed: () {},
                  padding: EdgeInsets.all(15),
                  elevation: 3,
                  color: Color.fromARGB(255, 198, 231, 159),
                  child: Row(
                    children: const <Widget>[
                      Text(
                        'Visualizar plan de viaje ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Icon(
                        Icons.mode_of_travel,
                        color: Colors.green,
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
