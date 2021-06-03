import 'dart:convert';

import 'package:creamee/model/cartitem.dart';
import 'package:creamee/screen/checkout.dart';
import 'package:creamee/screen/productlist.dart';
import 'package:creamee/utils/custom_stepper.dart';
import 'package:creamee/widget/loadingwidget.dart';
import 'package:creamee/widget/widget_cart_product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:creamee/model/payload.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Cart extends StatefulWidget {
  final CartItem quantity;
  Cart({this.quantity});
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  List<CartItem> cartitems = [];
  String subtotal;
  @override
  void initState() {
    super.initState();
    this.fetchCart();
  }

  void removeItem(int productId) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var customer = json.decode(localStorage.getString('customer'));
    int customerId = customer['id'];
    dynamic respStr;

    var url = Uri.parse("http://192.168.0.187:8000/api/remove-item");
    var request = http.Request("DELETE", url);
    request.headers.addAll(<String, String>{
      "Accept": "*/*",
      "Content-Type": "application/json",
    });
    request.body =
        jsonEncode({"customerId": '$customerId', "productId": '$productId'});
    final response = await request.send();
    // body: {'customerId': '$customerId', 'productId': '$productId'});

    if (response.statusCode == 200) {
      print(customerId);
      print(productId);
      respStr = await response.stream.bytesToString();
      print(respStr);
      // print(response.);
      print("deleted");
    } else {
      print("fail");
    }
    setState(() {
      Payload payload = Payload.fromJson(json.decode(respStr)['payload']);
      List<dynamic> items = payload.products;
      cartitems = items.map((e) => CartItem.fromJson(e)).toList();
      subtotal = payload.subTotal;
    });
  }

  fetchCart() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var customer = json.decode(localStorage.getString('customer'));
    int customerId = customer['id'];
    print(customerId);
    print('see cart......................................');

    var url = "http://192.168.0.187:8000/api/get-cart/$customerId";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      Payload payload = Payload.fromJson(json.decode(response.body)['payload']);
      List<dynamic> items = payload.products;
      setState(() {
        cartitems = items.map((e) => CartItem.fromJson(e)).toList();
        subtotal = payload.subTotal;
      });
    } else {
      setState(() {});
    }
  }

  updateCart(int productId, int quantity) async {
    loadingDialog(context);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var customer = json.decode(localStorage.getString('customer'));
    int customerId = customer['id'];
    var url = "http://192.168.0.187:8000/api/update-quantity";
    print(customerId);
    print(productId);
    print(quantity);

    var response = await http.patch(url, body: {
      "userId": '$customerId',
      "productId": '$productId',
      "quantity": '$quantity'
    });
    print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        print(response.body);
      });
    } else {
      setState(() {});
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Cart"),
        backgroundColor: Colors.red[200],
      ),
      body:
          //  cartitems.length == null
          //     ? Container(
          //         child: Center(child: Text("No Item Found")),
          //       )
          //     :
          Container(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: cartitems.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CartProduct(
                      cartitem: cartitems[index],
                      onRemove: removeItem,
                      onValueChanged: updateCart,
                    );
                  }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  new Text(
                    "Subtotal:  ",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "RM" + subtotal.toString(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              height: 100,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      // child: FlatButton(
                      //   child: Wrap(
                      //     alignment: WrapAlignment.center,
                      //     crossAxisAlignment: WrapCrossAlignment.center,
                      //     children: [
                      //       Text(
                      //         '  Update Cart ',
                      //         style: TextStyle(color: Colors.white),
                      //       ),
                      //       Icon(
                      //         Icons.sync,
                      //         color: Colors.white,
                      //       ),
                      //     ],
                      //   ),
                      //   onPressed: () {
                      //     // updateCart(productId, quantity);
                      //   },
                      //   padding: EdgeInsets.all(10),
                      //   color: Colors.green,
                      //   shape: StadiumBorder(),
                      // ),
                    ),
                    FlatButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            ' Checkout ',
                            style: TextStyle(color: Colors.white),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Checkout()),
                        );
                      },
                      padding: EdgeInsets.all(10),
                      color: Colors.redAccent,
                      shape: StadiumBorder(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
