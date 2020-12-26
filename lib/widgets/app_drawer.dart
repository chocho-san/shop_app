import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('こんにちは！'),
            automaticallyImplyLeading: false, /*ボタンが表示されないようにする*/
          ),
          Divider(), /*下に仕切りを追加*/
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('ショッピング'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('注文'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('製品管理'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('ログアウト'),
            onTap: () {
              Navigator.of(context).pop(); /*画面消して*/
              // Navigator.of(context)
              //     .pushReplacementNamed(AuthScreen.routeName);
              Provider.of<Auth>(context, listen:false).logout(); /*ログアウトする*/
            },
          ),
        ],
      ),
    );
  }
}
