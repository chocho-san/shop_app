import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggledFavoriteStatus(String token, String  userId) async {
    final oldStatus = isFavorite; /*最初に古いステータスを保存*/
    isFavorite = !isFavorite;
    notifyListeners();
    /*↓Firebaseに保存*/
    final url = 'https://shop-app-5b9d9.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
    try {
      final response = await http.put(
        url,
        body: json.encode(
          isFavorite,
        ),
      );
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);

      }
      } catch (error){
      _setFavValue(oldStatus);
    }
  }
}
