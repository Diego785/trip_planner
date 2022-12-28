// import 'package:flutter/material.dart';
// import 'package:slimy_card/slimy_card.dart';

// class InformationCard extends StatelessWidget {
//   final String code;
//   final int time;
//   final int distance;
//   final int velocidad;
//   final String descripcionMicro;
//   final String descripcionLinea;
//   final String foto;
//   final String telefono;

//   InformationCard(this.code, this.time, this.distance, this.velocidad,
//       this.descripcionMicro, this.descripcionLinea, this.foto, this.telefono);

//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       children: <Widget>[
    
//         StreamBuilder(
//           stream: slimyCard.stream,
//           initialData: false,
//           builder: (BuildContext context, AsyncSnapshot snapshot) {
//             final String message =
//                 (snapshot.data) ? 'Tap to close' : 'Tap to open';
//             return SlimyCard(
//               color: Colors.green[800],
//               bottomCardHeight: 200,
//               topCardHeight: 150,
//               topCardWidget: CustomTop(message),
//               bottomCardWidget: CustomBottom(
//                   this.code,
//                   this.time,
//                   this.distance,
//                   this.velocidad,
//                   this.descripcionMicro,
//                   this.descripcionLinea,
//                   this.foto,
//                   this.telefono),
//             );
//           },
//         ),
//       ],
//     );
//   }
// }

// class CustomTop extends StatelessWidget {
//   final String text;
//   CustomTop(this.text);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Text(
//         text,
//         style: TextStyle(color: Colors.white),
//       ),
//     );
//   }
// }

// class CustomBottom extends StatelessWidget {
//   final String code;
//   final int time;
//   final int distance;
//   final int velocidad;
//   final String descripcionMicro;
//   final String descripcionLinea;
//   final String foto;
//   final String telefono;

//   CustomBottom(this.code, this.time, this.distance, this.velocidad,
//       this.descripcionMicro, this.descripcionLinea, this.foto, this.telefono);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // Colocar los botones
//           const Text(
//             "Información del Micro: ",
//             style: TextStyle(
//                 fontWeight: FontWeight.bold, fontSize: 10, color: Colors.white),
//           ),
         
//           ClipRRect(
//             borderRadius: BorderRadius.circular(90),
//             child: Image.asset(
//               foto,
//               width: 20,
//               height: 20,
//               fit: BoxFit.cover,
//               scale: 5,
//             ),
//           ),
         

//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text(
//                 "Id: ",
//                 style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 10,
//                     color: Colors.white),
//               ),
//               Text(
//                 code,
//                 style: TextStyle(
//                     fontStyle: FontStyle.italic,
//                     fontSize: 10,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.green.shade500),
//               ),
//             ],
//           ),
       

//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text(
//                 "Código: ",
//                 style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 10,
//                     color: Colors.white),
//               ),
//               Text(
//                 code,
//                 style: TextStyle(
//                     fontStyle: FontStyle.italic,
//                     fontSize: 10,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.green.shade500),
//               ),
//             ],
//           ),
       

//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text(
//                 "Dirección: ",
//                 style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 10,
//                     color: Colors.white),
//               ),
//               Text(
//                 code,
//                 style: TextStyle(
//                     fontStyle: FontStyle.italic,
//                     fontSize: 10,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.green.shade500),
//               ),
//             ],
//           ),
          
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text(
//                 "Teléfono: ",
//                 style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 10,
//                     color: Colors.white),
//               ),
//               Text(
//                 code,
//                 style: TextStyle(
//                     fontStyle: FontStyle.italic,
//                     fontSize: 10,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.green.shade500),
//               ),
//             ],
//           ),
       

//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text(
//                 "Email: ",
//                 style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 10,
//                     color: Colors.white),
//               ),
//               Text(
//                 code,
//                 style: TextStyle(
//                     fontStyle: FontStyle.italic,
//                     fontSize: 10,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.green.shade500),
//               ),
//             ],
//           ),
       
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text(
//                 "Descripción: ",
//                 style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 10,
//                     color: Colors.white),
//               ),
//               SizedBox(
//                 width: 10,
//                 child: Text(
//                   code,
//                   style: TextStyle(
//                       fontStyle: FontStyle.italic,
//                       fontSize: 10,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.green.shade500),
//                   maxLines: 1,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
