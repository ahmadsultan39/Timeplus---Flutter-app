import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class Order {
  final String id;
  final String userId;
  final String userNumber;
  final String watchId;
  final int amount;
  final String location;
  final DateTime orderDate;

  Order({
    this.id,
    @required this.userId,
    @required this.userNumber,
    @required this.watchId,
    @required this.amount,
    @required this.location,
    @required this.orderDate,
  });
}

class OrdersProvider with ChangeNotifier {
  List<Order> _orders = [
    // Order(
    //   id: DateTime.now().toString(),
    //   userId: 'RkIMtqPKkz',
    //   watchId: 'tFB0e5RVbh',
    //   amount: 2,
    //   location: 'mazzeh',
    //   orderDate: DateTime.now(),
    // )
  ];

  List<Order> get orders {
    return [..._orders];
  }

  Future<void> fetchOrders() async {
    List<Order> load = [];

    ParseObject orderObject = ParseObject("Orders");

    try {
      var response = await orderObject.getAll();

      if (response.success && response.results != null) {
        response.results.forEach((order) {
          load.add(Order(
            id: order.objectId,
            userId: order['userId'],
            userNumber: order['userNumber'],
            watchId: order['watchId'],
            amount: order['amount'],
            location: order['location'],
            orderDate: DateTime.parse(order['orderDate']),
          ));
        });
        _orders = load.reversed.toList();
        notifyListeners();
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> fetchOrdersByUserId(String userId) async {
    List<Order> load = [];

    ParseObject orderObject = ParseObject("Orders");

    QueryBuilder<ParseObject> orderId = QueryBuilder<ParseObject>(orderObject)
      ..whereEqualTo('userId', userId);
    try {
      var response = await orderId.query();

      if (response.success && response.results != null) {
        response.results.forEach((order) {
          load.add(Order(
            id: order.objectId,
            userId: order['userId'],
            userNumber: order['userNumber'],
            watchId: order['watchId'],
            amount: order['amount'],
            location: order['location'],
            orderDate: DateTime.parse(order['orderDate']),
          ));
        });
        _orders = load.reversed.toList();
        notifyListeners();
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> placeOrder(Order order) async {
    var orderObject = ParseObject('Orders')
      ..set('userId', order.userId)
      ..set('userNumber', order.userNumber)
      ..set('watchId', order.watchId)
      ..set('amount', order.amount)
      ..set('location', order.location)
      ..set('orderDate', order.orderDate.toIso8601String());
    return await orderObject.save().then((response) {
      if (response.success) {
        order = Order(
          id: response.results.first['objectId'],
          userId: order.userId,
          userNumber: order.userNumber,
          watchId: order.watchId,
          amount: order.amount,
          location: order.location,
          orderDate: order.orderDate,
        );
        orders.add(order);
        notifyListeners();
      } else
        print(response.error.message);
    }).catchError((error) {
      print(error);
    });
  }
}
