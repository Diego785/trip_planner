import 'package:flutter/material.dart';
import 'package:trip_planner/ui/responsive.dart';
import 'package:trip_planner/widgets/dinamic_search.dart';

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
      drawer: Drawer(
        child: ListView(
          children: [
            Container(
              width: double.infinity,
              height: 2000,
              // color: Colors.white60,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                colors: [
                  Colors.green,
                  Colors.lightGreen,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              )),
              child: Expanded(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 30),
                      width: 150,
                      height: 150,
                      child: Image.asset("assets/logo.png"),
                    ),
                    const Text(
                      "Trip Planner SC",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 30,
                          color: Colors.white),
                    ),
                      
                    DinamicSearch(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.lightGreen[400],
        elevation: 3,
        title: const Text(
          ' Trip Planner Project',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // color: Colors.white60,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Colors.white,
            Colors.lightGreen,
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        )),
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
                  color: Colors.lightGreen[400],
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
                  color: Color.fromARGB(255, 209, 240, 174),
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
