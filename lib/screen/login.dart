import 'dart:convert';
import 'package:creamee/screen/account.dart';
import 'package:creamee/screen/app.dart';
import 'package:creamee/screen/cart.dart';
import 'package:creamee/screen/order-list.dart';
import 'package:creamee/screen/productdetail.dart';
import 'package:creamee/screen/productlist.dart';
import 'package:flutter/material.dart';
import 'package:creamee/screen/home.dart';
import 'package:creamee/screen/register.dart';
import 'package:creamee/network_utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:creamee/provider/userprovider.dart';
import 'package:creamee/model/user.dart';
import 'package:provider/provider.dart';
import 'package:creamee/screen/customorder.dart';

class Login extends StatefulWidget {
  final String topage;
  Login({this.topage});
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  var email;
  var password;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  _showMsg(msg) {
    // final snackBar = SnackBar(
    //   content: Text(msg),
    //   action: SnackBarAction(
    //     label: 'Close',
    //     onPressed: () {
    //       // Some code to undo the change!
    //     },
    //   ),
    // );
    // _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        color: Colors.red[200],
        child: Stack(
          children: <Widget>[
            Positioned(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: CircleAvatar(
                        radius: 50,
                        child: Image.asset('assets/logo.png'),
                      ),
                    ),
                    Text("__ping"),
                    SizedBox(
                      height: 30,
                    ),
                    Card(
                      elevation: 4.0,
                      color: Colors.white,
                      margin: EdgeInsets.only(left: 20, right: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              TextFormField(
                                style: TextStyle(color: Color(0xFF000000)),
                                cursorColor: Color(0xFF9b9b9b),
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: Colors.grey,
                                  ),
                                  hintText: "Email",
                                  hintStyle: TextStyle(
                                      color: Color(0xFF9b9b9b),
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal),
                                ),
                                validator: (emailValue) {
                                  if (emailValue.isEmpty) {
                                    return 'Please enter email';
                                  }
                                  email = emailValue;
                                  return null;
                                },
                              ),
                              TextFormField(
                                style: TextStyle(color: Color(0xFF000000)),
                                cursorColor: Color(0xFF9b9b9b),
                                keyboardType: TextInputType.text,
                                obscureText: true,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.vpn_key,
                                    color: Colors.grey,
                                  ),
                                  hintText: "Password",
                                  hintStyle: TextStyle(
                                      color: Color(0xFF9b9b9b),
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal),
                                ),
                                validator: (passwordValue) {
                                  if (passwordValue.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  password = passwordValue;
                                  return null;
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: FlatButton(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 8, bottom: 8, left: 10, right: 10),
                                    child: Text(
                                      _isLoading ? 'Proccessing...' : 'Login',
                                      textDirection: TextDirection.ltr,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.0,
                                        decoration: TextDecoration.none,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  color: Colors.red[200],
                                  disabledColor: Colors.grey,
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(20.0)),
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      _login();
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => Register()));
                        },
                        child: Text(
                          'Create new Account',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _login() async {
    setState(() {
      _isLoading = true;
    });
    var data = {'email': email, 'password': password};

    var res = await Network().authData(data, '/api/login/customer');
    print(res.body);
    var body = json.decode(res.body);

    if (body['success']) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', json.encode(body['token']));
      localStorage.setString('customer', json.encode(body['customer']));
      localStorage.setString('id', json.encode(body['id']));

      var val = localStorage.getString('customer');
      print(
          '----------------------------------------------------------------------');
      print(val);

      User user = User.fromJson(body['customer']);
      Provider.of<UserProvider>(context, listen: false).loguserin(user);
      if (widget.topage == "home") {
        Navigator.push(
          context,
          new MaterialPageRoute(builder: (context) => App()),
        );
      } else if (widget.topage == "cart") {
        Navigator.pop(context);
        Navigator.push(
          context,
          new MaterialPageRoute(builder: (context) => Cart()),
        );
      } else if (widget.topage == "customorder") {
        Navigator.pop(context);
        Navigator.push(
          context,
          new MaterialPageRoute(builder: (context) => CustomOrder()),
        );
      } else if (widget.topage == "order-list") {
        Navigator.pop(context);
        Navigator.push(
          context,
          new MaterialPageRoute(builder: (context) => OrderList()),
        );
      } else if (widget.topage == "account") {
        Navigator.pop(context);
        Navigator.push(
          context,
          new MaterialPageRoute(builder: (context) => Account()),
        );
      } else if (widget.topage == "productlist") {
        Navigator.pop(context);
        // Navigator.push(
        //   context,
        //   new MaterialPageRoute(builder: (context) => ProductList()),
        // );
      } else if (widget.topage == "productdetail") {
        Navigator.pop(context);
      }
    } else {
      _showMsg(body['message']);
    }

    setState(() {
      _isLoading = false;
    });
  }
}
