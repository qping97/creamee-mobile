import 'package:creamee/model/user.dart';
import 'package:creamee/provider/userprovider.dart';
import 'package:creamee/screen/app.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:creamee/screen/editaccount.dart';
// import 'package:creamee/model/user.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:creamee/model/imagecustom.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Account extends StatefulWidget {
  Account({Key key}) : super(key: key);
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  PickedFile _imageFile;
  User accounts;
  UserProvider userProvider;
  // bool circular = true;
  @override
  void initState() {
    super.initState();
    this.fetchData();
  }

  fetchData() async {
    // print(url);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var customer = json.decode(localStorage.getString('customer'));
    int customerId = customer['id'];
    var url = "http://192.168.0.187:8000/api/customer/profile/$customerId";
    var response = await http.get(url);
    print(response.body);
    if (response.statusCode == 200) {
      var items = json.decode(response.body)['customer'];
      // print(items);

      setState(() {
        accounts = User.fromJson(items);
        Provider.of<UserProvider>(context, listen: false).user = accounts;
        // print(accounts.name);

        // isLoading = false;
      });
    }
    // else {
    //   // setState(() {
    //   //   accounts = [];
    //   // });
    //   // isLoading = false;
    // }
  }

  // ProfileModel profileModel = ProfileModel();
  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Account"),
        backgroundColor: Colors.red[200],
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8, right: 15, bottom: 8),
            child: Container(
              width: 80,
              height: 8,
              child: RaisedButton(
                textColor: Colors.red,
                // onPressed: ()async {
                onPressed: () {
                  userProvider.userlogout();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => App()),
                  );
                },
                child: Text("Logout"),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    side: BorderSide(color: Colors.transparent)),
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: accounts == null
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: <Widget>[
                head(),
                Divider(
                  thickness: 0.8,
                ),
                otherDetails("Name", accounts.name),
                otherDetails("Email", accounts.email),
                otherDetails("Contact No", accounts.contactno),
                otherDetails("Address", accounts.address),
                Divider(
                  thickness: 0.8,
                ),
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 20,
                    ),
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => EditAccount()))
                            .then((value) => setState(() {
                                  fetchData();
                                }));
                      },
                      child: const Text('Edit', style: TextStyle(fontSize: 16)),
                      color: Colors.red[200],
                      textColor: Colors.white,
                      elevation: 5,
                    ),
                  ),
                )
              ],
            ),
    );
  }

  Widget head() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(accounts.profilepic.url)),
          ),
          // Text(
          //   "username",
          //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          // ),
          // SizedBox(
          //   height: 10,
          // ),
          // Text("titleline")
        ],
      ),
    );
  }

  Widget otherDetails(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "$label :",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            value,
            style: TextStyle(fontSize: 15),
          )
        ],
      ),
    );
  }
}
