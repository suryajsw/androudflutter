import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  final String prodid;

  final double price;
  final int quantity;
  final String title;

  CartItem(
      {@required this.prodid,
      @required this.price,
      @required this.quantity,
      @required this.title});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(prodid),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.bottomRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      direction: DismissDirection.endToStart,
      // ignore: missing_return
      confirmDismiss: (direct) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are u sure'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  },
                  child: Text('no')),
              FlatButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                  },
                  child: Text('yes'))
            ],
          ),
        );
      },
      onDismissed: (direction) {},
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Text('\$$price'),
            ),
            title: Text(title),
            subtitle: Text('Total:\$${(price * quantity)}'),
            trailing: Text('$quantity'),
          ),
        ),
      ),
    );
  }
}
