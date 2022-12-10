import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trip_planner/complements/loading_page.dart';
import 'package:trip_planner/models/linea.dart';
import 'package:trip_planner/models/lineas.dart';
import 'package:http/http.dart' as http;
import 'package:trip_planner/pages/recorrido_lineas.dart';
import 'package:trip_planner/screens/screens.dart';
import 'package:trip_planner/widgets/my_button.dart';
import 'package:trip_planner/providers/providers.dart';

class MySearchingDrawer extends StatefulWidget {
  @override
  State<MySearchingDrawer> createState() => _MySearchingDrawerState();
}

class _MySearchingDrawerState extends State<MySearchingDrawer> {
// VARIABLES PARA RECIBIR EL MODELO
  bool showLineas = true;
  late Future<List<Linea>> _listlineas;
  List<Linea> _listLineasGet = [];

  List<Linea> _listLineasGet2 = []; // variable auxiliar para el buscador

// PETICIÓN GET DE DATOS DEL MODELO A LA API
  Future<Null> _getLineas() async {
     Uri url = Uri.parse('http://10.0.2.2/trip_planner_bd/public/api/linea');
    //final urlPrincipal = ServerProvider().url;
    //Uri url = Uri.parse('$urlPrincipal/api/linea');
    final response = await http.get(url);
    List<Linea> data = [];
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = json.decode(body);
      for (var item in jsonData) {
        // print(item["id"]);
        // print("Diego Hurtado Vargas");
        data.add(Linea(
          id: item["id"].toString(),
          code: item["code"],
          direccion: item["direccion"],
          telefono: item["telefono"],
          email: item["email"],
          foto: item["foto"],
          descripcion: item["descripcion"],
        ));
      }

      _listLineasGet = [];
      for (Map linea in jsonData) {
        _listLineasGet.add(Linea.fromJson(linea));
        _listLineasGet2 = _listLineasGet;
      }
      setState(() {});
    } else {
      throw Exception("Falló la conexión");
    }
  }

