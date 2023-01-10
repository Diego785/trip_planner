import 'package:flutter/material.dart';
import 'package:trip_planner/implementation_cards/models/contact.dart';
import 'package:trip_planner/implementation_cards/ui/widgets/cards.dart';
import 'package:trip_planner/models/specific_line.dart';

class ContactDetailScreen extends StatelessWidget {
  const ContactDetailScreen(
      {super.key,
      required this.contact,
      required this.color,
      required this.micro,
      required this.distance});

  final Contact contact;
  final Color color;
  final SpecificLine micro;
  final double distance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.green[800],
        title: Text("Información del micro " + micro.code),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SafeArea(
          child: MicrosCard(
            contact: contact,
            borderColor: color,
            micros: micro,
            distances: distance,
            dataComplete: true,
          ),
        ),
      ),
    );
  }
}
