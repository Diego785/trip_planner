import 'package:flutter/material.dart';

class FlashMessageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      height: 90,
                      decoration: BoxDecoration(
                        color: Color(0xFFC72C41),
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 48),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "¡No hay micros disponibles!",
                                  style:
                                      TextStyle(color: Colors.white, fontSize: 18),
                                ),
                                Text(
                                  "Intentelo nuevamente con otra línea porfavor.",
                                  style:
                                      TextStyle(color: Colors.white, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
            );
          },
          child: Text("Show message"),
        ),
      ),
    );
  }
}
