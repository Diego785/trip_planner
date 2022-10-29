import 'package:flutter/material.dart';
import 'package:trip_planner/pages/home.dart';
import 'package:trip_planner/pages/recorrido_lineas.dart';

void main() => runApp(const MainClass());

class MainClass extends StatelessWidget {
  const MainClass({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trip Planner Project',
      debugShowCheckedModeBanner: false,
      initialRoute: 'home',
      routes: {
        'home': (_) => HomePage(),
        'recorrido_lineas': (_) => RecorridoLineas(),
      },
    );
  }
}
