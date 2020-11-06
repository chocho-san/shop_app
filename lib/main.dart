import 'package:flutter/material.dart';
import 'file:///C:/Users/marur/AndroidStudioProjects/shop_app/lib/screens/product_detail_screen.dart';
import 'file:///C:/Users/marur/AndroidStudioProjects/shop_app/lib/screens/products_overview_screen.dart';
import 'package:provider/provider.dart';
import 'providers/products.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => Products(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName:(ctx) => ProductDetailScreen(),
        },
      ),
    );
  }
}
