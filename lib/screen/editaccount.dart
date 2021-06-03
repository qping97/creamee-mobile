import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:creamee/screen/account.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as paths;

class EditAccount extends StatefulWidget {
  final User myaccount;
  const EditAccount({Key key, this.myaccount}) : super(key: key);

  @override
  _EditAccountState createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  // final networkHandler = NetworkHandler();
  bool circular = false;
  PickedFile _imageFile;
  final ImagePicker _picker = ImagePicker();
  final _globalkey = GlobalKey<FormState>();
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _contactno = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _password = TextEditingController();
  User myaccounts = User();

  @override
  void initState() {
    super.initState();
    _name.text = widget.myaccount.name;
    _email.text = widget.myaccount.email;
    _contactno.text = widget.myaccount.contactno;
    _address.text = widget.myaccount.address;
  }

  saveProfile() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var customer = json.decode(localStorage.getString('customer'));
    int customerId = customer['id'];

    var imageFile = await MultipartFile.fromFile(_imageFile.path,
        filename: "${paths.basename(_imageFile.path)}");
    myaccounts.id = customerId;
    Map<String, dynamic> map = myaccounts.toJson();
    map["profile_pic"] = imageFile;
    FormData formData = new FormData.fromMap(map);
    var url = "http://192.168.0.187:8000/api/customer/profile/$customerId/edit";
    var response = await http.post(url);
    print(customerId);
    print(response.body);
    print(map);
    try {
      Dio dio = new Dio();
      dio.options.headers["Accept"] = "application/json";
      dio.options.headers["Content-Type"] = "application/json";

// TODO: BACKEND
      Response response = await dio.post(url, data: formData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Letter's draft saved!");
      } else {
        print("Letter's draft 404");
      }
    } catch (e) {
      print("Letter's draft failed");
      print(e.toString());
    }

    // if (response.statusCode == 200) {
    //   setState(() {});
    // } else {
    //   setState(() {});
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Edit Account"),
          backgroundColor: Colors.red[200],
        ),
        body: profileView());
  }

  Widget profileView() {
    return Scaffold(
      body: Form(
        key: _globalkey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          children: <Widget>[
            imageProfile(),
            SizedBox(
              height: 20,
            ),
            nameTextField(),
            SizedBox(
              height: 20,
            ),
            emailTextField(),
            SizedBox(
              height: 20,
            ),
            contactnoField(),
            SizedBox(
              height: 20,
            ),
            addressTextField(),
            SizedBox(
              height: 20,
            ),
            passwordTextField(),
            SizedBox(
              height: 20,
            ),
            InkWell(
              // onTap: () async {
              //   setState(() {
              //     circular = true;
              //   });
              //   if (_globalkey.currentState.validate()) {
              //     Map<String, String> data = {
              //       "name": _name.text,
              //       "profession": _email.text,
              //       "DOB": _contactno.text,
              //       "titleline": _address.text,
              //       "about": _password.text,
              //     };
              //     var response =
              //         await networkHandler.post("/profile/add", data);
              //     if (response.statusCode == 200 ||
              //         response.statusCode == 201) {
              //       if (_imageFile.path != null) {
              //         var imageResponse = await networkHandler.patchImage(
              //             "/profile/add/image", _imageFile.path);
              //         if (imageResponse.statusCode == 200) {
              //           setState(() {
              //             circular = false;
              //           });
              //           Navigator.of(context).pushAndRemoveUntil(
              //               MaterialPageRoute(builder: (context) => HomePage()),
              //               (route) => false);
              //         }
              //       } else {
              //         setState(() {
              //           circular = false;
              //         });
              //         Navigator.of(context).pushAndRemoveUntil(
              //             MaterialPageRoute(builder: (context) => HomePage()),
              //             (route) => false);
              //       }
              //     }
              //   }
              // },
              child: Center(
                child: InkWell(
                  onTap: () {
                    saveProfile();
                  },
                  child: Container(
                    width: 200,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.red[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: circular
                          ? CircularProgressIndicator()
                          : Text(
                              "Save",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget imageProfile() {
    return Center(
      child: Stack(children: <Widget>[
        CircleAvatar(
          radius: 50.0,
          backgroundImage: _imageFile == null
              ? AssetImage("assets/profile.png")
              : FileImage(File(_imageFile.path)),
        ),
        Positioned(
          bottom: 1.0,
          right: 1.0,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: ((builder) => bottomSheet()),
              );
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
        ),
      ]),
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

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );
    setState(() {
      _imageFile = pickedFile;
    });
  }

  Widget nameTextField() {
    return TextFormField(
      controller: _name,
      onChanged: (value) {
        myaccounts.name = value;
        widget.myaccount.name = myaccounts.name;
      },
      validator: (value) {
        if (value.isEmpty) return "Name can't be empty";

        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.red[200],
        )),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.grey,
          width: 2,
        )),
        prefixIcon: Icon(
          Icons.person,
          color: Colors.red[200],
        ),
        labelText: "Name",
        helperText: "Name can't be empty",
        // hintText: "Dev Stack",
        labelStyle: TextStyle(color: Colors.red),
      ),
    );
  }

  Widget emailTextField() {
    return TextFormField(
      controller: _email,
      onChanged: (value) {
        myaccounts.email = value;
        widget.myaccount.email = myaccounts.email;
      },
      validator: (value) {
        if (value.isEmpty) return "Email can't be empty";
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.red[200],
        )),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.grey,
          width: 2,
        )),
        prefixIcon: Icon(
          Icons.email,
          color: Colors.red[200],
        ),
        labelText: "Email",
        helperText: "Email can't be empty",
        // hintText: "example@gmail.com",
        labelStyle: TextStyle(color: Colors.red),
      ),
    );
  }

  Widget contactnoField() {
    return TextFormField(
      controller: _contactno,
      onChanged: (value) {
        myaccounts.contactno = value;
        widget.myaccount.contactno = myaccounts.contactno;
      },
      validator: (value) {
        if (value.isEmpty) return "Contact No can't be empty";

        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.red[200],
        )),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.grey,
          width: 2,
        )),
        prefixIcon: Icon(
          Icons.phone,
          color: Colors.red[200],
        ),
        labelText: "Contact No",
        helperText: "Contact No can't be empty",
        // hintText: "0238382743",
        labelStyle: TextStyle(color: Colors.red),
      ),
    );
  }

  Widget addressTextField() {
    return TextFormField(
      controller: _address,
      onChanged: (value) {
        myaccounts.address = value;
        widget.myaccount.address = myaccounts.address;
      },
      validator: (value) {
        if (value.isEmpty) return "Address can't be empty";

        return null;
      },
      maxLines: 2,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.red[200],
        )),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.grey,
          width: 2,
        )),
        prefixIcon: Icon(
          Icons.home_work_rounded,
          color: Colors.red[200],
        ),
        labelText: "Address",
        helperText: "Address can't be empty",
        hintText: "No.123 jalan abc",
        labelStyle: TextStyle(color: Colors.red),
      ),
    );
  }

  Widget passwordTextField() {
    return TextFormField(
      controller: _password,
      onChanged: (value) {
        myaccounts.password = value;
      },
      // validator: (value) {
      //   if (value.isEmpty) return "Password can't be empty";

      //   return null;
      // },
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.red[200],
        )),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.grey,
          width: 2,
        )),
        prefixIcon: Icon(
          Icons.vpn_key,
          color: Colors.red[200],
        ),
        labelText: "Password",
        helperText: "Enter new password",
        // hintText: "I am Dev Stack",
        labelStyle: TextStyle(color: Colors.red),
      ),
      obscureText: true,
    );
  }
}
