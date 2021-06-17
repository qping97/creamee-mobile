import 'package:creamee/provider/userprovider.dart';
import 'package:creamee/provider/vendorprovider.dart';
import 'package:creamee/screen/login.dart';
import 'package:flutter/material.dart';
import 'package:creamee/screen/home.dart';
import 'package:creamee/screen/productlist.dart';
import 'package:creamee/screen/customorder.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:creamee/model/imagecustom.dart';
import 'package:creamee/screen/app.dart';
import 'package:provider/provider.dart';

class Category {
  int id;
  String name;
  ImageCustom image;
  int vendorid;

  Category({
    this.id,
    this.name,
    this.image,
  });
  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image =
        json['image'] != null ? new ImageCustom.fromJson(json['image']) : null;
    vendorid = json['ven_id'];
  }
}

class CategoryList extends StatefulWidget {
  // final String passedData2;

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  List<Category> categories = [];
  VendorProvider vendorProvider;
  UserProvider userProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      vendorProvider = Provider.of<VendorProvider>(context, listen: false);
      this.fetchCategory();
    });
  }

  fetchCategory() async {
    var id = vendorProvider.vendor.id;
    var url = "http://192.168.0.187:8000/api/category-list/$id";
    // print(url);
    var response = await http.get(url);
    // print(response.body);
    if (response.statusCode == 200) {
      List<dynamic> items = json.decode(response.body)['category'];
      setState(() {
        categories =
            items.map((category) => Category.fromJson(category)).toList();
        // isLoading = false;
      });
    } else {
      setState(() {
        categories = [];
      });
      // isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
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
            'Category',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )),
          //  SizedBox(height:30),
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.only(top: 10.0, bottom: 15.0),
                itemCount: categories.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ProductList(category: categories[index])),
                      );
                    },
                    child: Stack(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.fromLTRB(40.0, 5.0, 20.0, 5.0),
                          height: 100.0,
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
                                      categories[index].name,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  ],
                                )
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
                              child: Image.network(categories[index].image.url,
                                  width: 110.0, fit: BoxFit.cover)),
                        )
                      ],
                    ),
                  );
                }
                // ),
                ),
          ),
          Align(
              alignment: Alignment.bottomRight,
              child: RaisedButton(
                onPressed: () {
                  if (Provider.of<UserProvider>(context, listen: false).user ==
                      null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Login(topage: "customorder")),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CustomOrder()),
                    );
                  }
                },
                child: const Text(
                  'Custom Order',
                ),
                elevation: 5,
              )),
          // App(),
        ],
      ),
    );
  }
}
