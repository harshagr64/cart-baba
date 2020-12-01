import 'package:flutter/material.dart';
import 'product.dart';
import "dart:convert";
import "package:http/http.dart" as http;
import "../models/http_exception.dart";

class Products with ChangeNotifier {
  List<Product> _items = [
//    Product(
//      id: 'p1',
//      title: 'Red Shirt',
//      description: 'A red shirt - it is pretty red!',
//      price: 29.99,
//      imageUrl:
//          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
//    ),
//    Product(
//      id: 'p2',
//      title: 'Trousers',
//      description: 'A nice pair of trousers.',
//      price: 59.99,
//      imageUrl:
//          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
//    ),
//    Product(
//      id: 'p3',
//      title: 'Yellow Scarf',
//      description: 'Warm and cozy - exactly what you need for the winter.',
//      price: 19.99,
//      imageUrl:
//          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
//    ),
//    Product(
//      id: 'p4',
//      title: 'A Pan',
//      description: 'Prepare any meal you want.',
//      price: 49.99,
//      imageUrl:
//          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
//    ),
  ];
  var _showFavoritesOnly = false;
  final String _authToken;
  final String userId;

  Products(this._authToken, this._items, this.userId);

//  void showFavoritesOnly() {
//     _showFavoritesOnly = true;
//     notifyListeners();
//  }
//
//  void showAll() {
//    _showFavoritesOnly = false;
//    notifyListeners();
//  }

  List<Product> get items {
//    if (_showFavoritesOnly) {
//      return (_items.where((product) => product.isFavorite)).toList();
//    }
    return [..._items];
  }

  List<Product> get favoriteItem {
    return _items.where((product) => product.isFavorite).toList();
  }

  Product findById(String id) {
    return items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchProducts([bool filterByUser = false]) async {
    final filteredUser =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://cart-baba.firebaseio.com/products.json?auth=$_authToken&$filteredUser';

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProduct = [];
      if (extractedData == null) {
        return;
      }
      url =
          'https://cart-baba.firebaseio.com/userFavorites/$userId.json?auth=$_authToken';
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);
//      print(favoriteData);

      extractedData.forEach((prodId, prodData) {
        final newProduct = Product(
          id: prodId,
          description: prodData['description'],
          title: prodData['title'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
          isFavorite:
              favoriteData == null ? false : favoriteData[prodId] ?? false,
        );
        loadedProduct.add(newProduct);
        notifyListeners();
      });

      _items = loadedProduct;
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
//    _items.add(null);
    final url =
        'https://cart-baba.firebaseio.com/products.json?auth=$_authToken';

    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'creatorId': userId,
          }));
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(Product product) async {
    final productId = product.id;
    final prodIndex = _items.indexWhere((prod) => prod.id == productId);
    final url =
        'https://cart-baba.firebaseio.com/products/$productId.json?auth=$_authToken';

    await http.patch(url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
        }));
    _items[prodIndex] = product;
    notifyListeners();
  }

  Future<void> deleteProduct(productId) async {
    final existingProdIndex = _items.indexWhere((prod) => prod.id == productId);
    var existingProduct = _items[existingProdIndex];
    _items.removeAt(existingProdIndex);
    notifyListeners();
    final url =
        'https://cart-baba.firebaseio.com/products/$productId.json?auth=$_authToken';
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProdIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not Delete Product.');
    }
    existingProduct = null;
  }
}
