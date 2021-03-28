import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/watches.dart';

import '../screens/add_watch_screen.dart';

class WatchItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String id;
  WatchItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      title: Text(title),
      trailing: Container(
        width: 100,
        child: Row(children: [
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(AddWatchScreen.routeName, arguments: id);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.delete_rounded,
              color: Theme.of(context).errorColor,
            ),
            onPressed: () async {
              try {
                await Provider.of<WatchesProvider>(context, listen: false)
                    .deleteProduct(id);
              } catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      'Deleting failed!',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
            },
          ),
        ]),
      ),
    );
  }
}
