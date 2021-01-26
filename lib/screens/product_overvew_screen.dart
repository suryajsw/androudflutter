import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/batch.dart';
import 'package:shop_app/widgets/productgrid.dart';

enum Filteroption { favorite, all }

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showonlyfavdata = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: <Widget>[
          PopupMenuButton(
              onSelected: (Filteroption selected) {
                setState(() {
                  if (selected == Filteroption.favorite) {
                    _showonlyfavdata = true;
                  } else {
                    _showonlyfavdata = false;
                  }
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    PopupMenuItem(
                        child: Text('only favs'), value: Filteroption.favorite),
                    PopupMenuItem(
                      child: Text('show all'),
                      value: Filteroption.all,
                    )
                  ]),
          Consumer<Cart>(
              builder: (_, Cart, ch) => Badge(
                    child: ch,
                    value: Cart.itemcount.toString(),
                  ),
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
              )),
        ],
      ),
      drawer: AppDrawer(),
      body: ProductGrid(_showonlyfavdata),
    );
  }
}
