import 'dart:convert';

import 'package:creamee/model/order.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class OrderList extends StatefulWidget {
  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  List<Order> orders = [];

  @override
  void initState() {
    super.initState();
    this.fetchOrder();
  }

  fetchOrder() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var customer = json.decode(localStorage.getString('customer'));
    int customerId = customer['id'];
    print(customerId);

    var url = "http://192.168.0.187:8000/api/order-history/$customerId";
    var response = await http.get(url);
    print(response.body);
    if (response.statusCode == 200) {
      List<dynamic> items = json.decode(response.body)['order'];
      setState(() {
        orders = items.map((order) => Order.fromJson(order)).toList();
        // isLoading = false;
      });
    } else {
      setState(() {
        orders = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Order"),
        backgroundColor: Colors.red[200],
      ),
      body: ListView.builder(
          shrinkWrap: true,
          itemCount: orders.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 2.0,
              margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.white),
                child: makeListTitle(context, index),
              ),
            );
          }),
    );
  }

  ListTile makeListTitle(BuildContext context, int index) => ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        title: Padding(
          padding: EdgeInsets.all(5),
          child: Text(
            'Status:' + orders[index].orderstatus,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        subtitle: Padding(
          padding: EdgeInsets.all(5),
          child: Wrap(
            direction: Axis.vertical,
            children: [
              Text(
                'Order ID:' + orders[index].id.toString(),
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              Text(
                'Order Date:' +
                    "${orders[index].orderdate.day}-${orders[index].orderdate.month}-${orders[index].orderdate.year}",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              Text(
                'Order Amount: RM' + orders[index].amount.toStringAsFixed(2),
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      );
}
