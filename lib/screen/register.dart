import 'dart:convert';
import 'dart:io';
import 'package:creamee/model/user.dart';
import 'package:creamee/provider/userprovider.dart';
import 'package:creamee/screen/account.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:tutorial_app/network_utils/api.dart';
// import 'package:tutorial_app/screen/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tutorial_app/screen/login.dart';
import 'package:creamee/screen/home.dart';
import 'package:creamee/screen/login.dart';
import 'package:creamee/network_utils/api.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as paths;
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _isLoading = false;
  PickedFile _imageFile;
  final ImagePicker _picker = ImagePicker();
  User myaccounts = User();
  UserProvider userProvider;
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _contactno = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _password = TextEditingController();

  // final _formKey = GlobalKey<FormState>();

  register() async {
    // setState(() {
    //   _isLoading = true;
    // });

    var imageFile = await MultipartFile.fromFile(_imageFile.path,
        filename: "${paths.basename(_imageFile.path)}");
    myaccounts.latitude = userProvider.currentposition.latitude;
    myaccounts.longitude = userProvider.currentposition.longitude;
    Map<String, dynamic> map = myaccounts.toJson();
    map['profile_pic'] = [imageFile];
    FormData formData = new FormData.fromMap(map);
    print(formData);
    print(map);

    var url = "http://192.168.0.187:8000/api/register/customer";
    try {
      Dio dio = new Dio();
      Response response = await dio.post(url, data: formData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("register success!");
        print(response.data);
      } else {
        print("register 404");
      }
    } catch (e) {
      print("failed");
      print(e.toString());
    }
  }
  // var res = await Network().authData(data, '/api/register/customer');
  // var body = json.decode(res.body);
  // print(res.body);
  // if (body['success']) {
  //   SharedPreferences localStorage = await SharedPreferences.getInstance();
  //   localStorage.setString('token', json.encode(body['token']));
  //   localStorage.setString('user', json.encode(body));
  //   // localStorage.setString('user', json.encode(body['user']));

  //   Navigator.push(
  //     context,
  //     new MaterialPageRoute(builder: (context) => Login()),
  //   );
  // } else {
  //   print('false');
  // }

  //   setState(() {
  //     _isLoading = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);
    return Material(
      child: Container(
        color: Colors.red[200],
        child: Stack(
          children: <Widget>[
            Positioned(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Card(
                      elevation: 4.0,
                      color: Colors.white,
                      margin: EdgeInsets.only(left: 20, right: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Form(
                          // key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              imageProfile(),
                              TextFormField(
                                controller: _name,
                                onChanged: (value) {
                                  myaccounts.name = value;
                                },
                                style: TextStyle(color: Color(0xFF000000)),
                                cursorColor: Color(0xFF9b9b9b),
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.insert_emoticon,
                                    color: Colors.grey,
                                  ),
                                  hintText: "Name",
                                  hintStyle: TextStyle(
                                      color: Color(0xFF9b9b9b),
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal),
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  myaccounts.name = value;
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _email,
                                onChanged: (value) {
                                  myaccounts.email = value;
                                },
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
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter email';
                                  }
                                  myaccounts.email = value;
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _address,
                                onChanged: (value) {
                                  myaccounts.address = value;
                                },
                                style: TextStyle(color: Color(0xFF000000)),
                                cursorColor: Color(0xFF9b9b9b),
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.insert_emoticon,
                                    color: Colors.grey,
                                  ),
                                  hintText: "Address",
                                  hintStyle: TextStyle(
                                      color: Color(0xFF9b9b9b),
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal),
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter your address';
                                  }
                                  myaccounts.address = value;
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _contactno,
                                onChanged: (value) {
                                  myaccounts.contactno = value;
                                },
                                style: TextStyle(color: Color(0xFF000000)),
                                cursorColor: Color(0xFF9b9b9b),
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.phone,
                                    color: Colors.grey,
                                  ),
                                  hintText: "Contact No",
                                  hintStyle: TextStyle(
                                      color: Color(0xFF9b9b9b),
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal),
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter contact number';
                                  }
                                  myaccounts.contactno = value;
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _password,
                                onChanged: (value) {
                                  myaccounts.password = value;
                                },
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
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter password';
                                  }
                                  myaccounts.password = value;
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
                                      _isLoading
                                          ? 'Proccessing...'
                                          : 'Register',
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
                                    register();
                                    // if (_formKey.currentState.validate()) {
                                    //   _register();
                                    // }
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
                                  builder: (context) => Login(
                                        topage: "home",
                                      )));
                        },
                        child: Text(
                          'Already Have an Account',
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

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Choose Profile photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.camera),
              onPressed: () {
                takePhoto(ImageSource.camera);
              },
              label: Text("Camera"),
            ),
            FlatButton.icon(
              icon: Icon(Icons.image),
              onPressed: () {
                takePhoto(ImageSource.gallery);
              },
              label: Text("Gallery"),
            ),
          ])
        ],
      ),
    );
  }

  Widget imageProfile() {
    return Stack(
      children: <Widget>[
        CircleAvatar(
          radius: 60.0,
          backgroundImage: _imageFile == null
              ? AssetImage("assets/profile.png")
              : FileImage(File(_imageFile.path)),
        ),
        Positioned(
          bottom: 1,
          right: 1,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                  context: context, builder: ((builder) => bottomSheet()));
            },
            child: Container(
              height: 40,
              width: 40,
              child: Icon(
                Icons.add_a_photo,
                color: Colors.white,
                size: 28.0,
              ),
              decoration: BoxDecoration(
                  color: Colors.red[200],
                  borderRadius: BorderRadius.all(Radius.circular(20))),
            ),
          ),
        )
      ],
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );
    setState(() {
      _imageFile = pickedFile;
    });
  }
}
