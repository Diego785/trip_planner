import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/implementation_cards/models/contact.dart';
import 'package:trip_planner/models/specific_line.dart';
import 'package:trip_planner/providers/position_provider.dart';
import 'package:trip_planner/views/map_view_copy.dart';

class MicrosCard extends StatelessWidget {
  MicrosCard({
    required this.borderColor,
    required this.contact,
    required this.micros,
    required this.distances,
    this.dataComplete = false,
    this.index,
  });

  final Color borderColor;
  final Contact contact;
  SpecificLine micros;
  double distances;
  bool dataComplete;
  int? index;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: micros.code,
      child: Material(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //-----------------------------
            // Card Tab
            //-----------------------------
            Align(
              heightFactor: .9,
              alignment: Alignment.centerLeft,
              child: Container(
                height: 30,
                width: 70,
                decoration: BoxDecoration(
                  color: borderColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(10),
                  ),
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
            //-----------------------------
            // Card Body
            //-----------------------------
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: borderColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                //-----------------------------
                // Card Body
                //-----------------------------
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //---------------------------
                      // Name and Role
                      //---------------------------
                      Row(
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.bus,
                            color: Colors.blueAccent,
                            size: 40,
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Text.rich(
                              TextSpan(
                                text: micros.code,
                                children: [
                                  TextSpan(
                                    text: '\n' + micros.descripcionLinea,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      height: 1.5,
                                    ),
                                  )
                                ],
                              ),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      //---------------------------
                      // Address
                      //---------------------------
                      Row(
                        children: [
                          const Icon(
                            Icons.description,
                            size: 40,
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 250,
                            child: Text(
                              micros.descripcionMicro,
                              maxLines: 4,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.deepPurple,
                              ),
                            ),
                          )
                        ],
                      ),
                      //---------------------------
                      // Phone Number
                      //---------------------------
                      Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.phone,
                            size: 40,
                            color: Colors.green[500],
                          ),
                          const SizedBox(width: 10),
                          Text(
                            micros.telefono,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                      //---------------------------
                      // eMail
                      //---------------------------
                      Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.ruler,
                            size: 40,
                            color: Colors.yellow[900],
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    micros.velocidad.toString() + " Km/h",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                ),
                                Text(
                                  (distances / 1000).toStringAsFixed(3) +
                                      ' Km.',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                                Text(
                                  (((distances / 1000) / micros.velocidad) * 60)
                                          .toStringAsFixed(3) +
                                      ' min.',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      (dataComplete)
                          ? Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 20),
                                  child: Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.asset(
                                        micros.foto,
                                        width: 150,
                                        height: 150,
                                        scale: 10,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 250,
                                  height: 60,
                                  // padding: EdgeInsets.symmetric(vertical: 10),
                                  // margin:
                                  //     EdgeInsets.only(top: 450, right: 100, left: 100),
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
                                      "Trazar Ruta",
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
                                      final positionProvider =
                                          Provider.of<PositionProvider>(context,
                                              listen: false);
                                      positionProvider.recorridoSelected =
                                          micros.id;
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => MapView(
                                                  0,
                                                  99,
                                                  positionProvider
                                                      .startPosition,
                                                  positionProvider.endPosition,
                                                  null)));
                                    },
                                  ),
                                ),
                              ],
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
