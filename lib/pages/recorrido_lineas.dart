import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip_planner/blocs/blocs.dart';
import 'package:trip_planner/views/map_view.dart';
import 'package:trip_planner/widgets/my_float_action_button.dart';
import 'package:trip_planner/widgets/my_searching_drawer.dart';
import 'package:trip_planner/widgets/widgets.dart';

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
      drawer: MySearchingDrawer(),
      body: BlocBuilder<LocationBloc, LocationState>(
        builder: (context, state) {
          if (state.lastKnownLocation == null) {
            return const Center(child: Text('Espere por favor...'));
          }

          return SingleChildScrollView(
            child: Stack(
              children: [
                MapView(initialLocation: state.lastKnownLocation!),
                //buttom para atras
                /*Positioned(
                  left: 15,
                  top: 15,
                  child: SafeArea(
                    child: CupertinoButton(
                      color: Colors.black26,
                      padding: const EdgeInsets.all(10),
                      borderRadius: BorderRadius.circular(40),
                      child: Icon(Icons.arrow_back_outlined),
                      onPressed: () {
                        Navigator.pushNamed(context, 'home');
                      },
                    ),
                  ),
                ),*/

                //BUSCADOR
                //const SearchBar(),
                Positioned(
                left: MediaQuery.of(context).size.width-68,
                top: MediaQuery.of(context).size.height-318,
                    child: SizedBox(
                    height: 50,
                    width: 50,
                      child: FloatingActionButton(
                  backgroundColor: Colors.green[800],
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  child: const Icon(
                      Icons.search,
                  ),
                ),
                    )),
              ],
            ),
          );
        },
      ),
      // 4 BUTTOMS FLOTANTES
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: const [BtnCurrentLocation(), Btnprincipales()],
      ),
    );
  }
}
