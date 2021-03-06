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
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemcount {
    return _items.length;
  }

  double get totalamount {
    var total = 0.0;
    _items.forEach((key, val) {
      total += val.price * val.quantity;
    });
    return total;
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
    notifyListeners();
  }

  void removeItem(String pid) {
    _items.remove(pid);
    notifyListeners();
  }

  void removesingleitem(String prid) {
    if (!_items.containsKey(prid)) {
      return;
    }
    if (_items[prid].quantity > 1) {
      _items.update(
          prid,
          (val) => CartItem(
              prodid: val.prodid,
              title: val.title,
              quantity: val.quantity - 1,
              price: val.price));
    } else {
      _items.remove(prid);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
