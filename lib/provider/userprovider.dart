import 'dart:convert';
import 'package:creamee/network_utils/api.dart';
import 'package:flutter/material.dart';
import 'package:creamee/model/user.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  User user;
  Position currentposition;

  loguserin(User user) {
    this.user = user;
    notifyListeners();
  }

  bool userloggedin() {
    return user == null ? false : true;
  }

  userlogout() {
    user = null;
    notifyListeners();
  }
  // Future<bool> login(String email, String password) async {
  //   // setState(() {
  //   //   _isLoading = true;
  //   // });
  //   var data = {'email': email, 'password': password};

  //   var res = await Network().authData(data, '/api/login/customer');
  //   print(res.body);
  //   var body = json.decode(res.body);
  //   if (body['success']) {
  //     SharedPreferences localStorage = await SharedPreferences.getInstance();
  //     localStorage.setString('token', json.encode(body['token']));
  //     localStorage.setString('customer', json.encode(body['customer']));

  //     User user = User.fromJson(body['customer']);
  //     userloggedin(user);
  //     return true;
  //   } else {
  //     return false;
  //   }

  //   // setState(() {
  //   //   _isLoading = false;
  //   // });
  // }
}
