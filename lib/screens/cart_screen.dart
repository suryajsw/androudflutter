import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart' show Cart;
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('your cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Chip(
                    label: Text('\$${cart.totalamount.toStringAsFixed(2)}'),
                  ),
                  Orderbutton(cart),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (ctx, i) => CartItem(
                      prodid: cart.items.values.toList()[i].prodid,
                      price: cart.items.values.toList()[i].price,
                      title: cart.items.values.toList()[i].title,
                      quantity: cart.items.values.toList()[i].quantity,
                    )),
          ),
        ],
      ),
    );
  }
}

class Orderbutton extends StatefulWidget {
  Orderbutton(@required this.cart);

  final Cart cart;

  @override
  _OrderbuttonState createState() => _OrderbuttonState();
}

class _OrderbuttonState extends State<Orderbutton> {
  var _isloading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: _isloading
          ? CircularProgressIndicator()
          : Text(
              ('ORDER NOW'),
            ),
      onPressed: (widget.cart.totalamount <= 0 || _isloading)
          ? null
          : () async {
              setState(() {
                _isloading = true;
              });
              await Provider.of<Orderes>(context, listen: false).addOrder(
                widget.cart.items.values.toList(),
                widget.cart.totalamount,
              );
              setState(() {
                _isloading = false;
              });
              widget.cart.clear();
            },
    );
  }
}
