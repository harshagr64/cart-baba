

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../providers/products.dart";

class ProductDetailScreen extends StatelessWidget {
  static const routeName = 'product-detail-screen';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    print(productId);
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(productId);
    print(loadedProduct);
    return Scaffold(
        appBar: AppBar(
          title: Text(loadedProduct.title, style: TextStyle(color: Theme.of(context).canvasColor)),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Padding(
              padding: EdgeInsets.all(5),
              child: Card(
                elevation: 5,
                child: Container(
                  height: 300,
                  width: double.infinity,
                  child: Image.network(
                    loadedProduct.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              '\$ ${loadedProduct.price}',
              style: TextStyle(color: Colors.grey, fontSize: 25),
            ),
            SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text('${loadedProduct.description}', textAlign: TextAlign.center, softWrap: true,style: TextStyle(fontSize: 20),)),
          ]),
        ));
  }
}
