import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product_providers.dart';
import 'package:shop_app/widgets/product_item.dart';

class ProductGrid extends StatelessWidget {
  final bool showfavs;

  ProductGrid(this.showfavs);

  @override
  Widget build(BuildContext context) {
    final productdata = Provider.of<products>(context);
    final pro = showfavs ? productdata.favitems : productdata.items;
    return GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: pro.length,
        itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
              value: pro[index],
              child: ProductItem(),
            ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10));
  }
}
