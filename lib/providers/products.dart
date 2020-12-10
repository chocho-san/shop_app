import 'dart:convert'; /*データを変換するためのツールを提供。ここではJSONに変換*/

import 'package:flutter/material.dart';
import 'package:shop_app/models/http_exception.dart';
import '../providers/product.dart';
import 'package:http/http.dart' as http; /*名前の衝突を避けるため*/

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //   'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //   'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //   'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //   'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  List<Product> get items {
    return [..._items]; /*スプレッド演算子...はリストの全ての要素を別のリストに挿入できる。*/
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  /*Futureはdart:asyncライブラリに含まれてる*/
  Future<void> fetchAndSetProducts() async {
    const url = 'https://shop-app-5b9d9.firebaseio.com/products.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body)
          as Map<String, dynamic>; /*値が動的なマップがあることをダートに伝える*/
      if (extractedData == null) {
        return;
      }
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          isFavorite: prodData['isFavorite'],
          imageUrl: prodData['imageUrl'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      /*(error)はキャッチしたエラーオブジェクト*/
      throw (error);
    }
  }

  Future<void> addProduct(Product product) async {
    /*EditProductScreenに新しく製品を追加*/
    const url = 'https://shop-app-5b9d9.firebaseio.com/products.json';
    try {
      final response = await http /*移動する前にこの操作が終了するのを待ちたいことをDartに通知する*/
          .post(
        /*引数として指定する必要のあるURLにPOSTリクエストが送信される*/
        url,
        body: json.encode({
          /*これでデータが取得され、マップをJSONに変換*/
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'isFavorite': product.isFavorite,
        }),
      );
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      // _items.insert(0, newProduct); リストの最初
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    /*EditProductScreenにある製品を編集して更新*/
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = 'https://shop-app-5b9d9.firebaseio.com/products/$id.json';
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
            'isFavorite': newProduct.isFavorite,
          })); /*httpライブラリを使用してパッチリクエストを送信できる*/
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    /*製品を削除*/
    final url = 'https://shop-app-5b9d9.firebaseio.com/products/$id.json';
    final existingProductIndex = _items.indexWhere(
        (prod) => prod.id == id); /*アイテムを削除し、実際にリクエストを送る前に安全のためコピーする*/
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();/*リクエスト送信開始前に更新を行う必要がある*/

    final response = await http.delete(url);
      if (response.statusCode >= 400) { /*エラーコードは決まっている*/
        _items.insert(existingProductIndex, existingProduct);
        notifyListeners();
        throw HttpException('Could not delete product.');
      }
      existingProduct = null;


    /*notifyListeners()とはアプリ内の気になるすべての場所を更新*/
  }
}
