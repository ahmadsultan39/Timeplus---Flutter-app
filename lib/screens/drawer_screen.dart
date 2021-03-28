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
              const Text('Time'),
              const Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: const Text('+'),
              )
            ],
          ),
          automaticallyImplyLeading: false,
        ),
        ListTile(
          leading: const Icon(Icons.shopping_bag_rounded),
          title: const Text('Shop'),
          onTap: () {
            Navigator.of(context)
                .pushReplacementNamed(DiscoverScreen.routeName);
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.receipt_long_rounded),
          title: const Text('Orders'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
          },
        ),
        const Divider(),
        if (admin)
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Watches'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(WatchesScreen.routeName);
            },
          ),
        const Spacer(),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.exit_to_app_rounded),
          title: const Text('Logout'),
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
