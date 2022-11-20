import 'package:flutter/material.dart';
import 'package:trip_planner/implementation_cards/ui/contact_list_page.dart';

void main() {
  runApp(TemplateGalleryApp());
}

class TemplateGalleryApp extends StatelessWidget {
 // const TemplateGalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xff23202a),
        appBarTheme: AppBarTheme(
          color: Colors.deepOrange[400],
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Colors.white70,
          ),
        ),
        textTheme: TextTheme(
          bodyText2: TextStyle(color: Colors.grey[800]),
        ),
        iconTheme: const IconThemeData(color: Colors.grey),
      ),
      child: const ContactListPage(),
    );
  }
}