import 'dart:convert';
import 'package:creamee/model/vendor.dart';
import 'package:creamee/network_utils/api.dart';
import 'package:flutter/material.dart';
import 'package:creamee/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class VendorProvider extends ChangeNotifier {
  Vendor vendor;

  void vendorSelected(Vendor vendor) {
    this.vendor = vendor;
  }

  void vendorRemove() {
    this.vendor = null;
  }

  Future<Vendor> fetchVendor(int id) async {
    var url = "http://192.168.0.187:8000/api/getVendor/$id";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      vendor = Vendor.fromJson(json.decode(response.body)['vendor']);
      return vendor;
    } else {
      return null;
      // isLoading = false;
    }
  }
}
