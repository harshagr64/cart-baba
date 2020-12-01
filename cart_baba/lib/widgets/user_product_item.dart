import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import "../providers/products.dart";
import "../screens/edit_product_screen.dart";

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    final navigator = Navigator.of(context);
    return ListTile(
      leading: CircleAvatar(
        radius: 25,
        backgroundImage: NetworkImage(imageUrl),
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
            ),
            IconButton(
              icon: Icon(
                Icons.delete_outline,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) {
                    return AlertDialog(
                      title: Text("Are You Sure?"),
                      content: Text(
                          "DO you want to Delete this Product from your Product ?"),
                      actions: [
                        FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("No")),
                        FlatButton(
                            onPressed: () async {
                              navigator.pop();
                              try {
                                await Provider.of<Products>(context, listen: false)
                                    .deleteProduct(id);
//                                navigator.pop();
                              } catch (error) {

                                scaffold.showSnackBar(
                                    SnackBar(content: Text('Deletion Failed')));
                              }

                            },
                            child: Text("Yes")),
                      ],
                    );
                  },
                );
//
              },
            )
          ],
        ),
      ),
    );
  }
}
