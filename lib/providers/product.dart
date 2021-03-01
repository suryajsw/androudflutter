import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart ' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isfavorite;

  Product({@required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isfavorite = false});

  void _setvalue(bool newvalue) {
    isfavorite = newvalue;
    notifyListeners();
  }

  Future<void> togglefav(String token, String userid) async {
    final oldstatus = isfavorite;
    isfavorite = !isfavorite;
    notifyListeners();

    final url =
        'https://flutterproject-5b8e2-default-rtdb.firebaseio.com/userfav/$userid/$id.json?auth=$token;
    try {
      final responce = await http.put(url,
          body: json.encode(
            isfavorite,
          ));
      if (responce.statusCode >= 400) {
        _setvalue(oldstatus);
      }
    } catch (error) {
      _setvalue(oldstatus);
    }
  }
}
