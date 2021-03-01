import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime datetime;

  OrderItem({this.id, this.amount, this.products, this.datetime});
}

class Orderes with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authtoken;
  final String userId;

  Orderes(this.authtoken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchorder() async {
    final uri =
        'https://flutterproject-5b8e2-default-rtdb.firebaseio.com/Orders/$userId.json?auth=$authtoken';

    final res = await http.get(uri);
    final List<OrderItem> loadedoredrs = [];

    final extracteddata = json.decode(res.body) as Map<String, dynamic>;
    if (extracteddata == null) {
      return;
    }
    extracteddata.forEach((orderid, orderpro) {
      loadedoredrs.add(OrderItem(
        id: orderid,
        amount: orderpro['amount'],
        datetime: DateTime.parse(orderpro['dateTime']),
        products: (orderpro['products'] as List<dynamic>)
            .map((item) => CartItem(
                prodid: item['id'],
                title: item['title'],
                quantity: item['quantity'],
                price: item['price']))
            .toList(),
      ));
    });
    _orders = loadedoredrs.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartproducts, double total) async {
    final url =
        'https://flutterproject-5b8e2-default-rtdb.firebaseio.com/Orders/$userId.jsonauth=$authtoken';
    final timestamp = DateTime.now();
    final res = await http.post(url,
        body: json.encode({
          'amount': total,
          'datetime': timestamp.toIso8601String(),
          'products': cartproducts
              .map(
                (cp) => {
                  'id': cp.prodid,
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'proce': cp.price,
                },
              )
              .toList(),
        }));
    _orders.insert(
        0,
        OrderItem(
            id: json.decode(res.body)['name'],
            amount: total,
            products: cartproducts,
            datetime: timestamp));
    notifyListeners();
  }
}
