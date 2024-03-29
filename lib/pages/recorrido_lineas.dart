import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_place/google_place.dart';
import 'package:trip_planner/blocs/blocs.dart';
import 'package:trip_planner/views/map_view.dart';
import 'package:trip_planner/widgets/my_searching_drawer.dart';
import 'package:trip_planner/widgets/widgets.dart';

class RecorridoLineas extends StatefulWidget {
  final int recorrido;
  final int par;
  final DetailsResult? startPosition;
  final DetailsResult? endPosition;
  const RecorridoLineas(
      this.recorrido, this.par, this.startPosition, this.endPosition,
      {super.key});

  @override
  State<RecorridoLineas> createState() => _RecorridoLineasState();
}

class _RecorridoLineasState extends State<RecorridoLineas> {
  late LocationBloc locationBloc;

  var recorridos = 0;
  var pares = 0;
  var origen = null;
  var destino = null;

  @override
  void initState() {
    int recorrido = widget.recorrido;
    int parImpar = widget.par;
    DetailsResult? startPosition = widget.startPosition;
    DetailsResult? endPosition = widget.endPosition;
    super.initState();
    locationBloc = BlocProvider.of<LocationBloc>(context);
    // locationBloc.getCurrentPosition();
    locationBloc.startFollowingUser();
    setState(() {
      recorridos = recorrido;
      pares = parImpar;
      origen = startPosition;
      destino = endPosition;
    });
  }

  @override
  void dispose() {
    locationBloc.stopFollowingUser();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MySearchingDrawer(),
      body: BlocBuilder<LocationBloc, LocationState>(
        builder: (context, state) {
          if (state.lastKnownLocation == null) {
            return const Center(child: Text('Espere por favor...'));
          }

          return Material(
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  MapView(recorridos, pares, origen, destino,
                      state.lastKnownLocation!),
                   Positioned(
                       left: MediaQuery.of(context).size.width - 68,
                       top: MediaQuery.of(context).size.height - 195,
                       child: SizedBox(
                         height: 50,
                         width: 50,
                         child: FloatingActionButton(
                           heroTag: 'btnDrawer',
                           backgroundColor: Colors.green[800],
                           onPressed: () => Scaffold.of(context).openDrawer(),
                           child: const Icon(
                             Icons.search,
                           ),
                         ),
                       )),
                ],
              ),
            ),
          );
        },
      ),
      // 4 BUTTONS FLOTANTES
       floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
       floatingActionButton: Column(
         mainAxisAlignment: MainAxisAlignment.end,
         children: const [Btnprincipales(), BtnCurrentLocation()],
       ),
    );
  }
}
