import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:creamee/utils/custom_stepper.dart';
import 'package:creamee/screen/cart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CartProduct extends StatefulWidget {
  final CartItem cartitem;
  final void Function(int) onRemove;
  final void Function(int, int) onValueChanged;
  const CartProduct(
      {Key key, this.cartitem, this.onRemove, this.onValueChanged})
      : super(key: key);

  @override
  _CartProductState createState() => _CartProductState();
}

class _CartProductState extends State<CartProduct> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: makeListTitle(context),
      ),
    );
  }

  ListTile makeListTitle(BuildContext context) => ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        leading: Container(
          width: 50,
          height: 150,
          alignment: Alignment.center,
          child: Image.network(
            widget.cartitem.product.productimage.url,
            height: 150,
          ),
        ),
        title: Padding(
          padding: EdgeInsets.all(5),
          child: Text(
            widget.cartitem.product.name,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        subtitle: Padding(
          padding: EdgeInsets.all(5),
          child: Wrap(
            direction: Axis.vertical,
            children: [
              Text(
                "RM " + widget.cartitem.product.productprice.toStringAsFixed(2),
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              FlatButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 20,
                    ),
                    Text(
                      "Remove",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  // print("remove ");
                  widget.onRemove(widget.cartitem.product.id);
                  // removeItem(widget.cartitem.product.id);
                },
                padding: EdgeInsets.all(8),
                color: Colors.redAccent,
                shape: StadiumBorder(),
              ),
            ],
          ),
        ),
        trailing: Container(
          width: 120,
          child: CustomStepper(
            lowerLimit: 1,
            upperLimit: 20,
            stepValue: 1,
            iconSize: 22.0,
            value: widget.cartitem.quantity,
            onChanged: (value) {
              widget.onValueChanged(widget.cartitem.product.id, value);
              widget.cartitem.quantity = value;
            },
          ),
        ),
      );
}
