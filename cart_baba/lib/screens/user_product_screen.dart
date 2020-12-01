import '../widgets/user_product_item.dart';
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../providers/products.dart";
import "../widgets/app_drawer.dart";
import "edit_product_screen.dart";

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchProducts(true);
  }

  @override
  Widget build(BuildContext context) {
//    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(

          "Your Products",
          style: TextStyle(color: Theme.of(context).canvasColor),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Theme.of(context).canvasColor),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<Products>(
                      builder: (ctx, productsData, _) => Padding(
                        padding: EdgeInsets.all(10),
                        child: ListView.builder(
                          itemBuilder: (ctx, index) {
                            return Column(children: [
                              UserProductItem(
                                  productsData.items[index].id,
                                  productsData.items[index].title,
                                  productsData.items[index].imageUrl),
                              Divider(
                                thickness: 1,
                                color: Theme.of(context).primaryColor,
                                height: 15,
                                indent: 20,
                                endIndent: 20,
                              ),
                            ]);
                          },
                          itemCount: productsData.items.length,
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
