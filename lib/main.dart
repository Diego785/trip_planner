import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip_planner/blocs/blocs.dart';
import 'package:trip_planner/pages/recorrido_lineas.dart';
import 'package:trip_planner/screens/loading_screen.dart';

void main() {
  runApp(MultiBlocProvider(
    providers: [BlocProvider(create: (context) => GpsBloc())],
    child: const MainClass(),
  ));
}

class MainClass extends StatelessWidget {
  const MainClass({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trip Planner Project',
      debugShowCheckedModeBanner: false,
      initialRoute: 'home',
      routes: {
        'home': (_) => LoadingScreen(),
        'recorrido_lineas': (_) => RecorridoLineas()
      },
    );
  }
}
