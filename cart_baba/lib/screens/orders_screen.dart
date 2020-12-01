  import 'package:cartbaba/widgets/app_drawer.dart';
import "package:flutter/material.dart";
import "../providers/orders.dart" as ord;
import "package:provider/provider.dart";
import "../widgets/order_item.dart";

class OrdersScreen extends StatefulWidget {
  static const routeName = "orders";

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _isLoading = false;

  Future<void> refreshOrders() async{
    await Provider.of<ord.Orders>(context,listen: false).fetchOrders();
  }

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      _isLoading = true;
    });
    Provider.of<ord.Orders>(context, listen: false).fetchOrders().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<ord.Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your Orders",
          style: TextStyle(color: Theme.of(context).canvasColor),
        ),
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: refreshOrders,
            child: ListView.builder(
                itemBuilder: (ctx, index) {
                  return OrderItem(
                    orderData.orders[index],
                  );
                },
                itemCount: orderData.orders.length,
              ),
          ),
    );
  }
}
