import "package:flutter/material.dart";
import "../providers/orders.dart" as ord;
import "package:intl/intl.dart";
import "dart:math";

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$ ${widget.order.amount}'),
            subtitle: Text(DateFormat('hh:mm    dd/MM/yyyy ')
                .format(widget.order.dateTime)),
            trailing: IconButton(
                icon: expanded
                    ? Icon(Icons.expand_less)
                    : Icon(Icons.expand_more),
                onPressed: () {
                  setState(() {
                    expanded = !expanded;
                  });
                }),
          ),
          if (expanded)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              height: min(widget.order.products.length * 20.0 + 10.0, 180),
              child: ListView.builder(itemBuilder: (ctx, index){
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.order.products[index].title),

                    Text("${widget.order.products[index].quantity}x    \$ ${widget.order.products[index].price}")
                  ],
                );
              },itemCount: widget.order.products.length,),
            )
        ],
      ),
    );
  }
}
