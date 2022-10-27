import 'package:flutter/material.dart';

void main() => runApp(const MainClass());

class MainClass extends StatelessWidget {
  const MainClass({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trip Planner Project',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.bus_alert),
          onPressed: () => {},
        ),
        appBar: AppBar(
          title: const Text('Trip Planner Project'),
        ),
        body: const Center(
          child: Text(
            'Insert your code here :3',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
        ),
      ),
    );
  }
}
