import 'package:cartbaba/providers/auth.dart';
import 'package:cartbaba/providers/cart.dart';
import 'package:cartbaba/providers/orders.dart';
import 'package:cartbaba/screens/edit_product_screen.dart';
import 'package:cartbaba/screens/orders_screen.dart';

import 'package:cartbaba/screens/user_product_screen.dart';
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "screens/auth_screen.dart";

import "screens/product_overview_screen.dart";
import "providers/products.dart";
import "screens/product_detail_screen.dart";
import "screens/cart_screen.dart";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MaterialColor white = const MaterialColor(
    0xFF432344,
    const <int, Color>{
      50: const Color(0xFF432344),
      100: const Color(0xFF432344),
      200: const Color(0xFF432344),
      300: const Color(0xFF432344),
      400: const Color(0xFF432344),
      500: const Color(0xFF432344),
      600: const Color(0xFF432344),
      700: const Color(0xFF432344),
      800: const Color(0xFF432344),
      900: const Color(0xFF432344),
    },
  );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            update: (ctx, auth, previousProducts) => Products(
              auth.token,
              previousProducts == null ? [] : previousProducts.items,
              auth.userId,
            ),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            update: (ctx, authData, previousOrders) => Orders(
              authData.token,
              previousOrders == null ? [] : previousOrders.orders,
              authData.userId,
            ),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Cart Baba",
            theme: ThemeData(
                primarySwatch: white,
                accentColor: Color(0xFFFF2525),
                canvasColor: Color(0xFFE7EEFB),
                fontFamily: 'Syne'),
            home: auth.isAuth ? ProductOverviewScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authResultSnapShot) =>
                        authResultSnapShot.connectionState ==
                                ConnectionState.waiting
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : AuthScreen(),
                  ),
            routes: {
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              UserProductScreen.routeName: (ctx) => UserProductScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen(),
            },
          ),
        ));
  }
}
