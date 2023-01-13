import 'dart:async';
import 'dart:ui' as ui;
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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
import 'package:trip_planner/implementation_cards/ui/contact_list_page.dart';
import 'package:trip_planner/implementation_cards/ui/widgets/perspective_list_view.dart';
import 'package:trip_planner/models/models.dart';
import 'package:trip_planner/models/punto.dart';
import 'package:trip_planner/pages/prueba.dart';
import 'package:trip_planner/providers/position_provider.dart';
import 'package:trip_planner/providers/providers.dart';
import 'package:trip_planner/services/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_place/google_place.dart';
import 'package:trip_planner/models/specific_line.dart';
import 'package:trip_planner/widgets/btnPrin.dart';
import 'package:trip_planner/widgets/btn_location.dart';

class MapView extends StatefulWidget {
  final int recorrido;
  final int par;
  final DetailsResult? startPosition;
  final DetailsResult? endPosition;
  //para la ultima localizacion del usuario
  final LatLng? initialLocation;
  const MapView(this.recorrido, this.par, this.startPosition, this.endPosition,
      this.initialLocation);

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
      []; // variable para traer los datos principales del micro através de una api
//List<LatLng> rutaMicro = [];

//Variables para listar los micros que pasan por origen y destino
  List<int> nearestMicrosOrigen = [];
  List<int> nearestMicrosDestiny = [];
  //Variables para guardar los micros que pasan por ambos puntos
  List<int> nearestMicrosOrigenOneRoute = [];
  // double distanceStartOneRoute = 0;
  List<double> distanceOneRoute = [];
  // double timeOneRouteStart = 0;
  List<double> timeOneRoute = [];

  bool trazarRuta = false;
  bool addPerson = false;
  bool loadingScreen = false;
  bool findMicro = false;
  String messageTitle = '';
  String messageSubtitle = '';

  double startPointLongi = 0;
  double startPointLati = 0;
  double endPointLongi = 0;
  double endPointLati = 0;

  List<PuntosModel> rutaSelected = [];
  List<LatLng> listaRutaSelected = [];

  var recorridos = 0;
  var origens = null;
  var destinos = null;
  LatLng? puntoOrigen;
  LatLng? puntoDestino;

