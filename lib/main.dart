import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/blocs/blocs.dart';
import 'package:trip_planner/implementation_cards/ui/contact_list_page.dart';
import 'package:trip_planner/pages/recorrido_lineas.dart';
import 'package:trip_planner/providers/position_provider.dart';
import 'package:trip_planner/providers/providers.dart';
import 'package:trip_planner/screens/loading_screen.dart';
import 'package:trip_planner/widgets/information_card.dart';

void main() {
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => GpsBloc()),
      BlocProvider(create: (context) => LocationBloc()),
      BlocProvider(create: (context) => MapBloc()),
    ],
    child: const MainClass(),
  ));
}

class MainClass extends StatelessWidget {
  const MainClass({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PuntosProvider()),
        ChangeNotifierProvider(create: (_) => PositionProvider())
      ],
      child: MaterialApp(
        title: 'Trip Planner Project',
        debugShowCheckedModeBanner: false,
        initialRoute: 'home',
        routes: {
          'home': (_) => const LoadingScreen(),
          // 'recorrido_lineas': (_) => RecorridoLineas()
        },
        //home: InformationCard(),
      ),
    );
  }
}
