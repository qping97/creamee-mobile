import 'package:flutter/material.dart';
import 'package:creamee/model/user.dart';

class UserProvider extends ChangeNotifier {
  User user;

  userloggedin(User user) {
    this.user = user;
    notifyListeners();
  }
}