  @override
  void initState() {
    final positionProvider =
        Provider.of<PositionProvider>(context, listen: false);
    int recorrido = widget.recorrido;
    int parImpar = widget.par;
    DetailsResult? origen = widget.startPosition;
    DetailsResult? destino = widget.endPosition;
    positionProvider.startPosition = widget.startPosition;
    positionProvider.endPosition = widget.endPosition;

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
        if (positionProvider.recorridosShowed == false) {
          positionProvider.startPositionLati =
              widget.startPosition!.geometry!.location!.lat!;
          positionProvider.startPositionLongi =
              widget.startPosition!.geometry!.location!.lng!;
          positionProvider.endPositionLati =
              widget.endPosition!.geometry!.location!.lat!;
          positionProvider.endPositionLongi =
              widget.endPosition!.geometry!.location!.lng!;
        }
        if (widget.recorrido == 0 && widget.par != 99) {
          loadData3();
        } else {
          trazarRecorrido();
        }
        // puntoOrigen = LatLng(widget.startPosition!.geometry!.location!.lat!,
        //                 widget.startPosition!.geometry!.location!.lng!);
        // puntoDestino = LatLng(widget.endPosition!.geometry!.location!.lat!,
        //                 widget.endPosition!.geometry!.location!.lng!);
      });
    }
    setState(() {
      recorridos = recorrido;
      origens = origen;
      destinos = destino;
    });
  }

  bool verifMicroRoute(List<int> micros, int recorridoId) {
    for (var i = 0; i < micros.length - 1; i++) {
      if (micros.indexOf(i) == recorridoId) {
        return true;
      }
    }

    return false;
  }

  List<int> purgarMicros(List<int> micros) {
    List<int> microsPurgados = [];

    for (var i = 1; i < micros.length; i++) {
      if (micros[i] != micros[i - 1]) {
        microsPurgados.add(micros[i - 1]);
      }
    }

    if (micros[micros.length - 1] !=
        microsPurgados[microsPurgados.length - 1]) {
      microsPurgados.add(micros[micros.length - 1]);
    }
    return microsPurgados;
  }

  //FUNCIÓN PARA LISTAR LOS MICROS QUE PASAN POR AMBOS PUNTOS, DE ORIGEN Y DESTINO
  verifOneRouteAndOrderOptimum(List<int> recorridos) async {
    List<int> microsOneRoute = [];
    List<double> distances = [];
    int recorridoController = 0;
    int parController = 0;
    double distance = 0;

    final positionProvider =
        Provider.of<PositionProvider>(context, listen: false);

    for (int i = 0; i < recorridos.length; i++) {
      if (recorridos[i] % 2 != 0) {
        parController = 1;
        recorridoController = ((recorridos[i] + 1) / 2).truncate();
      } else {
        parController = 2;
        recorridoController = (recorridos[i] / 2).truncate();
      }
      await PuntosService.getPuntos(recorridoController, parController)
          .then((puntos) {
        bool bandera = false;
        distance = 0;
        for (var i = 0; i < puntos.length - 1; i++) {
          if (Geolocator.distanceBetween(
                  double.parse(puntos[i].lati),
                  double.parse(puntos[i].longi),
                  positionProvider.startPositionLati,
                  positionProvider.startPositionLongi) <
              300) {
            bandera = true;
          }
          if (bandera) {
            distance = distance +
                Geolocator.distanceBetween(
                    double.parse(puntos[i].lati),
                    double.parse(puntos[i].longi),
                    double.parse(puntos[i + 1].lati),
                    double.parse(puntos[i + 1].longi));
          }

          if (Geolocator.distanceBetween(
                      double.parse(puntos[i].lati),
                      double.parse(puntos[i].longi),
                      positionProvider.endPositionLati,
                      positionProvider.endPositionLongi) <
                  300 &&
              bandera) {
            microsOneRoute.add(puntos[i].recorridoId);
            distances.add(distance);
            bandera = false;
          }
        }
      });
    }

    print(microsOneRoute);
    nearestMicrosOrigen.clear();
//ALGORITMO PARA ORDENAR LOS MICROS QUE HACEN MENOS RECORRIDO DESDE EL PUNTO DE ORIGEN AL PUNTO DE DESTINO
    for (int i = 0; i < distances.length; i++) {
      print(distanceOneRoute.length);
      if (distanceOneRoute.isEmpty) {
        distanceOneRoute.add(distances[i]);
        nearestMicrosOrigen.add(microsOneRoute[i]);
      } else {
        for (int j = 0; j < distanceOneRoute.length; j++) {
          if (distances[i] < distanceOneRoute[j]) {
            distanceOneRoute.insert(j, distances[i]);
            nearestMicrosOrigen.insert(j, microsOneRoute[i]);
            j = distanceOneRoute.length - 1;
          } else if (j == distanceOneRoute.length - 1) {
            distanceOneRoute.add(distances[i]);
            nearestMicrosOrigen.add(microsOneRoute[i]);
            j = distanceOneRoute.length - 1;
          }
        }
      }
    }
    // YA TENEMOS LOS MICROS QUE PASAN POR AMBOS PUNTOS, AHORA TENEMOS QUE ORDENARLOS PONIENDO DE PRIMERO AL QUE HACE UN MENOR RECORRIDO PARA LLEGAR DE UN PUNTO A OTRO
    print(distances);
    print(distanceOneRoute);
    print(microsOneRoute);
    print(nearestMicrosOrigen);
  }

