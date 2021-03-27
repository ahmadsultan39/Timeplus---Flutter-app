import 'dart:io';

import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

import 'package:flutter/material.dart';

class Watch {
  final String id;
  final String title;
  final double price;
  final String description;
  final String imageUrl;

  Watch({
    @required this.id,
    @required this.title,
    @required this.price,
    @required this.description,
    @required this.imageUrl,
  });
}

class WatchesProvider with ChangeNotifier {
  List<Watch> _items = [];

  List<Watch> get items => [..._items];

  Watch findId(String id) => _items.firstWhere((element) => element.id == id);

  Future<void> fetchProducts([bool filterById = false]) async {
    List<Watch> load = [];
    return ParseObject('Watches').getAll().then((watchObject) {
      if (watchObject.success) {
        watchObject.results.forEach((watch) {
          load.add(Watch(
            id: watch.objectId,
            description: watch['description'],
            title: watch['title'],
            price: double.parse(watch['price'].toString()),
            imageUrl: watch['image']['url'],
          ));
        });
        _items = load;
        notifyListeners();
      }
    }).catchError((error) {
      print(error);
    });
  }

  Future<void> updateProduct(Watch product, File image) async {
    var watchObject = ParseObject('Watches');
    return watchObject.getObject(product.id).then((response) {
      watchObject
        ..set('title', product.title)
        ..set('description', product.description)
        ..set('price', product.price);
      if (image != null) watchObject.set('image', ParseFile(image));

      watchObject.save().then((response) {
        if (response.success) {
          product = Watch(
            id: response.results.first['objectId'],
            title: product.title,
            description: product.description,
            price: product.price,
            imageUrl: image != null
                ? response.results.first['image']['url']
                : product.imageUrl,
          );
          final i = _items.indexWhere((element) => element.id == product.id);
          _items[i] = product;
          notifyListeners();
        } else
          print(response.error.message);
      }).catchError((error) {
        print(error);
      });
    });
  }

  Future<void> addProduct(Watch product, File image) async {
    if (product.id != null) {
      return updateProduct(product, image);
    } else {
      var watchObject = ParseObject('Watches')
        ..set('title', product.title)
        ..set('description', product.description)
        ..set('price', product.price)
        ..set('image', ParseFile(image));
      return await watchObject.save().then((response) {
        if (response.success) {
          product = Watch(
            id: response.results.first['objectId'],
            title: product.title,
            description: product.description,
            price: product.price,
            imageUrl: response.results.first['image']['url'],
          );
          _items.add(product);
          notifyListeners();
        } else
          print(response.error.message);
      }).catchError((error) {
        print(error);
      });
    }
  }

  Future<void> deleteProduct(String id) async {
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final watchObject = ParseObject('Watches');
    watchObject.getObject(id).then((response) {
      watchObject.delete().then((response) {
        if (!response.success) {
          _items.insert(existingProductIndex, existingProduct);
          notifyListeners();
        }
        existingProduct = null;
      });
    });
  }
}
