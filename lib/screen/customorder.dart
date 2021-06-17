import 'dart:convert';
import 'dart:io';
import 'package:creamee/provider/userprovider.dart';
import 'package:creamee/provider/vendorprovider.dart';
import 'package:creamee/screen/app.dart';
import 'package:creamee/screen/categorylist.dart';
import 'package:creamee/screen/home.dart';
import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as paths;

class CustomSize {
  int id;
  String title;
  double price;
  int vendorid;

  CustomSize({
    this.id,
    this.title,
    this.price,
    this.vendorid,
  });

  CustomSize.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    price = double.parse(json['price']);
    vendorid = json['vendor_id'];
  }
}

class CustomFlavor {
  int id;
  String type;
  double price;
  int vendorid;

  CustomFlavor({
    this.id,
    this.type,
    this.price,
    this.vendorid,
  });

  CustomFlavor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    price = double.parse(json['price']);
    vendorid = json['vendor_id'];
  }
}

class CustomShape {
  String name;
  String image;

  CustomShape({
    this.name,
    this.image,
  });
}

class CustomCakeOrder {
  int id;
  String shape;
  String description;
  String customizetext;
  String image;
  int flavorid;
  int sizeid;
  int vendorid;
  int customerid;

  CustomCakeOrder({
    this.id,
    this.shape,
    this.description,
    this.customizetext,
    this.image,
    this.flavorid,
    this.sizeid,
    this.vendorid,
    this.customerid,
  });
  Map<String, dynamic> toJson() => {
        // 'id': id,
        'shape': shape,
        'description': description,
        'customize_text': customizetext,
        'image': image,
        'flavor_id': flavorid,
        'size_id': sizeid,
        'vendor_id': vendorid,
        'customer_id': customerid,
      };
}

class CustomOrder extends StatefulWidget {
  @override
  _CustomOrderState createState() => _CustomOrderState();
}

class _CustomOrderState extends State<CustomOrder> {
  VendorProvider vendorProvider;
  UserProvider userProvider;
  List<CustomSize> customsizes = [];
  List<CustomFlavor> customflavors = [];
  PickedFile _imageFile;
  final ImagePicker _picker = ImagePicker();
  List<CustomShape> customshapes = [];
  CustomCakeOrder customCakeOrder = CustomCakeOrder();
  TextEditingController _description = TextEditingController();
  TextEditingController _customizedtext = TextEditingController();
  bool isloaded = false;

  @override
  void initState() {
    super.initState();
    customshapes.add(CustomShape(name: "Round", image: "assets/round.jpg"));
    customshapes
        .add(CustomShape(name: "Rectangle", image: "assets/rectangle.jpg"));
    customshapes.add(CustomShape(name: "Square", image: "assets/square.jpg"));
    customshapes.add(CustomShape(name: "Heart", image: "assets/heart.jpg"));
    customshapes.add(CustomShape(name: "Custom", image: "assets/custom.jpg"));
  }

