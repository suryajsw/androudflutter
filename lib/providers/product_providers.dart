import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

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

  final String authToken;
  final String userId;

  products(this.authToken, this.userId, this._items);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favitems {
    return _items.where((element) => element.isfavorite).toList();
  }

  Product findbyid(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> fetchproduct([bool filter = false]) async {
    final filtr = filter ? 'orderby="creatorId"&equalTo="userId"' : '';
    var url =
        'https://flutterproject-5b8e2-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filtr';
    try {
      final responce = await http.get(url);
      final extractdata = json.decode(responce.body) as Map<String, dynamic>;
      if (extractdata == null) {
        return;
      }
      url =
          'https://flutterproject-5b8e2-default-rtdb.firebaseio.com/userfav/$userId.json?auth=$authToken';
      final favres = await http.get(url);
      final favdata = json.decode(favres.body);
      final List<Product> loadedprods = [];
      extractdata.forEach((prodid, proddata) {
        loadedprods.add(Product(
          id: prodid,
          title: proddata['title'],
          description: proddata['description'],
          price: proddata['price'],
          isfavorite: favdata == null ? false : favdata[prodid] ?? false,
          imageUrl: proddata['imagurl'],
        ));
      });

      _items = loadedprods;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addproduct(Product produc) async {
    final url =
        'https://flutterproject-5b8e2-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    try {
      final responce = await http.post(url,
          body: json.encode({
            'title': produc.title,
            'description': produc.description,
            'imagurl': produc.imageUrl,
            'price': produc.price,
            'creatorId': userId,
          }));
      final newprod = Product(
        title: produc.title,
        description: produc.description,
        price: produc.price,
        id: json.decode(responce.body)['name'],
        imageUrl: produc.imageUrl,
      );
      _items.add(newprod);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updatepro(String id, Product newproduct) async {
    final prodindex = _items.indexWhere((element) => element.id == id);

    if (prodindex >= 0) {
      final url =
          'https://flutterproject-5b8e2-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(url,
          body: json.encode({
            'title': newproduct.title,
            'description': newproduct.description,
            'imagurl': newproduct.imageUrl,
            'price': newproduct.price,
          }));
      _items[prodindex] = newproduct;
      notifyListeners();
    } else {
      print('hh');
    }
  }

  Future<void> deletpro(String id) async {
    final url =
        'https://flutterproject-5b8e2-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
    final existingproindex = _items.indexWhere((prod) => prod.id == id);
    var existingpro = _items[existingproindex];
    _items.removeAt(existingproindex);
    notifyListeners();
    final value = await http.delete(url);
    if (value.statusCode >= 400) {
      _items.insert(existingproindex, existingpro);
      notifyListeners();
      throw HttpException('could not delet');
    }
    existingpro = null;
  }
}
