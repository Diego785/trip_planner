import 'package:flutter/material.dart';
import 'package:trip_planner/implementation_cards/models/contact.dart';
import 'package:trip_planner/implementation_cards/template_trip_planner_app.dart';
import 'package:trip_planner/implementation_cards/ui/contact_detail_screen.dart';
import 'package:trip_planner/implementation_cards/ui/widgets/cards.dart';
import 'package:trip_planner/implementation_cards/ui/widgets/perspective_list_view.dart';
import 'package:trip_planner/models/specific_line.dart';
import 'package:trip_planner/views/map_view_copy.dart';
import 'package:trip_planner/widgets/my_searching_drawer.dart';

class MicrosListPage extends StatefulWidget {
  MicrosListPage(this.micros, this.distances);
  List<SpecificLine> micros;
  List<double> distances;

  @override
  MicrosListPageState createState() => MicrosListPageState();
}

class MicrosListPageState extends State<MicrosListPage> {
  int? _visibleItems;
  double? _itemExtent;

  @override
  void initState() {
    _visibleItems = 8;
    _itemExtent = 270.0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        backgroundColor: Colors.green[800],
        title: const Text('Sugerencias de Viajes'),
      ),
      endDrawer: MySearchingDrawer(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.lightGreen,
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: PerspectiveListView(
          visualizedItems: _visibleItems,
          itemExtent: 330,
          initialIndex: 5,
          enableBackItemsShadow: true,
          backItemsShadowColor: Theme.of(context).scaffoldBackgroundColor,
          padding: const EdgeInsets.all(10),
          onTapFrontItem: (index) {
            final color = Colors.accents[index! % Colors.accents.length];
            Navigator.push(
              context,
              MaterialPageRoute<dynamic>(
                builder: (_) => ContactDetailScreen(
                  contact: Contact.contacts[index],
                  color: color,
                  micro: widget.micros[widget.micros.length - index - 1],
                  distance: widget.distances[widget.micros.length - index - 1],
                ),
              ),
            );
          },
          children: List.generate(widget.micros.length, (index) {
            final borderColor = Colors.accents[index % Colors.accents.length];
            final contact = Contact.contacts[index];
            final micros = widget.micros[widget.micros.length - index - 1];
            final distances =
                widget.distances[widget.distances.length - index - 1];
            return MicrosCard(
              borderColor: borderColor,
              contact: contact,
              micros: micros,
              distances: distances,
            );
          }),
        ),
      ),
      //---------------------------------------
      // Drawer
      //---------------------------------------
    );
  }
}
