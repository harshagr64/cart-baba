import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../providers/cart.dart";

class CartItem extends StatelessWidget {
  final String id;
  final String title;
  final double price;
  final String productId;
  final int quantity;

  CartItem(this.id, this.title, this.quantity, this.price, this.productId);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text("Are You Sure ?"),
                  content:
                      Text("Do you want to remove the item from the cart ?"),
              actions: [
                FlatButton(
                  child: Text("No"),
                  onPressed: () {
                    Navigator.of(ctx).pop(
                      false
                    );
                  },
                ),
                FlatButton(
                  child: Text("Yes"),
                  onPressed: () {
                    Navigator.of(context).pop(
                      true
                    );
                  },
                )
              ],
                )
        );
      },
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      background: Container(
        color: Theme.of(context).accentColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 30,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(vertical: 6, horizontal: 15),
      ),
      child: Card(
        elevation: 5,
        margin: EdgeInsets.symmetric(vertical: 6, horizontal: 15),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListTile(
            leading: CircleAvatar(
              child: FittedBox(
                  child: Padding(
                      padding: EdgeInsets.all(5), child: Text('\$ $price'))),
            ),
            title: Text(
              '$title',
              style: TextStyle(fontSize: 20),
            ),
            subtitle: Text('Total: \$ ${(price * quantity).toStringAsFixed(2)}'),
            trailing: Text(
              '$quantity x',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }
}
