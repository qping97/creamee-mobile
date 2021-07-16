import 'package:creamee/model/vendor.dart';
import 'package:creamee/provider/cartprovider.dart';
import 'package:creamee/provider/userprovider.dart';
import 'package:creamee/provider/vendorprovider.dart';
import 'package:creamee/screen/login.dart';
import 'package:creamee/utils/custom_stepper.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:creamee/screen/categorylist.dart';
import 'package:creamee/screen/productdetail.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:creamee/model/imagecustom.dart';
import 'package:creamee/screen/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:creamee/network_utils/api.dart';
import 'package:creamee/model/user.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Pivot {
  int orderid;
  int productid;
  int quantities;

  Pivot({
    this.orderid,
    this.productid,
    this.quantities,
  });

  Pivot.fromJson(Map<String, dynamic> json) {
    orderid = json['order_id'];
    productid = json['product_id'];
    quantities = json['quantity'];
  }
}

class Product {
  int id;
  String name;
  ImageCustom productimage;
  double productprice;
  String description;
  int vendorid;
  Pivot pivot;
  Vendor vendor;

  Product({
    this.id,
    this.name,
    this.productimage,
    this.productprice,
    this.description,
    this.vendorid,
    this.pivot,
    this.vendor,
  });

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    productimage = json['product_img'] != null
        ? new ImageCustom.fromJson(json['product_img'])
        : null;
    productprice = double.parse(json['product_price']);
    description = json['description'];
    vendorid = json['vendor_id'];
    pivot = json['pivot'] != null ? new Pivot.fromJson(json['pivot']) : null;
    vendor =
        json['vendor'] != null ? new Vendor.fromJson(json['vendor']) : null;
  }
}

class ProductList extends StatefulWidget {
  final Category category;
  const ProductList({Key key, this.category}) : super(key: key);
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  VendorProvider vendorProvider;
  List<Product> products = [];
  CartProvider cartProvider;
  UserProvider userProvider;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      vendorProvider = Provider.of<VendorProvider>(context, listen: false);
      this.fetchProduct();
    });
  }

  fetchProduct() async {
    var venid = widget.category.vendorid;
    var catid = widget.category.id;
    var url =
        "http://192.168.0.187:8000/api/category-list/$venid/$catid/productlist";
    var response = await http.get(url);
    // print(venid);
    // print(catid);
    // print(response.body);
    if (response.statusCode == 200) {
      List<dynamic> items = json.decode(response.body)['productlist'];
      setState(() {
        products = items.map((product) => Product.fromJson(product)).toList();
        // isLoading = false;
      });
    } else {
      setState(() {
        products = [];
      });
      // isLoading = false;
    }
  }

  addtoCart(productId) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var customer = json.decode(localStorage.getString('customer'));
    int customerId = customer['id'];
    print(customerId);
    print(productId);

    var url = "http://192.168.0.187:8000/api/addtocart";
    var response = await http.post(url,
        body: {'customer_id': '$customerId', 'product_id': '$productId'});
    // print(response.body);
    if (response.statusCode == 200) {
      // print(response.body);
      await fetchProduct();
    } else {
      setState(() {
        confirmationPopup(context);
      });
    }
  }

  confirmationPopup(BuildContext dialogContext) {
    var alertStyle = AlertStyle(
      animationType: AnimationType.grow,
      overlayColor: Colors.black87,
      isCloseButton: true,
      isOverlayTapDismiss: true,
      titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      descStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      animationDuration: Duration(milliseconds: 400),
    );

    Alert(
        context: dialogContext,
        style: alertStyle,
        title:
            "Are you sure you want to select this product?You will need to clear the cart to add this product.",
        buttons: [
          DialogButton(
            child: Text(
              "ok",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.grey,
          ),
        ]).show();
  }

  Widget build(BuildContext context) {
    cartProvider = Provider.of<CartProvider>(context);
    userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(vendorProvider?.vendor?.vname ?? ""),
        backgroundColor: Colors.red[200],
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 10),
          Center(
              child: Text(
            widget.category.name,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )),
          //  SizedBox(height:30),
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.only(top: 10.0, bottom: 15.0),
                itemCount: products.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ProductDetail(product: products[index])),
                      );
                    },
                    child: Stack(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.fromLTRB(40.0, 5.0, 20.0, 5.0),
                          height: 170.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Padding(
                            padding:
                                EdgeInsets.fromLTRB(100.0, 20.0, 20.0, 20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      products[index].name,
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    // Text('RM5.50'),
                                  ],
                                ),
                                Text('RM ' +
                                    products[index]
                                        .productprice
                                        .toStringAsFixed(2)),
                                Align(
                                    alignment: Alignment.bottomRight,
                                    child: RaisedButton(
                                      color: Colors.red,
                                      onPressed: () {
                                        if (Provider.of<UserProvider>(context,
                                                    listen: false)
                                                .user ==
                                            null) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Login(
                                                    topage: "productlist")),
                                          );
                                        } else {
                                          addtoCart(products[index].id);
                                        }
                                      },
                                      child: const Text('Add To Cart',
                                          style: TextStyle(
                                            color: Colors.white,
                                          )),
                                      elevation: 5,
                                    )),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 20.0,
                          top: 15.0,
                          bottom: 15.0,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Image.network(
                                  products[index].productimage.url,
                                  width: 110.0,
                                  fit: BoxFit.cover)
                              // child: Image(
                              //   width: 110.0,
                              //   image: NetworkImage(categories[index].name),
                              //   fit: BoxFit.cover,
                              // ),
                              ),
                        ),
                      ],
                    ),
                  );
                }
                // ),
                ),
          ),
        ],
      ),
    );
  }
}
