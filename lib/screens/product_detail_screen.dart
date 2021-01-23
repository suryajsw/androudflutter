import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product_providers.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routName = '/Product_detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedproduct =
        Provider.of<products>(context, listen: false).findbyid(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedproduct.title),
      ),
    );
  }
}
