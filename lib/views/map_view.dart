import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trip_planner/blocs/blocs.dart';
import 'package:trip_planner/complements/loading_page.dart';
import 'package:trip_planner/complements/loading_page2.dart';
import 'package:trip_planner/helpers/helpers.dart';
import 'package:trip_planner/models/models.dart';
import 'package:trip_planner/pages/prueba.dart';
import 'package:trip_planner/providers/providers.dart';
import 'package:trip_planner/services/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_place/google_place.dart';
import 'package:trip_planner/models/specific_line.dart';

class MapView extends StatefulWidget {
  final int recorrido;
  final int par;
  final DetailsResult? startPosition;
  final DetailsResult? endPosition;
  //para la ultima localizacion del usuario
  final LatLng initialLocation;
  const MapView(this.recorrido, this.par, this.startPosition, this.endPosition,
      {super.key, required this.initialLocation});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  Completer<GoogleMapController> _controller = Completer();
  List<PuntosModel> _puntos = [];
  List<PuntosModel> _puntos2 = [];

  final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(-17.782158, -63.180684),
    zoom: 12,
  );

  String? direccion;
  String? direccion2;
  String? direccion3;
  String? direccion4;
  String images = 'assets/destino bandera.png';
  String pointRecommendation = 'assets/pointRecommendation.png';
  String bus = 'assets/bus.png';
  String personWalking = 'assets/walking.png';

  Future<Uint8List> getBytesFromAssets(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  final Set<Marker> _markers = {};
  final Set<Marker> _markers2 = {};
  final Set<Polyline> _polyline = {};
  List<LatLng> latlng = [];
  List<LatLng> latlng2 = [];
  List<double> distances = [];

// Testing the shortest route
  List<LatLng> latlngStart = [];
  List<LatLng> latlngEnd = [];
  List<RutaModel> _puntosStart = [];

  List<LatLng> latlngStartOneRoute = [];
  List<LatLng> latlngEndOneRoute = [];
  List<PuntosModel>? _puntosStartOneRoute = [];
  List<PuntosModel>? _puntosEndOneRoute = [];
  List<SpecificLine> microLinea =
      []; // variable para traer los datos principales del micro atrav??s de una api
  double distanceStartOneRoute = 0;
  double distanceEndOneRoute = 0;
  double timeOneRouteStart = 0;
  double timeOneRouteEnd = 0;
  bool addPerson = false;
  bool loadingScreen = false;

  double startPointLongi = 0;
  double startPointLati = 0;
  double endPointLongi = 0;
  double endPointLati = 0;
  var recorridos = 0;
  var origens = null;
  LatLng? puntoOrigen;
  LatLng? puntoDestino;

  @override
  void initState() {
    int recorrido = widget.recorrido;
    int parImpar = widget.par;
    DetailsResult? origen = widget.startPosition;
    DetailsResult? destino = widget.endPosition;

    super.initState();
    if (recorrido != 0) {
      if (parImpar != 0) {
        PuntosService.getPuntos(recorrido, parImpar).then((puntos) {
          setState(() {
            _puntos = puntos;
            latlng = listaLatLng(_puntos);
            loadData();
          });
        });
        Provider.of<PuntosProvider>(context, listen: false)
            .setPunto(recorrido, parImpar);
      } else {
        PuntosService.getPuntos(recorrido, 1).then((puntos) {
          setState(() {
            _puntos = puntos;
            latlng = listaLatLng(_puntos);
            loadData();
          });
        });
        Provider.of<PuntosProvider>(context, listen: false)
            .setPunto(recorrido, 1);
        PuntosService.getPuntos(recorrido, 2).then((puntos) {
          setState(() {
            _puntos2 = puntos;
            latlng2 = listaLatLng(_puntos2);
            loadData2();
          });
        });
        Provider.of<PuntosProvider>(context, listen: false)
            .setPunto(recorrido, 2);
      }
    }
    if (origen != null) {
      setState(() {
        loadData3();
        // puntoOrigen = LatLng(widget.startPosition!.geometry!.location!.lat!,
        //                 widget.startPosition!.geometry!.location!.lng!);
        // puntoDestino = LatLng(widget.endPosition!.geometry!.location!.lat!,
        //                 widget.endPosition!.geometry!.location!.lng!);
      });
    }
    setState(() {
      recorridos = recorrido;
      origens = origen;
    });
  }

//RECORTA LA LISTA DE PUNTOS POR DONDE PASA EL MICRO DE ORIGEN, SIEMPRE Y CUANDO PASE TAMBI??N POR EL DESTINO. CREA UNA LISTA DESDE EL PUNTO DE ORIGEN AL PUNTO DE DESTINO.
  List<PuntosModel>? findRouteNearStart(List<PuntosModel> puntos,
      LatLng nearestPointStart, double endPointLati, double endPointLongi) {
    List<PuntosModel>? lista;
    double latiPosFinal = 0;
    double longiPosFinal = 0;

    int indexIni = puntos.indexWhere((element) =>
        double.parse(element.lati) == nearestPointStart.latitude &&
        double.parse(element.longi) == nearestPointStart.longitude);

    print("PUNTO M??S CERCANO AL INICIO: $nearestPointStart");
    int indexFinal = 0;
    int count = 0;
    double minimunDistance = 999999.9;
    puntos.forEach((element) {
      if (Geolocator.distanceBetween(double.parse(element.lati),
              double.parse(element.longi), endPointLati, endPointLongi) <
          minimunDistance) {
        minimunDistance = Geolocator.distanceBetween(double.parse(element.lati),
            double.parse(element.longi), endPointLati, endPointLongi);
        //indexFinal = count; // CHECK THIS

        print(element.lati);
        print(element.longi);
        latiPosFinal = double.parse(element.lati);
        longiPosFinal = double.parse(element.longi);
        print("COUNT: $count");
        print(
            "MINIMUN DISTANCE IN THE FIRST MICRO CROSSING THE DESTINY POINT: $minimunDistance");
      }
      count++;
    });

    indexFinal = puntos.indexWhere((element) =>
        double.parse(element.lati) == latiPosFinal &&
        double.parse(element.longi) == longiPosFinal);

    print(latiPosFinal);
    print('INDEX FINAL: $indexFinal');

    if (indexIni < indexFinal) {
      lista = puntos.sublist(indexIni, indexFinal);
    } else {
      lista = puntos.sublist(indexFinal, indexIni);
    }

    print(nearestPointStart);
    print("INITIAL POSTION IN THE INITIAL ROUTE: " + indexIni.toString());

    return (minimunDistance < 500) ? lista : null;
  }

//RECORTA LA LISTA DE PUNTOS POR DONDE PASA EL MICRO DE DESTINO, SIEMPRE Y CUANDO PASE TAMBI??N POR EL ORIGEN. CREA UNA LISTA DESDE EL PUNTO DE ORIGEN AL PUNTO DE DESTINO.
  List<PuntosModel>? findRouteNearEnd(List<PuntosModel> puntos,
      LatLng nearestPointEnd, double startPointLati, double startPointLongi) {
    List<PuntosModel>? lista;
    double latiPosIni = 0;
    double longiPosIni = 0;

    int indexFinal = puntos.indexWhere((element) =>
        double.parse(element.lati) == nearestPointEnd.latitude &&
        double.parse(element.longi) == nearestPointEnd.longitude);

    int indexIni = 0;
    int count = 0;

    double minimunDistance = 9999.9;
    puntos.forEach((element) {
      if (Geolocator.distanceBetween(double.parse(element.lati),
              double.parse(element.longi), startPointLati, startPointLongi) <
          minimunDistance) {
        minimunDistance = Geolocator.distanceBetween(double.parse(element.lati),
            double.parse(element.longi), startPointLati, startPointLongi);
        latiPosIni = double.parse(element.lati);
        longiPosIni = double.parse(element.longi);
        //indexIni = count;
        print(
            "MINIMUN DISTANCE IN THE FINAL MCIRO CROSSING THE INITIAL POINT: $minimunDistance");
      }
      count++;
    });

    indexIni = puntos.indexWhere((element) =>
        double.parse(element.lati) == latiPosIni &&
        double.parse(element.longi) == longiPosIni);
    if (indexIni < indexFinal) {
      lista = puntos.sublist(indexIni, indexFinal);
    } else {
      lista = puntos.sublist(indexFinal, indexIni);
    }

    print(nearestPointEnd);
    print("INITIAL POSITION IN THE ENDING ROUTE: " + indexFinal.toString());

    return (minimunDistance < 500) ? lista : null;
  }

//CREA LOS MARCADORES PRINCIPALES, UNA VEZ SELECCIONADO EL ORIGEN Y EL DESTINO
  loadData3() async {
//--------------------------------------------------------------------------------------------------------------------------------------------------
    final Uint8List markerIcon = await getBytesFromAssets(images, 125);

    _markers2.add(Marker(
        markerId: const MarkerId('start'),
        position: (startPointLati != 0 && startPointLongi != 0)
            ? LatLng(startPointLati, startPointLongi)
            : LatLng(widget.startPosition!.geometry!.location!.lat!,
                widget.startPosition!.geometry!.location!.lng!),
        infoWindow: const InfoWindow(
          title: 'Origen',
        ),
        draggable: true,
        onDragEnd: (newPosition1) {
          // posicion1 = newPosition1;
          startPointLati = newPosition1.latitude;
          startPointLongi = newPosition1.longitude;

          print('Primero');
          print(newPosition1.latitude.toString() +
              newPosition1.longitude.toString());
        }));
    _markers2.add(Marker(
        markerId: const MarkerId('end'),
        position: (endPointLati != 0 && endPointLongi != 0)
            ? LatLng(endPointLati, endPointLongi)
            : LatLng(widget.endPosition!.geometry!.location!.lat!,
                widget.endPosition!.geometry!.location!.lng!),
        infoWindow: const InfoWindow(
          title: 'Destino',
        ),
        icon: BitmapDescriptor.fromBytes(markerIcon),
        draggable: true,
        onDragEnd: (newPosition2) {
          // posicion1 = newPosition1;
          endPointLati = newPosition2.latitude;
          endPointLongi = newPosition2.longitude;
          print('Segundo');
          print(newPosition2.latitude.toString() +
              newPosition2.longitude.toString());
        }));
  }

// ENCUENTRA LAS APROXIMACIONES, VERIFICA SI UN MICRO PASA POR DOS PUNTOS, CREA LOS MARCADORES Y LA POLYLINE
  loadData4() async {
    print("Entr?? al loadData4");
    int fid1 = 0;
    int fid2 = 0;

    // Find the nearest points to show the recommendations
    LatLng nearestPointStart = LatLng(0, 0);
    LatLng nearestPointEnd = LatLng(0, 0);

    // LatLng nearestPointStartOneBus = LatLng(0, 0);
    // LatLng nearestPointEndOneBus = LatLng(0, 0);

    if (startPointLati == 0) {
      startPointLati = widget.startPosition!.geometry!.location!.lat!;
    }
    if (startPointLongi == 0) {
      startPointLongi = widget.startPosition!.geometry!.location!.lng!;
    }
    if (endPointLati == 0) {
      endPointLati = widget.endPosition!.geometry!.location!.lat!;
    }
    if (endPointLongi == 0) {
      endPointLongi = widget.endPosition!.geometry!.location!.lng!;
    }

    double menorStartLati = 999.9;
    double menorStartLongi = 999.9;
    double menorEndLati = 999.9;
    double menorEndLongi = 999.9;

    int micro = 0;
    int microFinal = 0;

    await PuntosService.getAllPuntos().then((puntos) {
      // final puntoMap = puntos.asMap();
      // recorrido_id = puntos.last.recorridoId;

      puntos.reversed.forEach((element) {
        // print(double.parse(element.lati).abs()- startPointLati.abs());

        print(element.recorridoId);

        if (((double.parse(element.lati).abs() - startPointLati.abs()).abs() <=
                menorStartLati &&
            (double.parse(element.longi).abs() - startPointLongi.abs()).abs() <=
                menorStartLongi)) {
          print(menorStartLati);
          menorStartLati =
              (double.parse(element.lati).abs() - startPointLati.abs()).abs();
          menorStartLongi =
              (double.parse(element.longi).abs() - startPointLongi.abs()).abs();
          nearestPointStart = LatLng(-double.parse(element.lati).abs(),
              -double.parse(element.longi).abs());
          micro = element.recorridoId;
          fid1 = element.id;
        }

        if ((double.parse(element.latiD).abs() - endPointLati.abs()).abs() <=
                menorEndLati &&
            (double.parse(element.longiD).abs() - endPointLongi.abs()).abs() <=
                menorEndLongi) {
          menorEndLati =
              (double.parse(element.latiD).abs() - endPointLati.abs()).abs();
          menorEndLongi =
              (double.parse(element.longiD).abs() - endPointLongi.abs()).abs();
          nearestPointEnd = LatLng(-double.parse(element.latiD).abs(),
              -double.parse(element.longiD).abs());
          microFinal = element.recorridoId;
          fid2 = element.id;
        }
      });
    });

// POR SI UN MICRO PASA POR LOS DOS PUNTOS
    int recorridoController = 0;
    int parController = 0;
    if (micro % 2 != 0) {
      parController = 1;
      recorridoController = ((micro + 1) / 2).truncate();
    } else {
      parController = 2;
      recorridoController = (micro / 2).truncate();
    }

    await PuntosService.getPuntos(recorridoController, parController)
        .then((puntos) {
      _puntosStartOneRoute = findRouteNearStart(
          puntos, nearestPointStart, endPointLati, endPointLongi);
      if (_puntosStartOneRoute != null) {
        latlngStartOneRoute = listaLatLng(_puntosStartOneRoute!);
        distanceStartOneRoute = listaLatLngDistance(_puntosStartOneRoute!);
        distanceStartOneRoute =
            double.parse((distanceStartOneRoute / 1000).toStringAsFixed(2));
      }
    });

    if (microFinal % 2 != 0) {
      parController = 1;
      recorridoController = ((microFinal + 1) / 2).truncate();
    } else {
      parController = 2;
      recorridoController = (microFinal / 2).truncate();
    }

    await PuntosService.getPuntos(recorridoController, parController)
        .then((puntos) {
      setState(() {
        _puntosEndOneRoute = findRouteNearEnd(
            puntos, nearestPointEnd, startPointLati, startPointLongi);
        if (_puntosEndOneRoute != null) {
          latlngEndOneRoute = listaLatLng(_puntosEndOneRoute!);
          distanceEndOneRoute = listaLatLngDistance(_puntosEndOneRoute!);
          distanceEndOneRoute =
              double.parse((distanceEndOneRoute / 1000).toStringAsFixed(2));
        }
      });
    });

    print("El punto de partida es $startPointLati , $startPointLongi.");
    print("El punto de llegada es $endPointLati , $endPointLongi.");
    print(
        'El punto m??s cercano al punto de inicio es: ($nearestPointStart) y le pertence a la linea con el recorrido $micro');
    print(
        'El punto m??s cercano al punto de finalizaci??n es: ($nearestPointEnd) y le pertenece a la l??nea con el recorrido $microFinal');

    final Uint8List walking = await getBytesFromAssets(personWalking, 125);
    final Uint8List markerPoinRecomendations =
        await getBytesFromAssets(pointRecommendation, 125);
    final Uint8List markerIcon = await getBytesFromAssets(images, 125);
    final Uint8List markerbus = await getBytesFromAssets(bus, 125);

    //Recommendations
    _markers2.clear();
    _markers2.add(Marker(
        markerId: const MarkerId('startPointRecommendation'),
        position: nearestPointStart,
        infoWindow: const InfoWindow(
          title: 'Origen Point Recommendation',
        ),
        icon: BitmapDescriptor.fromBytes(markerPoinRecomendations),
        draggable: true,
        onDragEnd: (newPosition3) {
          // posicion1 = newPosition1;
          print('Primero');
          print(newPosition3.latitude.toString() +
              newPosition3.longitude.toString());
        }));
    _markers2.add(Marker(
        markerId: const MarkerId('start'),
        position: LatLng(startPointLati, startPointLongi),
        infoWindow: const InfoWindow(
          title: 'Origen',
        ),
        draggable: true,
        onDragEnd: (newPosition1) {
          // posicion1 = newPosition1;
          startPointLati = newPosition1.latitude;
          startPointLongi = newPosition1.longitude;
          print('Primero');
          print(newPosition1.latitude.toString() +
              newPosition1.longitude.toString());
        }));

    // _markers2.clear();
    _markers2.add(Marker(
        markerId: const MarkerId('endPointRecommendation'),
        position: nearestPointEnd,
        infoWindow: const InfoWindow(
          title: 'Destiny Point Recommendation',
        ),
        icon: BitmapDescriptor.fromBytes(markerPoinRecomendations),
        draggable: true,
        onDragEnd: (newPosition4) {
          // posicion1 = newPosition1;
          print('Primero');
          print(newPosition4.latitude.toString() +
              newPosition4.longitude.toString());
        }));
    _markers2.add(Marker(
        markerId: const MarkerId('end'),
        position: LatLng(endPointLati, endPointLongi),
        infoWindow: const InfoWindow(
          title: 'Destino',
        ),
        icon: BitmapDescriptor.fromBytes(markerIcon),
        draggable: true,
        onDragEnd: (newPosition2) {
          // posicion1 = newPosition1;
          endPointLati = newPosition2.latitude;
          endPointLongi = newPosition2.longitude;
          print('Segundo');
          print(newPosition2.latitude.toString() +
              newPosition2.longitude.toString());
        }));

    if (_puntosStartOneRoute != null) {
      // Encuentra una sola ruta que lo lleva a destino con el micro que pasa en el punto inicial.
      await LineServices.getMicro(micro).then((linea) {
        setState(() {
          microLinea = linea;
          loadingScreen = false;
          timeOneRouteStart = double.parse(
              ((distanceStartOneRoute / microLinea.first.velocidad) * 60)
                  .toStringAsFixed(2));
        });
      });

      if (Geolocator.distanceBetween(nearestPointStart.latitude,
              nearestPointStart.longitude, startPointLati, startPointLongi) >
          300) {
        _markers2.add(Marker(
          markerId: const MarkerId('walking'),
          position: LatLng(startPointLati, startPointLongi),
          icon: BitmapDescriptor.fromBytes(walking),
          draggable: true,
        ));
      }

      for (int i = 0; i < latlngStartOneRoute.length; i++) {
        setState(() {});
        _polyline.add(Polyline(
            polylineId: PolylineId('3'),
            points: latlngStartOneRoute,
            color: Colors.green,
            width: 7,
            startCap: Cap.roundCap,
            endCap: Cap.roundCap));
      }
    } else if (_puntosEndOneRoute != null) {
      // Encuentra una sola ruta que pasa por el destino con un micro que pasa por el punto inicial

      await LineServices.getMicro(microFinal).then((linea) {
        setState(() {
          microLinea = linea;
          loadingScreen = false;
          timeOneRouteEnd = double.parse(
              ((distanceEndOneRoute / microLinea.first.velocidad) * 60)
                  .toStringAsFixed(2));
        });
      });

      for (int i = 0; i < latlngEndOneRoute.length; i++) {
        setState(() {});
        _polyline.add(Polyline(
            polylineId: PolylineId('4'),
            points: latlngEndOneRoute,
            color: Colors.green,
            width: 7,
            startCap: Cap.roundCap,
            endCap: Cap.roundCap));
      }
    } else {
      // Aqu?? se??alamos las dos rutas de los micros m??s pr??ximos en cada punto, origen y destino.

      await PuntosService.transbordo(fid1, fid2).then((points) {
        setState(() {
          _puntosStart = points;
          latlngStart = listaLatLng2(_puntosStart);
          loadingScreen = false;
        });
      });
      _markers2.add(Marker(
        markerId: MarkerId(0.toString()),
        position: latlngStart[0],
        // infoWindow: InfoWindow(
        //   title: 'Inicio $direccion',
        //   snippet: 'Linea de $lineaMicro de $camino',
        // ),
        icon: BitmapDescriptor.fromBytes(markerPoinRecomendations),
      ));
      bool bandera = true;
      for (int i = 0; i < latlngStart.length; i++) {
        if (_puntosStart[0].recorridoId != _puntosStart[i].recorridoId &&
            bandera) {
          _markers2.add(Marker(
            markerId: MarkerId(i.toString()),
            position: latlngStart[i],
            // infoWindow: InfoWindow(
            //   title: 'Inicio $direccion',
            //   snippet: 'Linea de $lineaMicro de $camino',
            // ),
            icon: BitmapDescriptor.fromBytes(markerbus),
          ));
          bandera = false;
        }
        setState(() {});
        _polyline.add(Polyline(
            polylineId: PolylineId('5'),
            points: latlngStart,
            color: Colors.green,
            width: 7,
            startCap: Cap.roundCap,
            endCap: Cap.roundCap));
      }
      int l = latlngStart.length - 1;
      _markers2.add(Marker(
        markerId: MarkerId(l.toString()),
        position: latlngStart[l],
        // infoWindow: InfoWindow(
        //   title: 'Inicio $direccion',
        //   snippet: 'Linea de $lineaMicro de $camino',
        // ),
        icon: BitmapDescriptor.fromBytes(markerPoinRecomendations),
      ));
    }
  }

  loadData() async {
    var color = _puntos[0].color;
    Color colores = Colors.green;
    switch (color) {
      case 'Blanco':
        {
          colores = Colors.white;
        }
        break;

      case 'Rojo':
        {
          colores = Colors.red;
        }
        break;

      case 'Azul':
        {
          colores = Colors.blue;
        }
        break;

      case 'Green':
        {
          colores = Colors.green;
        }
        break;

      case 'Celeste':
        {
          colores = Colors.lightBlue;
        }
        break;

      case 'Castano':
        {
          colores = Colors.orange[900]!;
        }
        break;
    }
    int lineaMicro = _puntos[0].lineaId;
    switch (lineaMicro) {
      case 1:
        {
          lineaMicro = 1;
        }
        break;

      case 2:
        {
          lineaMicro = 2;
        }
        break;

      case 3:
        {
          lineaMicro = 5;
        }
        break;

      case 4:
        {
          lineaMicro = 8;
        }
        break;

      case 5:
        {
          lineaMicro = 9;
        }
        break;

      case 6:
        {
          lineaMicro = 10;
        }
        break;

      case 7:
        {
          lineaMicro = 11;
        }
        break;

      case 8:
        {
          lineaMicro = 16;
        }
        break;

      case 9:
        {
          lineaMicro = 17;
        }
        break;

      case 10:
        {
          lineaMicro = 18;
        }
        break;
    }

    var camino = 'Ida';
    if (_puntos[0].recorridoId % 2 == 0) {
      camino = 'Vuelta';
    }

    int l = latlng.length - 1;
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latlng[0].latitude, latlng[0].longitude);
    direccion = placemarks.reversed.last.thoroughfare.toString();

    List<Placemark> placemarks2 =
        await placemarkFromCoordinates(latlng[l].latitude, latlng[l].longitude);
    direccion2 = placemarks2.reversed.last.thoroughfare.toString();

    final Uint8List markerIcon = await getBytesFromAssets(images, 125);

    _markers.add(Marker(
      markerId: MarkerId(0.toString()),
      position: latlng[0],
      infoWindow: InfoWindow(
        title: 'Inicio $direccion',
        snippet: 'Linea de $lineaMicro de $camino',
      ),
      icon: BitmapDescriptor.defaultMarker,
    ));
    for (int i = 0; i < latlng.length; i++) {
      setState(() {});
      _polyline.add(Polyline(
          polylineId: PolylineId('1'),
          points: latlng,
          color: colores,
          width: 7,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap));
    }
    _markers.add(Marker(
      markerId: MarkerId(l.toString()),
      position: latlng[l],
      infoWindow: InfoWindow(
        title: 'Fin $direccion2',
        snippet: 'Linea de $lineaMicro de $camino',
      ),
      icon: BitmapDescriptor.fromBytes(markerIcon),
    ));
  }

  loadData2() async {
    int lineaMicro = _puntos2[0].lineaId;
    switch (lineaMicro) {
      case 1:
        {
          lineaMicro = 1;
        }
        break;

      case 2:
        {
          lineaMicro = 2;
        }
        break;

      case 3:
        {
          lineaMicro = 5;
        }
        break;

      case 4:
        {
          lineaMicro = 8;
        }
        break;

      case 5:
        {
          lineaMicro = 9;
        }
        break;

      case 6:
        {
          lineaMicro = 10;
        }
        break;

      case 7:
        {
          lineaMicro = 11;
        }
        break;

      case 8:
        {
          lineaMicro = 16;
        }
        break;

      case 9:
        {
          lineaMicro = 17;
        }
        break;

      case 10:
        {
          lineaMicro = 18;
        }
        break;
    }

    var camino = 'Ida';
    if (_puntos2[0].recorridoId % 2 == 0) {
      camino = 'Vuelta';
    }

    int l = latlng2.length - 1;
    List<Placemark> placemarks3 = await placemarkFromCoordinates(
        latlng2[0].latitude, latlng2[0].longitude);
    direccion3 = placemarks3.reversed.last.thoroughfare.toString();

    List<Placemark> placemarks4 = await placemarkFromCoordinates(
        latlng2[l].latitude, latlng2[l].longitude);
    direccion4 = placemarks4.reversed.last.thoroughfare.toString();

    final Uint8List markerIcon2 = await getBytesFromAssets(images, 125);

    _markers.add(Marker(
      markerId: MarkerId(1.toString()),
      position: latlng2[0],
      infoWindow: InfoWindow(
        title: 'Inicio $direccion3',
        snippet: 'Linea de $lineaMicro de $camino',
      ),
      icon: BitmapDescriptor.defaultMarker,
    ));
    for (int i = 0; i < latlng.length; i++) {
      setState(() {});
      _polyline.add(Polyline(
          polylineId: PolylineId('2'),
          points: latlng2,
          color: Colors.black,
          width: 7,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap));
    }
    _markers.add(Marker(
      markerId: MarkerId(l.toString()),
      position: latlng2[l],
      infoWindow: InfoWindow(
        title: 'Fin $direccion4',
        snippet: 'Linea de $lineaMicro de $camino',
      ),
      icon: BitmapDescriptor.fromBytes(markerIcon2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);
    final size = MediaQuery.of(context).size;
    if (recorridos != 0) {
      //Lineas
      return SizedBox(
        width: size.width,
        height: size.height,
        child: Center(
            child: Consumer<PuntosProvider>(builder: (context, value, child) {
          if (value.punto == null) {
            return const LoadingPage2();
          }
          return GoogleMap(
            initialCameraPosition: _kGooglePlex,
            markers: _markers,
            compassEnabled: false,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            onMapCreated: (controller) =>
                mapBloc.add(OnMapInitialzedEvent(controller)),
            polylines: _polyline,
          );
        })),
      );
    } else if (origens != null) {
      //Buscador
      return SizedBox(
        width: size.width,
        height: size.height,
        child: (_markers2.isEmpty || loadingScreen == true)
            ? const LoadingPage2()
            : Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: _kGooglePlex,
                    markers: _markers2,
                    compassEnabled: false,
                    myLocationEnabled: true,
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: false,
                    polylines: _polyline,
                    onMapCreated: (controller) =>
                        mapBloc.add(OnMapInitialzedEvent(controller)),
                  ),
                  (microLinea.isNotEmpty)
                      ? Stack(
                          children: [
                            Container(
                              width: 800,
                              height: 130,
                              padding: EdgeInsets.symmetric(vertical: 5),
                              margin:
                                  EdgeInsets.only(top: 50, right: 50, left: 50),
                              decoration: BoxDecoration(
                                color: Colors.green[900],
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: ListTile(
                                title: Row(
                                  children: [
                                    Text(
                                      "L??nea: ",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      microLinea.first.code,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Distancia: ",
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        (distanceStartOneRoute != 0)
                                            ? Text(
                                                distanceStartOneRoute
                                                        .toString() +
                                                    " Km.",
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.white,
                                                    fontStyle:
                                                        FontStyle.italic),
                                              )
                                            : Text(
                                                distanceEndOneRoute.toString() +
                                                    " Km.",
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.white,
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Tiempo: ",
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        (timeOneRouteStart != 0)
                                            ? Text(
                                                timeOneRouteStart.toString() +
                                                    " min.",
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.white,
                                                    fontStyle:
                                                        FontStyle.italic),
                                              )
                                            : Text(
                                                timeOneRouteEnd.toString() +
                                                    " min.",
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.white,
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Velocidad: ",
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          microLinea.first.velocidad
                                                  .toString() +
                                              " Km/h",
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.white,
                                               fontStyle: FontStyle.italic),
                                        ),
                                      ],
                                    ),

                                    Row(
                                      children: [
                                        Text(
                                          "Informaci??n: ",
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          microLinea.first.telefono,
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.white,
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 150,
                                      child: Text(
                                        microLinea.first.descripcionMicro +
                                            ". " +
                                            microLinea.first.descripcionLinea,
                                        maxLines: 4,
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),

                                    // Text(
                                    //   "Descripci??n de la L??nea: " + microLinea.first.descripcionLinea,
                                    //   style: TextStyle(
                                    //       fontSize: 10,
                                    //       color: Colors.white,
                                    //       fontStyle: FontStyle.italic),
                                    // ),
                                  ],
                                ),
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(90),
                                  child: Image.asset(
                                    microLinea.first.foto,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    scale: 10,
                                  ),
                                ),
                                // trailing: Icon(
                                //   Icons.visibility,
                                //   color: Colors.white,
                                // ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              margin: EdgeInsets.only(
                                  top: 550, right: 100, left: 100),
                              decoration: BoxDecoration(
                                color: Colors.green[900],
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: ListTile(
                                title: const Text(
                                  "Ver Sugerencias",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontStyle: FontStyle.italic),
                                ),
                                trailing: Icon(
                                  Icons.visibility,
                                  color: Colors.white,
                                ),
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, 'recommendation');
                                },
                              ),
                            ),
                          ],
                        )
                      : Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          margin:
                              EdgeInsets.only(top: 450, right: 100, left: 100),
                          decoration: BoxDecoration(
                            color: Colors.green[900],
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: ListTile(
                            title: const Text(
                              "Ver Ruta ??ptima",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic),
                            ),
                            trailing: Icon(
                              Icons.visibility,
                              color: Colors.white,
                            ),
                            onTap: () {
                              setState(() {
                                loadData4();
                                loadingScreen = true;
                              });
                            },
                          ),
                        ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    margin: EdgeInsets.only(top: 550, right: 100, left: 100),
                    decoration: BoxDecoration(
                      color: Colors.green[900],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: const Text(
                        "Ver Sugerencias",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontStyle: FontStyle.italic),
                      ),
                      trailing: Icon(
                        Icons.visibility,
                        color: Colors.white,
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, 'recommendation');
                      },
                    ),
                  ),
                ],
              ),
      );
    } else {
      //Normal
      return SizedBox(
        width: size.width,
        height: size.height,
        child: GoogleMap(
          initialCameraPosition: _kGooglePlex,
          compassEnabled: false,
          myLocationEnabled: true,
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          onMapCreated: (controller) =>
              mapBloc.add(OnMapInitialzedEvent(controller)),
        ),
      );
    }
  }
}
