import 'package:creamee/model/order.dart';
import 'package:creamee/model/user.dart';
import 'package:creamee/provider/userprovider.dart';
import 'package:creamee/screen/app.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:creamee/screen/editaccount.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:creamee/model/imagecustom.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetail extends StatefulWidget {
  final Order order;
  OrderDetail({Key key, this.order}) : super(key: key);
  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  // bool circular = true;
  @override
  void initState() {
    super.initState();
    print(widget.order);
  }

  // ProfileModel profileModel = ProfileModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Order Detail"),
          backgroundColor: Colors.red[200],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 10),
              Center(
                  child: Text(
                'Order #' + widget.order.id.toString(),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )),
              // Row(children: [
              //   Card(
              //     color: Colors.black,
              //   ),
              // ]),
              new Card(
                child: new ListTile(
                  isThreeLine: true,
                  title: Text('Order Details'),
                  subtitle: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text('Delivery Address:',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(widget.order.customer.name),
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(widget.order.customer.contactno),
                            ]),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        widget.order.shippingaddress,
                                        maxLines: 3,
                                      ),
                                    ),
                                  ]),
                            ]),
                        SizedBox(
                          height: 15,
                        ),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Order Notes:',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                  ]),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        widget.order.ordernotes,
                                        maxLines: 4,
                                      ),
                                    )
                                  ]),
                            ]),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                  'Order Date        :' +
                                      "${widget.order.orderdate.day}-${widget.order.orderdate.month}-${widget.order.orderdate.year}",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                  'Pickup Date      :' +
                                      "${widget.order.pickupdate.day}-${widget.order.pickupdate.month}-${widget.order.pickupdate.year}",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                            ]),
                        SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Card(
                elevation: 3,
                child: Column(children: <Widget>[
                  new Card(
                    color: Colors.grey[100],
                    child: new Container(
                      padding: EdgeInsets.all(10.0),
                      child: new Column(
                        children: <Widget>[
                          new Row(
                            children: <Widget>[
                              new Expanded(
                                  child: new Text(
                                widget.order.products[0].vendor.vname,
                              )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  ListView.builder(
                    // inner ListView
                    shrinkWrap: true,
                    primary: false, // 1st add
                    itemCount: widget.order.products.length,
                    itemBuilder: (_, index) => ListTile(
                      tileColor: Colors.grey[50],
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 15.0),
                      trailing: Column(children: <Widget>[
                        Text('RM ' +
                            widget.order.products[index].productprice
                                .toString()),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 2, 0),
                          child: Text("\nx" +
                              widget.order.products[index].pivot.quantities
                                  .toString()),
                        )
                      ]),
                      leading: Container(
                          width: 50,
                          height: 150,
                          alignment: Alignment.center,
                          // child: CircleAvatar(
                          //     backgroundImage: AssetImage("assets/profile.png")),
                          child: Image.network(
                            widget.order != null
                                ? widget.order.products[index].productimage.url
                                : '',
                            height: 150,
                          )),
                      title: Padding(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          widget.order.products[index].name,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    new Text("Subtotal"),
                    new Text(
                      "RM" + (calculatesubtotal()).toStringAsFixed(2),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    new Text("Delivery Fees"),
                    new Text(
                      "RM" + widget.order.deliveryfee.toStringAsFixed(2),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    new Text(
                      "Total",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    new Text(
                      "RM" + widget.order.amount.toStringAsFixed(2),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              new Card(
                child: new ListTile(
                  isThreeLine: true,
                  title: const Text('Payment Method'),
                  subtitle: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(widget.order.payment),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Term and Condition：',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(
                    'The customers are allowed to amend or cancel the order three days before date of pickup',
                    style: TextStyle(
                      color: Colors.red,
                    )),
              ),
              SizedBox(
                height: 18,
              ),
              Center(
                child: InkWell(
                  onTap: () {
                    launch(
                        "sms://${widget.order.products[0].vendor.contactno}");
                  },
                  child: Container(
                    width: 200,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "Contact Vendor",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  calculatesubtotal() {
    double subtotal = 0.00;

    widget.order.products.forEach((product) {
      subtotal += product.productprice * product.pivot.quantities;
    });
    return subtotal;
  }
}
