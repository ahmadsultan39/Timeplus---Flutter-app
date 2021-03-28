import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/watches.dart';
import './providers/auth.dart';
import './providers/orders.dart';

import './Helpers/DBHelper.dart';

import './screens/discover_screen.dart';
import './screens/watch_details_screen.dart';
import './screens/add_watch_screen.dart';
import './screens/watches_screen.dart';
import './screens/auth_screen.dart';
import './screens/orders_screen.dart';
import './screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DBHelper.init(),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor),
                    ),
                  )
                : MultiProvider(
                    providers: [
                      ChangeNotifierProvider.value(
                        value: AuthProvider(),
                      ),
                      ChangeNotifierProvider.value(
                        value: WatchesProvider(),
                      ),
                      ChangeNotifierProvider.value(
                        value: OrdersProvider(),
                      ),
                    ],
                    child: MaterialApp(
                      title: 'Timeplus',
                      theme: ThemeData(
                        fontFamily: 'Product Sans',
                        primaryColor: Color(0xffffe165),
                        textTheme: ThemeData.light().textTheme.copyWith(
                              headline1: const TextStyle(
                                fontFamily: 'Product Sans',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                        appBarTheme: AppBarTheme(
                            textTheme: ThemeData.light().textTheme.copyWith(
                                    headline6: const TextStyle(
                                  fontFamily: 'OpenSans',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ))),
                      ),
                      home: Consumer<AuthProvider>(
                          builder: (ctx, auth, _) => FutureBuilder(
                              future: auth.isAuth(),
                              builder: (ctx, snapshot) =>
                                  snapshot.connectionState ==
                                          ConnectionState.waiting
                                      ? SplashScreen()
                                      : snapshot.data == true
                                          ? DiscoverScreen()
                                          : AuthScreen())),
                      routes: {
                        DiscoverScreen.routeName: (ctx) => DiscoverScreen(),
                        WatchDetailsScreen.routeName: (ctx) =>
                            WatchDetailsScreen(),
                        WatchesScreen.routeName: (ctx) => WatchesScreen(),
                        AddWatchScreen.routeName: (ctx) => AddWatchScreen(),
                        OrdersScreen.routeName: (ctx) => OrdersScreen(),
                      },
                    ),
                  ));
  }
}
