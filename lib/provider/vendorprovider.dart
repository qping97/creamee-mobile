import 'dart:convert';
import 'package:creamee/model/vendor.dart';
import 'package:creamee/network_utils/api.dart';
import 'package:flutter/material.dart';
import 'package:creamee/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VendorProvider extends ChangeNotifier {
  Vendor vendor;

  void vendorSelected(Vendor vendor) {
    this.vendor = vendor;
  }

  void vendorRemove() {
    this.vendor = null;
  }
}
