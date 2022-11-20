import 'package:flutter/material.dart';
import 'package:trip_planner/implementation_cards/models/contact.dart';
import 'package:trip_planner/implementation_cards/template_trip_planner_app.dart';
import 'package:trip_planner/implementation_cards/ui/contact_detail_screen.dart';
import 'package:trip_planner/implementation_cards/ui/widgets/cards.dart';
import 'package:trip_planner/implementation_cards/ui/widgets/perspective_list_view.dart';
import 'package:trip_planner/widgets/my_searching_drawer.dart';

class ContactListPage extends StatefulWidget {
  const ContactListPage({super.key});

  @override
  ContactListPageState createState() => ContactListPageState();
}

class ContactListPageState extends State<ContactListPage> {
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
          itemExtent: _itemExtent,
          initialIndex: 7,
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
                ),
              ),
            );
          },
          children: List.generate(Contact.contacts.length, (index) {
            final borderColor = Colors.accents[index % Colors.accents.length];
            final contact = Contact.contacts[index];
            return ContactCard(
              borderColor: borderColor,
              contact: contact,
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
