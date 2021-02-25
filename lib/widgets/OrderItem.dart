import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/providers/orders.dart';

class OrderIte extends StatefulWidget {
  final OrderItem order;

  OrderIte(this.order);

  @override
  _OrderIteState createState() => _OrderIteState();
}

class _OrderIteState extends State<OrderIte> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$${widget.order.amount}'),
            subtitle: Text(
                DateFormat('dd MM yyyy hh:mm').format(widget.order.datetime)),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          
          if (_expanded)
            Container(
              height: min(widget.order.products.length * 20.0 + 100, 180),
              child: ListView(
                children: widget.order.products
                    .map(
                      (e) =>
                      Row(
                        children: <Widget>[
                          Text(
                            e.title,
                          ),
                          Text('${e.quantity}x\$${e.price}')
                        ],
                      ),
                )
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}
