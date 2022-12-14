import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip_planner/blocs/blocs.dart';

class GpsAccessScreen extends StatelessWidget {
  const GpsAccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Colors.white,
            Colors.lightGreen,
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        )),
        child: Center(child: BlocBuilder<GpsBloc, GpsState>(
          builder: (context, state) {
            print('state: $state');
            return !state.isGpsEnabled
                ? const _EnableGpsMessage()
                : const _AccessButton();
          },
        )
            //  _AccessButton(),
            //  child: _EnableGpsMessage()
            ),
      ),
    );
  }
}

class _AccessButton extends StatelessWidget {
  const _AccessButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Es necesario el acceso a GPS'),
        MaterialButton(
            child: const Text(
              'Solicitar Acceso',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            color: Colors.lightGreen,
            shape: const StadiumBorder(),
            elevation: 0,
            splashColor: Colors.transparent,
            onPressed: () {
              final gpsBloc = BlocProvider.of<GpsBloc>(context);
              gpsBloc.askGpsAccess();
            })
      ],
    );
  }
}

class _EnableGpsMessage extends StatelessWidget {
  const _EnableGpsMessage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Debe de habilitar el GPS',
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
