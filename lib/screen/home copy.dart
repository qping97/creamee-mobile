import 'dart:convert';
import 'package:flutter/material.dart';
// import 'package:tutorial_app/screen/login.dart';
// import 'package:tutorial_app/network_utils/api.dart';
import 'package:creamee/screen/login.dart';
import 'package:creamee/network_utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // String name;
  @override
  void initState() {
    // _loadUserData();
    super.initState();
  }

  // _loadUserData() async {
  //   SharedPreferences localStorage = await SharedPreferences.getInstance();
  //   var user = jsonDecode(localStorage.getString('user'));

  //   if (user != null) {
  //     setState(() {
  //       name = user['name'];
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Creamee'),
        backgroundColor: Colors.red[200],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              // 'Hi, $name',
              'Hi',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Center(
                // child: RaisedButton(
                //   elevation: 10,
                //   onPressed: () {
                //     logout();
                //   },
                //   color: Colors.teal,
                //   shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.all(Radius.circular(10))),
                //   child: Text('Logout'),
                // ),
                ),
          ],
        ),
      ),
    );
  }

  void logout() async {
    var res = await Network().getData('/logout/customer');
    var body = json.decode(res.body);
    if (body['success']) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.remove('user');
      localStorage.remove('token');
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    }
  }
}