  submitorder() async {
    var imageFile = await MultipartFile.fromFile(_imageFile.path,
        filename: "${paths.basename(_imageFile.path)}");
    customCakeOrder.vendorid = vendorProvider.vendor.id;
    customCakeOrder.customerid = userProvider.user.id;
    Map<String, dynamic> map = customCakeOrder.toJson();
    map['image'] = [imageFile];
    FormData formData = new FormData.fromMap(map);
    print(formData);
    print(map);

    var url = "http://192.168.0.187:8000/api/save-customorder";
    try {
      Dio dio = new Dio();
      // dio.options.headers["Accept"] = "application/json";
      // dio.options.headers["Content-Type"] = "application/json";

      Response response = await dio.post(url, data: formData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("custom order created!");
        showAlertDialog(context);
        print(response.data);
      } else {
        print("custom order 404");
      }
    } catch (e) {
      print("failed");
      print(e.toString());
    }
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => App()),
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Success", style: TextStyle(color: Colors.green)),
      content: Text("Custom Order Submitted!"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  fetchCustom() async {
    var id = vendorProvider.vendor.id;
    var url = "http://192.168.0.187:8000/api/getcustom/$id";
    // print(url);
    if (!isloaded) {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> tempcustomsizes = json.decode(response.body)['getsize'];
        List<dynamic> tempcustomflavors =
            json.decode(response.body)['getflavor'];
        // setState(() {
        customsizes =
            tempcustomsizes.map((e) => CustomSize.fromJson(e)).toList();

        customflavors =
            tempcustomflavors.map((a) => CustomFlavor.fromJson(a)).toList();
        // });
        isloaded = true;
        return true;
      } else {
        // setState(() {
        // customsizes = [];
        // customflavors = [];
        // });
        return false;
      }
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    vendorProvider = Provider.of<VendorProvider>(context);
    userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Custom Order"),
        backgroundColor: Colors.red[200],
      ),
      body: FutureBuilder(
        future: this.fetchCustom(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done || isloaded) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Select Cake Sizes *',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        RadioButtonList(
                          type: customsizes.runtimeType,
                          list: customsizes,
                          customCakeOrder: customCakeOrder,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Select Cake Flavor *',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        RadioButtonList(
                          type: customflavors.runtimeType,
                          list: customflavors,
                          customCakeOrder: customCakeOrder,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Cake Shape *',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        // GridView.builder(
                        //   scrollDirection: Axis.vertical,
                        //   gridDelegate:
                        //       SliverGridDelegateWithFixedCrossAxisCount(
                        //     crossAxisCount: 3,
                        //   ),
                        Container(
                          // width: (MediaQuery.of(context).size.width) * 0.3,
                          height: 70,
                          child: ListView.builder(
                            itemCount: customshapes.length,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return RaisedButton(
                                // color: _hasBeenPressed
                                //     ? Colors.grey[50]
                                //     : Colors.pink[100],
                                elevation: 10,
                                onPressed: () {
                                  // setState(() {
                                  //   _hasBeenPressed = !_hasBeenPressed;
                                  // });
                                  customCakeOrder.shape =
                                      customshapes[index].name;
                                  print(customshapes[index].name);
                                },
                                child: Container(
                                    // decoration: BoxDecoration(
                                    //   border: Border.all(),
                                    // ),
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      customshapes[index].image,
                                      width:
                                          (MediaQuery.of(context).size.width) *
                                              0.25,
                                      height: 50,
                                    ),
                                    Text(customshapes[index].name,
                                        style: TextStyle(color: Colors.grey))
                                  ],
                                )),
                              );
                            },
                          ),
                        ),
                        // Row(
                        //   children: <Widget>[
                        //     SizedBox(width: 10),
                        //     Container(
                        //         width:
                        //             (MediaQuery.of(context).size.width) * 0.3,
                        //         height: 120,
                        //         decoration: BoxDecoration(
                        //           border: Border.all(),
                        //         ),
                        //         child: Column(
                        //           mainAxisAlignment: MainAxisAlignment.center,
                        //           children: [
                        //             Image.asset(
                        //               "assets/rectangle.jpg",
                        //               width:
                        //                   (MediaQuery.of(context).size.width) *
                        //                       0.3,
                        //               height: 100,
                        //             ),
                        //             Text("Rectangle",
                        //                 style: TextStyle(color: Colors.grey))
                        //           ],
                        //         )),
                        //     SizedBox(width: 10),
                        //     Container(
                        //         width:
                        //             (MediaQuery.of(context).size.width) * 0.3,
                        //         height: 120,
                        //         decoration: BoxDecoration(
                        //           border: Border.all(),
                        //         ),
                        //         child: Column(
                        //           mainAxisAlignment: MainAxisAlignment.center,
                        //           children: [
                        //             Image.asset(
                        //               "assets/square.jpg",
                        //               width:
                        //                   (MediaQuery.of(context).size.width) *
                        //                       0.3,
                        //               height: 100,
                        //             ),
                        //             Text("Square",
                        //                 style: TextStyle(color: Colors.grey))
                        //           ],
                        //         )),
                        //   ],
                        //   // ),
                        // ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Cake Image *',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          'for reference ',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w300),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 5,
                            ),
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(0)),
                              child: _imageFile == null
                                  ? Image.asset(
                                      "assets/noimage.png",
                                      width: 180,
                                      height: 100,
                                    )
                                  : Image.file(
                                      File(_imageFile.path),
                                      width: 180,
                                      height: 100,
                                    ),
                            ),
                            InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: ((builder) => bottomSheet()),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(10.0),
                                child: Text(
                                  'Upload Image',
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(0)),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Colors.grey[350].withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: Offset(0, 3),
                                      )
                                    ]),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Cake Description *',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        TextFormField(
                          controller: _description,
                          onChanged: (value) {
                            customCakeOrder.description = value;
                          },
                          maxLines: 3,
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
                              Icons.edit,
                              color: Colors.grey,
                            ),
                            labelText:
                                "Describe your cake here...\n e.g How many candles you need?",
                            helperText: "",
                            hintText: "",
                            labelStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Customize Text *',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        TextFormField(
                          controller: _customizedtext,
                          onChanged: (value) {
                            customCakeOrder.customizetext = value;
                          },
                          maxLines: 1,
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
                              Icons.edit,
                              color: Colors.grey,
                            ),
                            labelText: "Wording on cake",
                            helperText: "",
                            hintText: "",
                            labelStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                        // ClipRRect(
                        //   borderRadius: BorderRadius.only(
                        //       topRight: Radius.circular(20),
                        //       bottomRight: Radius.circular(20),
                        //       bottomLeft: Radius.circular(20)),
                        //   child: Align(
                        //     alignment: Alignment(-0.5, -0.2),
                        //     child: _imageFile == null
                        //         ? Image.asset("assets/noimage.png")
                        //         : Image.file(File(_imageFile.path)),
                        //   ),
                        // ),

                        Text(
                          "Reminder: All field are required.",
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Center(
                          child: InkWell(
                            onTap: () {
                              submitorder();
                            },
                            child: Container(
                              width: 200,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.red[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  "Submit",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),

                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: Align(
                        //       alignment: Alignment.bottomRight,
                        //       child: RaisedButton(
                        //         color: Colors.red,
                        //         onPressed: () {
                        //           submitorder();
                        //         },
                        //         child: const Text('Add To Cart',
                        //             style: TextStyle(
                        //               color: Colors.white,
                        //             )),
                        //         elevation: 5,
                        //       )),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        },
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
}

class RadioButtonList extends StatefulWidget {
  final Type type;
  final List list;
  final CustomCakeOrder customCakeOrder;

  const RadioButtonList({Key key, this.type, this.list, this.customCakeOrder})
      : super(key: key);

  @override
  _RadioButtonListState createState() => _RadioButtonListState();
}

class _RadioButtonListState extends State<RadioButtonList> {
  CustomSize selectedSize;
  CustomFlavor selectedFlavor;

  @override
  void initState() {
    super.initState();
    if (widget.list is List<CustomSize>) {
      selectedSize = widget.list[0];
      widget.customCakeOrder.sizeid = selectedSize.id;
    } else if (widget.list is List<CustomFlavor>) {
      selectedFlavor = widget.list[0];
      widget.customCakeOrder.flavorid = selectedFlavor.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.list.length,
      itemBuilder: (BuildContext context, int index) {
        if (widget.list is List<CustomSize>) {
          return ListTile(
            title: Text(widget.list[index]?.title ?? ""),
            leading: Radio<CustomSize>(
              value: widget.list[index] ?? "",
              groupValue: selectedSize,
              onChanged: (CustomSize temp) {
                setState(() {
                  selectedSize = temp;
                  widget.customCakeOrder.sizeid = selectedSize.id;
                });
              },
            ),
            trailing: Text("RM " + widget.list[index].price.toStringAsFixed(2),
                style: TextStyle(fontSize: 15)),
          );
        } else if (widget.list is List<CustomFlavor>) {
          return ListTile(
            title: Text(widget.list[index]?.type ?? ""),
            leading: Radio<CustomFlavor>(
              value: widget.list[index] ?? "",
              groupValue: selectedFlavor,
              onChanged: (CustomFlavor temp) {
                setState(() {
                  selectedFlavor = temp;
                  widget.customCakeOrder.flavorid = selectedFlavor.id;
                });
              },
            ),
            trailing: Text("RM " + widget.list[index].price.toStringAsFixed(2),
                style: TextStyle(fontSize: 15)),
          );
        } else {
          return Container();
        }
        // return ListTile(
        //   title: Text(widget.list[index]?.title ?? ""),
        //   leading: Radio<Type>(
        //     value: widget.list[index] ?? "",
        //     groupValue: selectedSize,
        //     onChanged: (CustomSize temp) {
        //       setState(() {
        //         selectedSize = temp;
        //       });
        //     },
        //   ),
        // );
      },
    );
  }
}
