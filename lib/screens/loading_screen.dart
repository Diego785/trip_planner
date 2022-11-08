import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip_planner/pages/recorrido_lineas.dart';
import 'package:trip_planner/screens/screens.dart';
import 'package:trip_planner/blocs/blocs.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: BlocBuilder<GpsBloc, GpsState>(
      builder: (context, state) {
        return state.isAllGranted ? const RecorridoLineas(0, 0) : const GpsAccessScreen();
      },
    ));
  }
}
