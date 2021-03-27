import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart' show Order;
import '../providers/watches.dart';
import 'package:intl/intl.dart';
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
                child: FadeInImage(
                  placeholder: AssetImage('assets/images/watch.png'),
                  image: NetworkImage(
                    watch.imageUrl,
                  ),
                  fit: BoxFit.cover,
                  imageErrorBuilder: (BuildContext context, Object exception,
                      StackTrace stackTrace) {
                    return Center(child: Text('Can\'t load image'));
                  },
                ),
              ),
              Container(
                width: mediaQuery.size.width * 0.50,
                child: ListView(
                  // Column(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      watch.title,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text('amount : ${order.amount}'),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                        'total : ${(order.amount * watch.price).toStringAsFixed(0)} SYP'),
                    SizedBox(
                      height: 8,
                    ),
                    Text('number : ${order.userNumber}'),
                    SizedBox(
                      height: 8,
                    ),
                    Text('location : ${order.location}'),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      child: Text(
                        DateFormat('dd/MM/yyyy hh:mm').format(order.orderDate),
                        style: TextStyle(
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
            child: Icon(
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
