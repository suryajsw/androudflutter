import 'package:flutter/material.dart';

import './product.dart';

class products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favitems {
    return _items.where((element) => element.isfavorite).toList();
  }

  Product findbyid(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  void addproduct(Product produc) {
    final newprod = Product(
      title: produc.title,
      description: produc.description,
      price: produc.price,
      id: DateTime.now().toString(),
      imageUrl: produc.imageUrl,
    );
    _items.add(newprod);
    notifyListeners();
  }

  void updatepro(String id, Product newproduct) {
    final prodindex = _items.indexWhere((element) => element.id == id);
    if (prodindex >= 0) {
      _items[prodindex] = newproduct;
      notifyListeners();
    } else {
      print('hh');
    }
  }

  void deletpro(String id) {
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
