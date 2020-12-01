import "package:flutter/material.dart";
import "../providers/auth.dart";
import "../screens/product_detail_screen.dart";
import "package:provider/provider.dart";
import "../providers/product.dart";
import "../providers/cart.dart";

class ProductItem extends StatelessWidget {
  Widget iconButtonBuilder(
      IconData icon, Function myFun, Color color, BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      onPressed: myFun,
      color: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.elliptical(30, 30)),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: product.id);
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: Container(
          margin: EdgeInsets.all(3),
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(20), bottom: Radius.circular(40)),
            child: GridTileBar(
              backgroundColor: Colors.black87,
              leading: Consumer<Product>(
                builder: (ctx, product, child) => iconButtonBuilder(
                    product.isFavorite ? Icons.favorite : Icons.favorite_border,
                    () {
                  product.toggleStatusFavorite(authData.token, authData.userId);
                }, Theme.of(context).accentColor, context),
              ),
              trailing: iconButtonBuilder(Icons.shopping_basket, () {
                cart.addItem(product.id, product.price, product.title);
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(SnackBar(
                  backgroundColor: Theme.of(context).primaryColor,
                  content: Text(
                    "Successfully Added to Cart !",
                    style: TextStyle(color: Theme.of(context).canvasColor),
                  ),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        cart.removeSingleItem(product.id);
                      }),
                ));
              }, Theme.of(context).accentColor, context),
              title: Text(
                product.title,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
