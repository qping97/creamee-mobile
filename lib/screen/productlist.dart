import 'package:creamee/utils/custom_stepper.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:creamee/screen/categorylist.dart';
import 'package:creamee/screen/productdetail.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:creamee/model/imagecustom.dart';

class Product {
  int id;
  String name;
  ImageCustom productimage;
  double productprice;
  String description;
  int vendorid;

  Product({
    this.id,
    this.name,
    this.productimage,
    this.productprice,
    this.description,
    this.vendorid,
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
  }
}

class ProductList extends StatefulWidget {
  final Category category;
  const ProductList({Key key, this.category}) : super(key: key);
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List<Product> products = [];
  @override
  void initState() {
    super.initState();
    this.fetchProduct();
  }

  fetchProduct() async {
    var venid = widget.category.vendorid;
    var catid = widget.category.id;
    var url =
        "http://192.168.0.187:8000/api/category-list/$venid/$catid/productlist";
    var response = await http.get(url);
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Store Name"),
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
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    // Text('RM5.50'),
                                  ],
                                ),
                                Text('RM ' +
                                    products[index].productprice.toString()),
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
                        Align(
                            alignment: Alignment.bottomRight,
                            child: RaisedButton(
                              color: Colors.red,
                              onPressed: () {},
                              child: const Text('Add To Cart',
                                  style: TextStyle(
                                    color: Colors.white,
                                  )),
                              elevation: 5,
                            )),
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
