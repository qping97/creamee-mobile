import 'package:creamee/screen/productlist.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductDetail extends StatefulWidget {
  final Product product;
  const ProductDetail({Key key, this.product}) : super(key: key);
  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  @override
  Widget build(BuildContext context) {
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
                          Container(
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
