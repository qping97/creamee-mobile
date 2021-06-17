import 'dart:convert';

import 'package:creamee/provider/userprovider.dart';
import 'package:creamee/screen/login.dart';
import 'package:creamee/screen/productlist.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';

class ProductDetail extends StatefulWidget {
  final Product product;
  const ProductDetail({Key key, this.product}) : super(key: key);
  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  // @override
  UserProvider userProvider;

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
      print(response.body);
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
            "Are you sure you want to select this product? You will need to clear the cart to add this product.",
        buttons: [
          DialogButton(
            child: Text(
              "Ok",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.grey,
          )
        ]).show();
  }

  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      body: Stack(
        children: [
          Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * .5,
              child: Image.network(widget.product.productimage.url,
                  width: 110.0, fit: BoxFit.cover)

              // decoration: BoxDecoration(
              //     image: DecorationImage(image: AssetImage(''), fit: BoxFit.cover)),
              ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40)),
              child: Container(
                height: MediaQuery.of(context).size.height * .6,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(.2),
                          offset: Offset(0, -4),
                          blurRadius: 8)
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                        left: 24,
                        right: 20,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.product.name,
                              style: GoogleFonts.ptSans(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                          left: 30,
                          right: 30,
                        ),
                        child: Row(
                          children: [
                            Text(
                              'RM ' + widget.product.productprice.toString(),
                              style: GoogleFonts.ptSans(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            // Text(
                            //   '/1 kg',
                            //   style: GoogleFonts.ptSans(
                            //     fontSize: 20,
                            //   ),
                            // )
                          ],
                        )),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 15,
                        left: 30,
                        right: 30,
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                            color: Colors.red[200],
                            borderRadius: BorderRadius.circular(5)),
                        // child: Text(
                        //   'show category - vendor name',
                        //   style: GoogleFonts.ptSans(
                        //     color: Colors.white,
                        //     fontSize: 14,
                        //   ),
                        // ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                          left: 30,
                          right: 30,
                        ),
                        child: Row(
                          children: [
                            Text(
                              "Description",
                              style: GoogleFonts.ptSans(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            // Text(
                            //   'dsgdfhgkfdjhkgjfkh',
                            //   style: GoogleFonts.ptSans(
                            //     fontSize: 15,
                            //   ),
                            // )
                          ],
                        )),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 0,
                        left: 25,
                        right: 30,
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        child: Text(
                          widget.product.description,
                          style: GoogleFonts.ptSans(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 30),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(.07),
                                offset: Offset(0, -3),
                                blurRadius: 12)
                          ]),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // children: [Text('Total'), Text("RM 245.00")],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (Provider.of<UserProvider>(context,
                                          listen: false)
                                      .user ==
                                  null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Login(topage: "productdetail")),
                                );
                              } else {
                                addtoCart(widget.product.id);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 25),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'Add to Cart',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
