import 'package:flutter/material.dart';
import 'package:shop_app/providers/orders.dart';

class OrderIte extends StatelessWidget {
  final OrderItem order;

  OrderIte(this.order);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$${order.amount}'),
          )
        ],
      ),
    );
  }
}
