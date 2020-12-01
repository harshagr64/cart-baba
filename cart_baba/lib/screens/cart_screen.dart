import 'package:cartbaba/providers/cart.dart';
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../widgets/cart_item.dart" as ci;
import "../providers/orders.dart";

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your Cart",
          style: TextStyle(color: Theme.of(context).canvasColor),
        ),
      ),
      body: Column(
        children: <Widget>[
          Card(
            elevation: 5,
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total:',
                    style: TextStyle(
                        fontSize: 20, color: Theme.of(context).primaryColor),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$ ${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(color: Theme.of(context).canvasColor),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderNow(cart: cart)
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, index) {
                return ci.CartItem(
                    cart.items.values.toList()[index].id,
                    cart.items.values.toList()[index].title,
                    cart.items.values.toList()[index].quantity,
                    cart.items.values.toList()[index].price,
                    cart.items.keys.toList()[index]);
              },
              itemCount: cart.itemCount,
            ),
          ),
        ],
      ),
    );
  }
}

class OrderNow extends StatefulWidget {
  const OrderNow({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderNowState createState() => _OrderNowState();
}

class _OrderNowState extends State<OrderNow> {

  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
        onPressed: (widget.cart.totalAmount <= 0 || _isLoading)? null: () async{

          setState(() {
            _isLoading = true;
          });
          await Provider.of<Orders>(context, listen: false).addOrders(
              widget.cart.items.values.toList(), widget.cart.totalAmount);
          setState(() {
            _isLoading = false;
          });

          widget.cart.clear();
        },
        child: _isLoading? Center(child: SizedBox(
          width: 20,
            height: 20,
            child: CircularProgressIndicator()),):Text(
          "Order Now",
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 18),
        ));
  }
}
