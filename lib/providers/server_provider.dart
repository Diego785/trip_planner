import 'package:flutter/material.dart';

class ServerProvider extends ChangeNotifier {
  final String _url = 'http://35.198.5.59';

  String get url {
    return _url;
  }
}