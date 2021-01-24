import 'package:flutter/material.dart';

class CartItem {
  final String prodid;
  final String title;
  final int quantity;
  final double price;

  CartItem(
      {@required this.prodid,
      @required this.title,
      @required this.quantity,
      @required this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items;

  Map<String, CartItem> get items {
    return {..._items};
  }

  void additem(String prodid, double price, String title) {
    if (_items.containsKey(prodid)) {
      _items.update(
          prodid,
          (value) => CartItem(
              prodid: value.prodid,
              title: value.title,
              quantity: value.quantity + 1,
              price: value.price));
    } else {
      _items.putIfAbsent(
          prodid,
          () => CartItem(
              prodid: DateTime.now().toString(),
              title: title,
              quantity: 1,
              price: price));
    }
  }
}
