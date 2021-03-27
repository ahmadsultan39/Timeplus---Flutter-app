import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeplus/providers/watches.dart';

// import '../providers/watches.dart';

import './drawer_screen.dart';
import './add_watch_screen.dart';

import '../widgets/watch_item.dart';

class WatchesScreen extends StatelessWidget {
  static const routeName = '/watches';

  Future<void> _refresh(BuildContext context) async {
    await Provider.of<WatchesProvider>(context,listen: false).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    // final products = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add_circle_rounded,
              size: 25,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(AddWatchScreen.routeName);
            },
          )
        ],
      ),
      drawer: DrawerScreen(),
      body: RefreshIndicator(color: Theme.of(context).primaryColor,
        onRefresh: () => _refresh(context),
        child: FutureBuilder(
          future: _refresh(context),
          builder: (ctx, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? Center(child: CircularProgressIndicator( valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor),))
                  : Consumer<WatchesProvider>(
                      builder: (ctx, watches, _) => Container(
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.all(8),
                        child: ListView.builder(
                          itemCount: watches.items.length,
                          itemBuilder: (_, i) => Column(
                            children: [
                              WatchItem(
                                watches.items[i].id,
                                watches.items[i].title,
                                watches.items[i].imageUrl,
                              ),
                              Divider(),
                            ],
                          ),
                        ),
                      ),
                    ),
        ),
      ),
    );
  }
}
