import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

import './watches_screen.dart';
import './orders_screen.dart';
import './discover_screen.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen();

  @override
  Widget build(BuildContext context) {
    final admin = Provider.of<AuthProvider>(context).admin;
    return Drawer(
      child: Column(children: [
        AppBar(
          title: Row(
            children: [
              Text('Time'),
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text('+'),
              )
            ],
          ),
          automaticallyImplyLeading: false,
        ),
        ListTile(
          leading: Icon(Icons.shopping_bag_rounded),
          title: Text('Shop'),
          onTap: () {
            Navigator.of(context)
                .pushReplacementNamed(DiscoverScreen.routeName);
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.receipt_long_rounded),
          title: Text('Orders'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
          },
        ),
        Divider(),
        if (admin)
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Watches'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(WatchesScreen.routeName);
            },
          ),
        Spacer(),
        Divider(),
        ListTile(
          leading: Icon(Icons.exit_to_app_rounded),
          title: Text('Logout'),
          onTap: () {
            // Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed('/');
            Provider.of<AuthProvider>(context, listen: false).logout();
          },
        )
      ]),
    );
  }
}
