import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = productsData.items;

    return GridView.builder(
      /*GridView.builderは「ListView」の時同様、表示する要素やその数が事前にわからない場合に利用する書き方。ギャラリー、検索結果の表示などに利用。*/
      padding: const EdgeInsets.all(10),
      /*このconstはパフォーマンスの節約*/
      itemCount: products.length,
      gridDelegate: /*列の数を定義*/
          SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, i) => ChangeNotifierProvider(
        create: (c) => products[i],
        child: ProductItem(
          // products[i].id,
          // products[i].title,
          // products[i].imageUrl,
        ),
      ),
    );
  }
}