// MÉTODO PARA LOS VALORES DEL BUSCADOR
  void updateList(String value) {
    _listLineasGet = _listLineasGet2
        .where((element) =>
            element.descripcion.toLowerCase().contains(value.toLowerCase()))
        .toList();
    if (_listLineasGet.isEmpty || _listLineasGet2.isEmpty) {
      showLineas = false;
      setState(() {});
    } else {
      showLineas = true;
      setState(() {});
    }
  }

  @override
  void initState() {
    //Inicializar los datos
    verifGetLineas();
    super.initState();
  }

  void verifGetLineas() async {
    if (showLineas = true) {
      await _getLineas();
    }
  }

  final leftEditIcon = Container(
    margin: const EdgeInsets.only(bottom: 10),
    color: const Color.fromARGB(255, 94, 102, 168).withOpacity(0.5),
    alignment: Alignment.center,
    child: const Icon(Icons.visibility, color: Colors.white),
  );

  final rightEditIcon = Container(
    margin: const EdgeInsets.only(bottom: 10),
    color: const Color.fromARGB(255, 94, 102, 168).withOpacity(0.5),
    alignment: Alignment.center,
    child: const Icon(Icons.info, color: Colors.white),
  );

  @override
  Widget build(BuildContext context) {
    if (_listLineasGet.isEmpty && _listLineasGet2.isEmpty) {
      return const LoadingPage();
    } else {
      return Drawer(
        child: ListView(
          children: [
            Container(
              width: 500,
              height: 2000,
              // color: Colors.white60,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                colors: [
                  Colors.green,
                  Colors.lightGreen,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              )),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 30),
                      width: 150,
                      height: 150,
                      child: Image.asset("assets/logo.png"),
                    ),
                    const Text(
                      "Trip Planner SC",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 30,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    //IMPLEMEN
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //IMPLEMENTAR LA SEGUNDA FUNCIONALIDAD
                        Column(
                          children: [
                            FloatingActionButton(
                              backgroundColor: Colors.green[800],
                              onPressed: () => {},
                              child: const Icon(
                                Icons.place,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "2da. Funcionalidad",
                              style: TextStyle(
                                  color: Colors.green[900], fontSize: 13),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        //IMPLEMENTAR LA TERCERA FUNCIONALIDAD
                        Column(
                          children: [
                            FloatingActionButton(
                              backgroundColor: Colors.green[800],
                              onPressed: () => {},
                              child: const Icon(
                                Icons.bus_alert,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "3ra. Funcionalidad",
                              style: TextStyle(
                                  color: Colors.green[900], fontSize: 13),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      width: 1000,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Escriba una línea de micro",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextField(
                              onChanged: (value) => updateList(value),
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.green,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  hintText: "Ejm: 12",
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: Colors.green.shade900,
                                  ),
                                  prefixIconColor: Colors.green.shade900),
                            ),
                            (showLineas)
                                ? Column(
                                    children: [
                                      // MOSTRAR LA LISTA DE MICROS
                                      ListView.builder(
                                          shrinkWrap: true,
                                          padding: const EdgeInsets.all(10),
                                          itemCount: _listLineasGet.length,
                                          itemBuilder: (context, index) {
                                            return Dismissible(
                                              background: leftEditIcon,
                                              secondaryBackground:
                                                  rightEditIcon,
                                              onDismissed:
                                                  (DismissDirection direction) {
                                                print("after dismiss");
                                              },
                                              confirmDismiss: (DismissDirection
                                                  direction) async {
                                                if (direction ==
                                                    DismissDirection
                                                        .startToEnd) {
                                                  showModalBottomSheet(
                                                      backgroundColor: Colors
                                                          .transparent
                                                          .withOpacity(0.1),
                                                      barrierColor: Colors
                                                          .transparent
                                                          .withOpacity(0.9),
                                                      context: context,
                                                      builder: (_) {
                                                        return Container(
                                                          height: 550,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: const Color(
                                                                    0xFF2e3253)
                                                                .withOpacity(
                                                                    0.4),
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .only(
                                                              topLeft: Radius
                                                                  .circular(20),
                                                              topRight: Radius
                                                                  .circular(20),
                                                            ),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                              left: 20,
                                                              right: 20,
                                                            ),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                // Colocar los botones
                                                                MyButton(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  text: "Ida",
                                                                  textColor: Colors
                                                                      .green
                                                                      .shade900,
                                                                  onTap: () {
                                                                    //AQUÍ COLOCAR LA POLYLINE DE LA IDA
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) => RecorridoLineas(
                                                                                int.parse(_listLineasGet[index].id),
                                                                                1,
                                                                                null,
                                                                                null)));
                                                                  },
                                                                ),

                                                                const SizedBox(
                                                                    height: 20),
                                                                MyButton(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  text:
                                                                      "Vuelta",
                                                                  textColor: Colors
                                                                      .green
                                                                      .shade900,
                                                                  onTap: () {
                                                                    //AQUÍ COLOCAR LA POLYLINE DE LA VUELTA
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) => RecorridoLineas(
                                                                                int.parse(_listLineasGet[index].id),
                                                                                2,
                                                                                null,
                                                                                null)));
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      });
                                                  return false;
                                                } else {
                                                  showModalBottomSheet(
                                                      backgroundColor: Colors
                                                          .transparent
                                                          .withOpacity(0.1),
                                                      barrierColor: Colors
                                                          .transparent
                                                          .withOpacity(0.9),
                                                      context: context,
                                                      builder: (_) {
                                                        return Container(
                                                          height: 550,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: const Color(
                                                                    0xFF2e3253)
                                                                .withOpacity(
                                                                    0.4),
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .only(
                                                              topLeft: Radius
                                                                  .circular(20),
                                                              topRight: Radius
                                                                  .circular(20),
                                                            ),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                              left: 20,
                                                              right: 20,
                                                            ),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                // Colocar los botones
                                                                const Text(
                                                                  "Información del Micro: ",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          30,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                                const SizedBox(
                                                                  height: 10,
                                                                ),

                                                                ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              90),
                                                                  child: Image
                                                                      .asset(
                                                                    _listLineasGet[
                                                                            index]
                                                                        .foto,
                                                                    width: 100,
                                                                    height: 100,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    scale: 10,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  height: 10,
                                                                ),

                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    const Text(
                                                                      "Id: ",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              20,
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                    Text(
                                                                      _listLineasGet[
                                                                              index]
                                                                          .id,
                                                                      style: TextStyle(
                                                                          fontStyle: FontStyle
                                                                              .italic,
                                                                          fontSize:
                                                                              20,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color: Colors
                                                                              .green
                                                                              .shade500),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                  height: 10,
                                                                ),

                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    const Text(
                                                                      "Código: ",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              20,
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                    Text(
                                                                      _listLineasGet[
                                                                              index]
                                                                          .code,
                                                                      style: TextStyle(
                                                                          fontStyle: FontStyle
                                                                              .italic,
                                                                          fontSize:
                                                                              20,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color: Colors
                                                                              .green
                                                                              .shade500),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                  height: 10,
                                                                ),

                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    const Text(
                                                                      "Dirección: ",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              20,
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                    Text(
                                                                      _listLineasGet[
                                                                              index]
                                                                          .direccion,
                                                                      style: TextStyle(
                                                                          fontStyle: FontStyle
                                                                              .italic,
                                                                          fontSize:
                                                                              20,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color: Colors
                                                                              .green
                                                                              .shade500),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                  height: 10,
                                                                ),

                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    const Text(
                                                                      "Teléfono: ",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              20,
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                    Text(
                                                                      _listLineasGet[
                                                                              index]
                                                                          .telefono,
                                                                      style: TextStyle(
                                                                          fontStyle: FontStyle
                                                                              .italic,
                                                                          fontSize:
                                                                              20,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color: Colors
                                                                              .green
                                                                              .shade500),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                  height: 10,
                                                                ),

                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    const Text(
                                                                      "Email: ",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              20,
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                    Text(
                                                                      _listLineasGet[
                                                                              index]
                                                                          .email,
                                                                      style: TextStyle(
                                                                          fontStyle: FontStyle
                                                                              .italic,
                                                                          fontSize:
                                                                              20,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color: Colors
                                                                              .green
                                                                              .shade500),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    const Text(
                                                                      "Descripción: ",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              20,
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                    SizedBox(
                                                                      width:
                                                                          200,
                                                                      child:
                                                                          Text(
                                                                        _listLineasGet[index]
                                                                            .descripcion,
                                                                        style: TextStyle(
                                                                            fontStyle: FontStyle
                                                                                .italic,
                                                                            fontSize:
                                                                                20,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Colors.green.shade500),
                                                                        maxLines:
                                                                            2,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      });
                                                  return false;
                                                }
                                              },
                                              key: ObjectKey(index),
                                              child: ListTile(
                                                selectedColor:
                                                    Colors.green.shade900,
                                                hoverColor:
                                                    Colors.green.shade900,
                                                minLeadingWidth: 80,
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        top: 15),
                                                selected: true,
                                                title: Text(
                                                  _listLineasGet[index].code,
                                                  style: TextStyle(
                                                      color:
                                                          Colors.green.shade900,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20),
                                                ),
                                                leading: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  child: Image.asset(
                                                    _listLineasGet[index].foto,
                                                    width: 100,
                                                    height: 100,
                                                    scale: 10,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                trailing: const Icon(
                                                  Icons.compare_arrows,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            );
                                          }

                                          /*ListTile(
                                  selectedColor: Colors.green.shade900,
                                  hoverColor: Colors.green.shade900,
                                  minLeadingWidth: 80,
                                  contentPadding:
                                      const EdgeInsets.only(top: 15),
                                  selected: true,
                                  title: Text(
                                    _listLineasGet[index].code,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  leading: Image.asset("assets/logo.png"),
                                ),*/
                                          ),
                                      //getData(),
                                    ],
                                  )
                                : Container(
                                    padding: EdgeInsets.only(top: 15),
                                    child: Text(
                                      "No existen líneas con esta característica.",
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green[900],
                                          fontSize: 15),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      );
    }
  }

  /* Widget getData() {
    return FutureBuilder(
        future: _listPuntos,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: getList(context, snapshot),
            );
          } else if (snapshot.hasError) {
            print(snapshot.error);
          }
          return LoadingPage();
        });
  }

  List<Widget> getList(contex, data) {
    List<Widget> puntos = [];

    for (var punto in data) {
      puntos.add(
        ListTile(
          selectedColor: Colors.green.shade900,
          hoverColor: Colors.green.shade900,
          minLeadingWidth: 80,
          contentPadding: const EdgeInsets.only(top: 15),
          selected: true,
          title: Text(
            punto.Shape,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: Image.asset("assets/logo.png"),
        ),
      );
    }

    return puntos;
  }*/
}
