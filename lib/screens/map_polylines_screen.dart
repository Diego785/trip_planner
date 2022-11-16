import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/complements/loading_page.dart';
import 'package:trip_planner/helpers/helpers.dart';
import 'package:trip_planner/models/models.dart';
import 'package:trip_planner/providers/providers.dart';
import 'package:trip_planner/services/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:trip_planner/widgets/my_searching_drawer.dart';

class MapPolylinesScreen extends StatefulWidget {
  final int recorrido;
  final int par;
  const MapPolylinesScreen(this.recorrido, this.par, {Key? key})
      : super(key: key);

  @override
  State<MapPolylinesScreen> createState() => _MapPolylinesScreenState();
}

class _MapPolylinesScreenState extends State<MapPolylinesScreen> {
  Completer<GoogleMapController> _controller = Completer();

  List<PuntosModel> _puntos = [];
  var lineaMicro = 0;

  final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(-17.782158, -63.180684),
    zoom: 13,
  );

  Uint8List? markerImage;

  String? direccion;
  String? direccion2;
  String images = 'assets/bandera-roja.png';

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
  final Set<Polyline> _polyline = {};
  List<LatLng> latlng = [];

  @override
  void initState() {
    int recorrido = widget.recorrido;
    int parImpar = widget.par;
    super.initState();
    PuntosService.getPuntos(recorrido, parImpar).then((puntos) {
      setState(() {
        _puntos = puntos;
        latlng = listaLatLng(_puntos);
        loadData();
      });
    });
    Provider.of<PuntosProvider>(context, listen: false)
        .setPunto(recorrido, parImpar);
  }

  loadData() async {
    lineaMicro = _puntos[0].lineaId;
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

    var color = Colors.green;
    var camino = 'Ida';
    if (_puntos[0].recorridosId % 2 == 0) {
      color = Colors.red;
      camino = 'Vuelta';
    }

    int l = latlng.length - 1;
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latlng[0].latitude, latlng[0].longitude);
    direccion = placemarks.reversed.last.thoroughfare.toString();

    List<Placemark> placemarks2 =
        await placemarkFromCoordinates(latlng[l].latitude, latlng[l].longitude);
    direccion2 = placemarks2.reversed.last.thoroughfare.toString();

    final Uint8List markerIcon = await getBytesFromAssets(images, 100);

    _markers.add(Marker(
      markerId: MarkerId(0.toString()),
      position: latlng[0],
      infoWindow: InfoWindow(
        title: 'Inicio $direccion',
        snippet: 'Linea de $camino',
      ),
      icon: BitmapDescriptor.defaultMarker,
    ));
    for (int i = 0; i < latlng.length; i++) {
      setState(() {});
      _polyline.add(Polyline(
          polylineId: PolylineId('1'),
          points: latlng,
          color: color,
          width: 7,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap));
    }
    _markers.add(Marker(
      markerId: MarkerId(l.toString()),
      position: latlng[l],
      infoWindow: InfoWindow(
        title: 'Fin $direccion2',
        snippet: 'Linea de $camino',
      ),
      icon: BitmapDescriptor.fromBytes(markerIcon),
    ));
  }

  @override
  Widget build(BuildContext context) {
    if (_polyline.isEmpty) return const LoadingPage();

    return Scaffold(body: Center(
        child: Consumer<PuntosProvider>(builder: (context, value, child) {
      return Scaffold(
        endDrawer: MySearchingDrawer(),
        appBar: AppBar(
          title: Text('Línea $lineaMicro'),
          backgroundColor: Colors.green.shade800,
        ),
        body: Builder(builder: (context) {
          return SafeArea(
            child: Stack(children: [
              GoogleMap(
                initialCameraPosition: _kGooglePlex,
                markers: _markers,
                mapType: MapType.normal,
                myLocationEnabled: true,
                compassEnabled: false,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                polylines: _polyline,
              ),
              Positioned(
                left: MediaQuery.of(context).size.width - 50,
                top: MediaQuery.of(context).size.height - 370,
                child: SizedBox(
                width: 50,
                height: 50,
                  child: FloatingActionButton(
                    backgroundColor: Colors.green[800],
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                    child: const Icon(
                      Icons.search,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: MediaQuery.of(context).size.width - 50,
                top: MediaQuery.of(context).size.height - 310,
                child: SizedBox(
                width: 50,
                height: 50,
                  child: FloatingActionButton(
                    backgroundColor: Colors.green[800],
                    onPressed: () {},
                    child: const Icon(
                      Icons.place,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: MediaQuery.of(context).size.width - 50,
                top: MediaQuery.of(context).size.height - 250,
                child: SizedBox(
                width: 50,
                height: 50,
                  child: FloatingActionButton(
                    backgroundColor: Colors.green[800],
                    onPressed: () {},
                    child: const Icon(
                      Icons.bus_alert,
                    ),
                  ),
                ),
              ),
            ]),
          );
        }),
      );
    })));
    //
  }
}