//CREA LOS MARCADORES PRINCIPALES, UNA VEZ SELECCIONADO EL ORIGEN Y EL DESTINO
  loadData3() async {
//--------------------------------------------------------------------------------------------------------------------------------------------------
    print("Entró al load data 3");
    final positionProvider =
        Provider.of<PositionProvider>(context, listen: false);
    final Uint8List markerIcon = await getBytesFromAssets(images, 125);

    _markers2.add(Marker(
        markerId: const MarkerId('start'),
        position: LatLng(widget.startPosition!.geometry!.location!.lat!,
            widget.startPosition!.geometry!.location!.lng!),
        infoWindow: const InfoWindow(
          title: 'Origen',
        ),
        draggable: true,
        onDragEnd: (newPosition1) {
          // posicion1 = newPosition1;
          setState(() {
            positionProvider.startPositionLati = newPosition1.latitude;
            positionProvider.startPositionLongi = newPosition1.longitude;
            print('Primero');
            positionProvider.recorridoSelected = 0;
            positionProvider.recorridosShowed = false;
          });
        }));
    _markers2.add(Marker(
        markerId: const MarkerId('end'),
        position: LatLng(widget.endPosition!.geometry!.location!.lat!,
            widget.endPosition!.geometry!.location!.lng!),
        infoWindow: const InfoWindow(
          title: 'Destino',
        ),
        icon: BitmapDescriptor.fromBytes(markerIcon),
        draggable: true,
        onDragEnd: (newPosition2) {
          // posicion1 = newPosition1;
          setState(() {
            positionProvider.endPositionLati = newPosition2.latitude;
            positionProvider.endPositionLongi = newPosition2.longitude;
            print('Segundo');
            positionProvider.recorridoSelected = 0;
            positionProvider.recorridosShowed = false;
          });
        }));
  }

