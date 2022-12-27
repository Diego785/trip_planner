import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  final Set<Marker> _markers3 = {};
  final Set<Polyline> _polyline = {};
  List<LatLng> latlng = [];
  List<LatLng> latlng2 = [];
  List<double> distances = [];
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
      //Lineas
      print('aaaa');
      print(parImpar.toString());
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

  loadData3() async {
    final Uint8List markerIcon = await getBytesFromAssets(images, 125);

    _markers3.add(Marker(
        markerId: const MarkerId('start'),
        position: LatLng(widget.startPosition!.geometry!.location!.lat!,
            widget.startPosition!.geometry!.location!.lng!),
        infoWindow: const InfoWindow(
          title: 'Origen',
        ),
        draggable: true,
        onDragEnd: (newPosition1) {
          puntoOrigen = newPosition1;
          // print('Primero');
          // print(puntoOrigen!.latitude.toString() + puntoOrigen!.longitude.toString());
        }));
    _markers3.add(Marker(
        markerId: const MarkerId('end'),
        position: LatLng(widget.endPosition!.geometry!.location!.lat!,
            widget.endPosition!.geometry!.location!.lng!),
        infoWindow: const InfoWindow(
          title: 'Destino',
        ),
        icon: BitmapDescriptor.fromBytes(markerIcon),
        draggable: true,
        onDragEnd: (newPosition2) {
          puntoDestino = newPosition2;
          // print('Segundo');
          // print(puntoDestino!.latitude.toString() + puntoDestino!.longitude.toString());
        }));
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
    if (_puntos[0].recorridosId % 2 == 0) {
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
    if (_puntos2[0].recorridosId % 2 == 0) {
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
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: _kGooglePlex,
              markers: _markers3,
              compassEnabled: false,
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              onMapCreated: (controller) =>
                  mapBloc.add(OnMapInitialzedEvent(controller)),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              margin: EdgeInsets.only(top: 650, right: 100, left: 100),
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
                  // print('Primero y Segundo');
                  // print(puntoOrigen!.latitude.toString() + puntoOrigen!.longitude.toString());
                  // print(puntoDestino!.latitude.toString() + puntoDestino!.longitude.toString());
                  // Navigator.pushNamed(context, 'recommendation');
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => Prueba(
                  //       puntoOrigen: puntoOrigen!,
                  //       puntoDestino: puntoDestino!,
                  //     )
                  //   )
                  // );
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
