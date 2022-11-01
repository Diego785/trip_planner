import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip_planner/blocs/blocs.dart';
import 'package:trip_planner/views/map_view.dart';

class RecorridoLineas extends StatefulWidget {
  const RecorridoLineas({super.key});

  @override
  State<RecorridoLineas> createState() => _RecorridoLineasState();
}

class _RecorridoLineasState extends State<RecorridoLineas> {
  late LocationBloc locationBloc;

  @override
  void initState() {
    super.initState();
    locationBloc = BlocProvider.of<LocationBloc>(context);
    // locationBloc.getCurrentPosition();
    locationBloc.startFollowingUser();
  }

  @override
  void dispose() {
    locationBloc.stopFollowingUser();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LocationBloc, LocationState>(
        builder: (context, state) {
          if (state.lastKnownLocation == null) {
            return const Center(child: Text('Espere por favor...'));
          }
          print('aqui estoy');
          return SingleChildScrollView(
            child: Stack(
              children: [
                MapView(initialLocation: state.lastKnownLocation!)

                // TODO: botones...
              ],
            ),
          );
        },
      ),
    );
  }
}
