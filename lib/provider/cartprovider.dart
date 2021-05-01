import 'package:creamee/provider/userprovider.dart';
import 'package:flutter/material.dart';
import 'package:creamee/screen/cart.dart';
// import 'package:creamee/screen/cart.dart';
import 'package:creamee/model/user.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CartProvider extends ChangeNotifier {
  final UserProvider userProvider;
  CartProvider(this.userProvider) {}
  Future addtocart() async {
    // Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    User user = userProvider.user;
    // SharedPreferences prefs = await _prefs;
    // var customer = json.decode(prefs.getString('customer'));
    print(user.id);
    var url = "http://192.168.0.187:8000/api/addtocart/${user.id}";
    // var res = await Network().authData(data, '/addtocart');
    var response = await http.get(url);
    // final Map parsed = json.decode(response.body);
    notifyListeners();
  }
}
