import 'dart:convert';

import 'package:creamee/model/order.dart';
import 'package:creamee/screen/order-detail.dart';
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
        print("quantityttttttttt");
        print(orders[0].products[0].pivot.quantities);
        print(orders[0].products[0].vendor.vname);
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
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OrderDetail(order: orders[index])),
                );
              },
              child: Column(
                  // elevation: 2.0,
                  // margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                  children: [
                    Card(
                      elevation: 2.0,
                      margin: new EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 8.0),
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white),
                        child: Column(children: <Widget>[
                          makeListTitle(context, index),
                          ListView.builder(
                            shrinkWrap: true, // 1st add
                            physics: ClampingScrollPhysics(), // 2nd add
                            itemCount: orders[index].products.length,
                            itemBuilder: (_, productindex) => ListTile(
                              tileColor: Colors.grey[50],
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 20.0),
                              trailing: Column(children: <Widget>[
                                Text(orders != null
                                    ? 'RM ' +
                                        orders[index]
                                            .products[productindex]
                                            .productprice
                                            .toStringAsFixed(2)
                                    : ''),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 2, 0),
                                  child: Text(orders != null
                                      ? '\nx ' +
                                          orders[index]
                                              .products[productindex]
                                              .pivot
                                              .quantities
                                              .toString()
                                      : ''),
                                )
                              ]),
                              leading: Container(
                                width: 50,
                                height: 150,
                                alignment: Alignment.center,
                                // child: CircleAvatar(
                                //     backgroundImage:
                                //         AssetImage("assets/profile.png")),
                                child: Image.network(
                                  orders != null
                                      ? orders[index]
                                          .products[productindex]
                                          .productimage
                                          .url
                                      : '',
                                  height: 150,
                                ),
                              ),
                              title: Padding(
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  orders != null
                                      ? orders[index]
                                          .products[productindex]
                                          .name
                                      : '',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                "Total: RM" +
                                    orders[index].amount.toStringAsFixed(2) +
                                    "  ",
                              )),
                          SizedBox(
                            height: 25,
                          ),
                        ]),
                      ),
                    ),
                  ]),
            );
          }),
    );
  }

  ListTile makeListTitle(BuildContext context, int index) => ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        title: Padding(
          padding: EdgeInsets.all(0),
          child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
            Expanded(
              child: new Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Text(orders[index].products[0].vendor.vname),
              ),
            ),
            Expanded(
              child:
                  new Stack(alignment: Alignment.topRight, children: <Widget>[
                Text(orders[index].orderstatus),
              ]),
            ),
          ]),
        ),
        subtitle: Padding(
          padding: EdgeInsets.all(5),
          child: Wrap(
            direction: Axis.vertical,
            children: [
              Text(
                'Order ID: ' + orders[index].id.toString(),
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
            ],
          ),
        ),
      );
}
