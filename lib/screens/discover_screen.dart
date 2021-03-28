import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/watches.dart';

import './drawer_screen.dart';

import '../widgets/discover_list_item.dart';

class DiscoverScreen extends StatelessWidget {
  static const routeName = '/home';
  Future<void> _refresh(BuildContext context) async {
    await Provider.of<WatchesProvider>(context, listen: false).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        children: [
          const Text(
            'Time',
          ),
          const Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: const Text(
              '+',
            ),
          )
        ],
      )),
      drawer: DrawerScreen(),
      body: RefreshIndicator(
        color: Theme.of(context).primaryColor,
        onRefresh: () => _refresh(context),
        child: FutureBuilder(
          future: _refresh(context),
          builder: (ctx, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor),
                      ),
                    )
                  : Consumer<WatchesProvider>(
                      builder: (ctx, watches, _) {
                        return ListView.builder(
                            itemCount: watches.items.length,
                            itemBuilder: (ctx, index) {
                              return DiscoverListItem(watches.items[index].id);
                            });
                      },
                    ),
        ),
      ),
    );
  }
}
