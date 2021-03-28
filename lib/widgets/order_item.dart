import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../providers/orders.dart' show Order;
import '../providers/watches.dart';
import '../providers/auth.dart';

class OrderItem extends StatelessWidget {
  final Order order;

  OrderItem(this.order);

  @override
  Widget build(BuildContext context) {
    final watch = Provider.of<WatchesProvider>(context, listen: false)
        .findId(order.watchId);
    final mediaQuery = MediaQuery.of(context);
    final card = Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
          padding: const EdgeInsets.all(5),
          height: mediaQuery.size.width * 0.40 + 8,
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: mediaQuery.size.width * 0.40,
                height: mediaQuery.size.width * 0.40,
                margin: const EdgeInsets.only(right: 8),
                child: CachedNetworkImage(
                  imageUrl: watch.imageUrl,
                  placeholder: (context, url) =>
                      Image.asset('assets/images/watch.png'),
                  errorWidget: (context, url, error) =>
                      const Center(child: const Icon(Icons.error)),
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                width: mediaQuery.size.width * 0.50,
                child: ListView(
                  children: [
                    Text(
                      watch.title,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text('amount : ${order.amount}'),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                        'total : ${(order.amount * watch.price).toStringAsFixed(0)} SYP'),
                    const SizedBox(
                      height: 8,
                    ),
                    Text('number : ${order.userNumber}'),
                    const SizedBox(
                      height: 8,
                    ),
                    Text('location : ${order.location}'),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      child: Text(
                        DateFormat('dd/MM/yyyy hh:mm').format(order.orderDate),
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          )),
    );
    final auth = Provider.of<AuthProvider>(context).admin;
    if (auth)
      return Dismissible(
          key: ValueKey(order.id),
          background: Container(
            color: Theme.of(context).errorColor,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            padding: const EdgeInsets.all(15),
            child: const Icon(
              Icons.delete_rounded,
              color: Colors.white,
              size: 35,
            ),
            alignment: Alignment.centerRight,
          ),
          direction: DismissDirection.endToStart,
          confirmDismiss: (direction) async {
            return await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Confirm"),
                  content:
                      const Text("Are you sure you wish to delete this item?"),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text("DELETE")),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text("CANCEL"),
                    ),
                  ],
                );
              },
            );
          },
          onDismissed: (direction) {
            // cart.deleteProductFromCart(productId);
          },
          child: card);
    else
      return card;
  }
}
