import 'package:cartbaba/screens/cart_screen.dart';
import 'package:cartbaba/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "../providers/products.dart";
import "../widgets/product_grid.dart";
import "../widgets/badge.dart";
import "../providers/cart.dart";

enum FilterOptions {
  Favorites,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOnlyFavorites = false;
  var _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      _isLoading = true;
    });
    Provider.of<Products>(context, listen: false).fetchProducts().then((_) {
      setState(() {
        _isLoading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color myColor = Color(0xFFE7EEFB);
    return Scaffold(
      backgroundColor: myColor,
      appBar: AppBar(
        title: Text(_showOnlyFavorites ? "Your Favorites" : "Cart Baba",
          style: TextStyle(color: Theme
              .of(context)
              .canvasColor),),
        actions: <Widget>[
          PopupMenuButton(
            color: Theme
                .of(context)
                .canvasColor,
            onSelected: (selectedValue) {
              print(selectedValue);
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
//
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: Icon(Icons.more_vert, color: Theme
                .of(context)
                .canvasColor,),
            itemBuilder: (_) =>
            [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (ctx, cart, ch) =>
                Badge(
                  child: ch,
                  value: cart.itemTotalCount.toString(),
                ),
            child: IconButton(
              color: Theme
                  .of(context)
                  .canvasColor,
              icon: Icon(Icons.shopping_basket),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),

        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading ? Center(child: CircularProgressIndicator(),) : ProductGrid(_showOnlyFavorites),
    );
  }
}