// ENCUENTRA LAS APROXIMACIONES, VERIFICA SI UN MICRO PASA POR DOS PUNTOS, CREA LOS MARCADORES Y LA POLYLINE
  loadData4() async {
    print("Entró al loadData4");

    final positionProvider =
        Provider.of<PositionProvider>(context, listen: false);

    // Find the nearest points to show the recommendations
    LatLng nearestPointStart = LatLng(0, 0);
    LatLng nearestPointEnd = LatLng(0, 0);

    // LatLng nearestPointStartOneBus = LatLng(0, 0);
    // LatLng nearestPointEndOneBus = LatLng(0, 0);

    if (positionProvider.startPositionLati == 0) {
      positionProvider.startPositionLati =
          widget.startPosition!.geometry!.location!.lat!;
    }
    if (positionProvider.startPositionLongi == 0) {
      positionProvider.startPositionLongi =
          widget.startPosition!.geometry!.location!.lng!;
    }
    if (positionProvider.endPositionLati == 0.0) {
      positionProvider.endPositionLati =
          widget.endPosition!.geometry!.location!.lat!;
    }
    if (positionProvider.endPositionLongi == 0.0) {
      positionProvider.endPositionLongi =
          widget.endPosition!.geometry!.location!.lng!;
    }
    setState(() {});

    await PuntosService.getAllPuntos().then((puntos) {
      puntos.reversed.forEach((element) {
        print(element.recorridoId);

        //VERIFICA QUE LOS MICROS PASEN POR EL PUNTO DE ORIGEN
        if ((Geolocator.distanceBetween(
                double.parse(element.lati),
                double.parse(element.longi),
                positionProvider.startPositionLati,
                positionProvider.startPositionLongi) <
            300)) {
          nearestMicrosOrigen.add(element.recorridoId);
        }
        if ((Geolocator.distanceBetween(
                double.parse(element.lati),
                double.parse(element.longi),
                positionProvider.endPositionLati,
                positionProvider.endPositionLongi) <
            300)) {
          nearestMicrosDestiny.add(element.recorridoId);
        }
      });
    });

    if (nearestMicrosOrigen.isEmpty || nearestMicrosDestiny.isEmpty) {
      setState(() {
        loadingScreen = false;
      });
      if (nearestMicrosOrigen.isEmpty) {
        messageTitle = '¡Algo no funcionó correctamente!';
        messageSubtitle = 'No se encontró micro por la zona de Origen';
      } else {
        findMicro = false;
        messageTitle = '¡Algo no funcionó correctamente!';
        messageSubtitle = 'No se encontró micro por la zona de Destino';
      }

      return;
    }

    nearestMicrosOrigen = purgarMicros(
        nearestMicrosOrigen); // AQUÍ YA SE TIENE LOS MICROS QUE PASAN POR EL PUNTO DE ORIGEN, SIN REPETIDOS

    nearestMicrosDestiny = purgarMicros(nearestMicrosDestiny);

    await verifOneRouteAndOrderOptimum(nearestMicrosOrigen);
    print(nearestMicrosOrigen);

    final Uint8List walking = await getBytesFromAssets(personWalking, 125);
    final Uint8List markerPoinRecomendations =
        await getBytesFromAssets(pointRecommendation, 125);
    final Uint8List markerIcon = await getBytesFromAssets(images, 125);
    final Uint8List markerbus = await getBytesFromAssets(bus, 125);

    //Recommendations
    _markers2.clear();

    _markers2.add(Marker(
      markerId: const MarkerId('start2'),
      position: LatLng(positionProvider.startPositionLati,
          positionProvider.startPositionLongi),
      infoWindow: const InfoWindow(
        title: 'Origen2',
      ),
      draggable: true,
    ));

    // _markers2.clear();

    _markers2.add(Marker(
      markerId: const MarkerId('end2'),
      position: LatLng(
          positionProvider.endPositionLati, positionProvider.endPositionLongi),
      infoWindow: const InfoWindow(
        title: 'Destino2',
      ),
      icon: BitmapDescriptor.fromBytes(markerIcon),
      draggable: true,
    ));

    if (nearestMicrosOrigen != null) {
      // Encuentra una sola ruta que lo lleva a destino con la lista de micros que pasa en el punto inicial.
      for (int i = 0; i < nearestMicrosOrigen.length; i++) {
        await LineServices.getMicro(nearestMicrosOrigen[i]).then((linea) {
          setState(() {
            microLinea.add(linea.last);
            //loadingScreen = false;
            // timeOneRouteStart = double.parse(((distanceStartOneRoute / microLinea.first.velocidad) * 60).toStringAsFixed(2));
          });
        });
      }
      microLinea.forEach((element) {
        print(element.toJson());
      });

      /*if (microLinea.length == 1) {
        positionProvider.recorridoSelected = microLinea.first.id;
        int? recorrido = 0;
        int? par = 0;
        if (positionProvider.recorridoSelected!.toDouble() % 2 == 0) {
          recorrido = (positionProvider.recorridoSelected! / 2).toInt();
          par = 2;
        } else {
          recorrido = ((positionProvider.recorridoSelected! + 1) / 2).toInt();
          par = 1;
        }

        int indexIni = -1;
        int indexFinal = -1;

        await PuntosService.getPuntos(recorrido, par).then((puntos) {
          setState(() {
            rutaSelected = puntos;
          });
        });

        print(rutaSelected);

        for (var i = 0; i < rutaSelected.length; i++) {
          if ((Geolocator.distanceBetween(
                      double.parse(rutaSelected[i].lati),
                      double.parse(rutaSelected[i].longi),
                      startPointLati,
                      startPointLongi) <
                  300) &&
              (Geolocator.distanceBetween(
                      double.parse(rutaSelected[i].lati),
                      double.parse(rutaSelected[i].longi),
                      startPointLati,
                      startPointLongi) <
                  Geolocator.distanceBetween(
                      double.parse(rutaSelected[i + 1].lati),
                      double.parse(rutaSelected[i + 1].longi),
                      startPointLati,
                      startPointLongi)) &&
              indexIni == -1) {
            indexIni = i;
          }
          if ((Geolocator.distanceBetween(
                      double.parse(rutaSelected[i].lati),
                      double.parse(rutaSelected[i].longi),
                      endPointLati,
                      endPointLongi) <
                  300) &&
              (Geolocator.distanceBetween(
                      double.parse(rutaSelected[i].lati),
                      double.parse(rutaSelected[i].longi),
                      endPointLati,
                      endPointLongi) <
                  Geolocator.distanceBetween(
                      double.parse(rutaSelected[i + 1].lati),
                      double.parse(rutaSelected[i + 1].longi),
                      endPointLati,
                      endPointLongi)) &&
              indexFinal == -1) {
            indexFinal = i;
          }
        }

        setState(() {
          rutaSelected = rutaSelected.sublist(indexIni, indexFinal);
          listaRutaSelected = listaLatLng(rutaSelected);
        });
        print(rutaSelected);
        for (int i = 0; i < listaRutaSelected.length; i++) {
          setState(() {});
          _polyline.add(Polyline(
              polylineId: PolylineId('9'),
              points: listaRutaSelected,
              color: Colors.green,
              width: 7,
              startCap: Cap.roundCap,
              endCap: Cap.roundCap));
        }
      }*/

      setState(() {
        loadingScreen = false;
      });

      /*  if (Geolocator.distanceBetween(nearestPointStart.latitude,
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
      }*/
    } else {
      // Aquí señalamos las dos rutas de los micros más próximos en cada punto, origen y destino.

      /* await PuntosService.transbordo(fid1, fid2).then((points) {
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
      ));*/
    }
  }

  verifExistMicros() async {}

  trazarRecorrido() async {
    print("Entró al trazar recorrido");
    final positionProvider =
        Provider.of<PositionProvider>(context, listen: false);

    final Uint8List walking = await getBytesFromAssets(personWalking, 125);
    final Uint8List markerPoinRecomendations =
        await getBytesFromAssets(pointRecommendation, 125);
    final Uint8List markerIcon = await getBytesFromAssets(images, 125);
    final Uint8List markerbus = await getBytesFromAssets(bus, 125);

    _markers2.clear();

    _markers2.add(Marker(
      markerId: const MarkerId('start3'),
      position: LatLng(positionProvider.startPositionLati,
          positionProvider.startPositionLongi),
      infoWindow: const InfoWindow(
        title: 'Origen3',
      ),
      draggable: true,
    ));

    // _markers2.clear();

    _markers2.add(Marker(
      markerId: const MarkerId('end3'),
      position: LatLng(
          positionProvider.endPositionLati, positionProvider.endPositionLongi),
      infoWindow: const InfoWindow(
        title: 'Destino3',
      ),
      icon: BitmapDescriptor.fromBytes(markerIcon),
      draggable: true,
    ));

    int? recorrido = 0;
    int? par = 0;
    if (positionProvider.recorridoSelected.toDouble() % 2 == 0) {
      recorrido = (positionProvider.recorridoSelected / 2).toInt();
      par = 2;
    } else {
      recorrido = ((positionProvider.recorridoSelected + 1) / 2).toInt();
      par = 1;
    }

    int indexIni = -1;
    int indexFinal = -1;

    await PuntosService.getPuntos(recorrido, par).then((puntos) {
      setState(() {
        rutaSelected = puntos;
      });
    });

    print(rutaSelected);

    for (var i = 0; i < rutaSelected.length - 1; i++) {
      if ((Geolocator.distanceBetween(
                  double.parse(rutaSelected[i].lati),
                  double.parse(rutaSelected[i].longi),
                  positionProvider.startPositionLati,
                  positionProvider.startPositionLongi) <
              300) &&
          (Geolocator.distanceBetween(
                  double.parse(rutaSelected[i].lati),
                  double.parse(rutaSelected[i].longi),
                  positionProvider.startPositionLati,
                  positionProvider.startPositionLongi) <
              (Geolocator.distanceBetween(
                  double.parse(rutaSelected[i + 1].lati),
                  double.parse(rutaSelected[i + 1].longi),
                  positionProvider.startPositionLati,
                  positionProvider.startPositionLongi))) &&
          indexIni == -1) {
        indexIni = i;
      }
      if ((Geolocator.distanceBetween(
                  double.parse(rutaSelected[i].lati),
                  double.parse(rutaSelected[i].longi),
                  positionProvider.endPositionLati,
                  positionProvider.endPositionLongi) <
              300) &&
          (Geolocator.distanceBetween(
                  double.parse(rutaSelected[i].lati),
                  double.parse(rutaSelected[i].longi),
                  positionProvider.endPositionLati,
                  positionProvider.endPositionLongi) <
              (Geolocator.distanceBetween(
                  double.parse(rutaSelected[i + 1].lati),
                  double.parse(rutaSelected[i + 1].longi),
                  positionProvider.endPositionLati,
                  positionProvider.endPositionLongi))) &&
          indexFinal == -1) {
        indexFinal = i;
      }
    }

    int indexAuxi = 0;
    if (indexFinal < indexIni) {
      indexAuxi = indexIni;
      indexIni = indexFinal;
      indexFinal = indexAuxi;
    }

    setState(() {
      rutaSelected = rutaSelected.sublist(indexIni, indexFinal);
      listaRutaSelected = listaLatLng(rutaSelected);
    });
    print(rutaSelected);
    for (int i = 0; i < listaRutaSelected.length; i++) {
      setState(() {});
      _polyline.add(Polyline(
          polylineId: PolylineId('9'),
          points: listaRutaSelected,
          color: Colors.green,
          width: 7,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap));
    }

    setState(() {
      loadingScreen = false;
    });
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
      return Material(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: (loadingScreen == true)
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
                    Column(
                      children: [
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
                              onTap: () async {
                                setState(() {
                                  loadingScreen = true;
                                });
                                final positionProvider =
                                    Provider.of<PositionProvider>(context,
                                        listen: false);

                                if (positionProvider.recorridoSelected == 0 ||
                                    positionProvider.recorridosShowed ==
                                        false) {
                                  await loadData4();

                                  if (findMicro == false) {
                                    final snackBar = SnackBar(
                                      /// need to set following properties for best effect of awesome_snackbar_content
                                      elevation: 10,
                                      behavior: SnackBarBehavior.fixed,
                                      backgroundColor:
                                          ui.Color.fromRGBO(0, 0, 0, 0),
                                      content: AwesomeSnackbarContent(
                                        title: messageTitle,
                                        message: messageSubtitle,

                                        /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                        contentType: ContentType.failure,
                                      ),
                                    );

                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(snackBar);
                                    return;
                                  }

                                  positionProvider.micros = microLinea;
                                  positionProvider.distances = distanceOneRoute;
                                } else {
                                  microLinea = positionProvider.micros;
                                  distanceOneRoute = positionProvider.distances;
                                }

                                positionProvider.recorridoSelected = 99;
                                positionProvider.recorridosShowed = true;

                                setState(() {});
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => MicrosListPage(
                                            microLinea, distanceOneRoute)));
                              },
                            )),
                      ],
                    ),
                    Positioned(
                        left: MediaQuery.of(context).size.width - 68,
                        top: MediaQuery.of(context).size.height - 195,
                        child: SizedBox(
                          height: 50,
                          width: 50,
                          child: FloatingActionButton(
                            heroTag: 'btnDrawerRoute',
                            backgroundColor: Colors.green[800],
                            onPressed: () => Scaffold.of(context).openDrawer(),
                            child: const Icon(
                              Icons.search,
                            ),
                          ),
                        )),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 18,
                      height: MediaQuery.of(context).size.height - 15,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: const [
                              Btnprincipales(),
                              BtnCurrentLocation()
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
