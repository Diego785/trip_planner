import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:trip_planner/models/lineas.dart';

class DinamicSearch extends StatefulWidget {
  @override
  State<DinamicSearch> createState() => _DinamicSearchState();
}

class _DinamicSearchState extends State<DinamicSearch> {
  void updateList(String value) {
    setState(() {
      lineas = lineas2
          .where(
              (element) => element.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      child: Expanded(
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
            onChanged: (value) => updateList(value) ,
              style: TextStyle(color: Colors.white),
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
            Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(10),
                  itemCount: lineas.length,
                  itemBuilder: (context, index) => ListTile(
                    selectedColor: Colors.green.shade900,
                    hoverColor: Colors.green.shade900,
                    minLeadingWidth: 80,
                    contentPadding: const EdgeInsets.only(top: 15),
                    selected: true,
                    title: Text(
                      lineas[index].name,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    leading: Image.asset("assets/logo.png"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
