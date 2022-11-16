import 'package:flutter/material.dart';
import 'package:trip_planner/delegates/search_destination_delegate.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.only(left: 65),
        width: double.infinity,
        child: GestureDetector(
            onTap: () async {
              showSearch(
                  context: context, delegate: SearchDestinationDelegate());
              //if ( result == null ) return;

              //onSearchResults( context, result );
              //print('onTap');
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
              child: const Text('¿Qué línea deseas recorrer?',
                  style: TextStyle(color: Colors.black87)),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        offset: Offset(0, 5))
                  ]),
            )),
      ),
    );
  }
}
