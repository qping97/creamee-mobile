import 'dart:convert';
import 'dart:io';
import 'package:creamee/provider/userprovider.dart';
import 'package:creamee/provider/vendorprovider.dart';
import 'package:creamee/screen/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:creamee/model/order.dart';

class Checkout extends StatefulWidget {
  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  TextEditingController _homeAddressController = TextEditingController();
  TextEditingController _ordernoteController = TextEditingController();
  DateTime pickedDate;
  // DateTime pickedTime;
  TimeOfDay time;
  List<TextEditingController> _controllers = [];
  Map _selected;
  VendorProvider vendorProvider;
  UserProvider userProvider;
  Order order;
  List<Map> _myJson = [
    {
      'id': '1',
      'image': 'assets/cash.jpg',
      'name': 'Cash',
    },
    {
      'id': '2',
      'image': 'assets/onlinebank.jpg',
      'name': 'Online Banking',
    },
    {
      'id': '3',
      'image': 'assets/debitcreditcard.jpg',
      'name': 'Debit/Credit Card',
    },
    {
      'id': '4',
      'image': 'assets/sarawakpay.jpg',
      'name': 'Sarawak Pay [Ewallet]',
    },
  ];

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    vendorProvider = Provider.of<VendorProvider>(context, listen: false);
    this.fetchCartItem();
    // });

    _tabController = TabController(length: 2, vsync: this)
      ..addListener(() {
        if (_tabController.index == 0) {
          order.shippingaddress = _homeAddressController.text;
          order.deliverymethod = "Home Delivery";
        } else if (_tabController.index == 1) {
          order.shippingaddress = vendorProvider.vendor.address;
          order.deliverymethod = "Self Pickup";
        }
      });

    // pickedDate = new DateTime.now();
    pickedDate = new DateTime.now();
    time = TimeOfDay.now();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  fetchCartItem() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var customer = json.decode(localStorage.getString('customer'));
    int customerId = customer['id'];
    print(customerId);

    var url = "http://192.168.0.187:8000/api/checkout";
    var response = await http.post(url, body: {
      "customer_id": '$customerId',
    });
    if (response.statusCode == 200) {
      order = Order.fromJson(json.decode(response.body)['payload']);
      await Provider.of<VendorProvider>(context, listen: false)
          .fetchVendor(order.cart[0].product.vendorid);
      setState(() {
        order.deliverymethod = "Home Delivery";
        order.pickupdate = DateTime.now();
      });
    } else {
      setState(() {});
      // isLoading = false;
    }
  }

  placeorder() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var customer = json.decode(localStorage.getString('customer'));
    order.customerid = customer['id'];
    order.vendorid = vendorProvider.vendor.id;
    print(order.toJson());
    var url = "http://192.168.0.187:8000/api/placeorder";
    var response =
        await http.post(url, body: json.encode(order.toJson()), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    });
    // print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        showAlertDialog(context);
        print(response.body);
      });
    } else {
      setState(() {});
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
      content: Text("Order Submitted!"),
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

  @override
  Widget build(BuildContext context) {
    vendorProvider = Provider.of<VendorProvider>(context);
    userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Checkout"),
        backgroundColor: Colors.red[200],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Text(
                "Deliver To:",
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                color: Colors.grey[300],
                child: TabBar(
                  controller: _tabController,
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(width: 3.0, color: Colors.redAccent),
                  ),
                  indicatorColor: Colors.black,
                  unselectedLabelColor: Colors.black87,
                  labelColor: Colors.redAccent,
                  indicatorWeight: 6.0,
                  tabs: [
                    Tab(text: 'Home Delivery'),
                    Tab(text: 'Self Pickup'),
                  ],
                ),
              ),
              Container(
                height: 100,
                child: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.home),
                        title: new TextField(
                          controller: _homeAddressController,
                          onChanged: (value) {
                            order.shippingaddress = value;
                          },
                          maxLines: 2,
                          decoration:
                              const InputDecoration(hintText: 'Address...'),
                        ),
                      ),
                    ),
                    Card(
                        child: new ListTile(
                      title: Text(vendorProvider?.vendor?.vname ?? ""),
                      subtitle: Text(vendorProvider?.vendor?.address ?? ""),
                    ))
                  ],
                ),
              ),
              new Card(
                child: new ListTile(
                  isThreeLine: true,
                  title: const Text('Personal information'),
                  subtitle: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text('Name:        ' + userProvider?.user?.name ?? ""),
                        Text('Contact No: ' + userProvider?.user?.contactno ??
                            ""),
                      ],
                    ),
                  ),
                ),
              ),
              ListTile(
                title: Text(
                    "Date: ${pickedDate.year}, ${pickedDate.month}，${pickedDate.day}"),
                trailing: Icon(Icons.keyboard_arrow_down),
                onTap: _pickedDate,
              ),
              // ListTile(
              //   title: Text("Time: ${time.hour}:${time.minute}"),
              //   trailing: Icon(Icons.keyboard_arrow_down),
              //   onTap: _pickedTime,
              // ),
              Card(
                child: ListTile(
                    title: Text(
                      'Order Note:',
                    ),
                    subtitle: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 4),
                            Container(
                              color: Colors.grey[100],
                              child: SizedBox(
                                child: TextField(
                                  focusNode: FocusNode(canRequestFocus: false),
                                  onChanged: (value) {
                                    order.ordernotes = value;
                                  },
                                  controller: _ordernoteController,
                                  maxLines: 3,
                                  textAlign: TextAlign.start,
                                  decoration: new InputDecoration.collapsed(
                                    hintText: 'Write here...',
                                    hintStyle: TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.grey[600]),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 4),
                          ],
                        ))),
              ),
              SizedBox(height: 4),
              Card(
                child: Column(
                  children: <Widget>[
                    Card(
                      elevation: 4,
                      margin: const EdgeInsets.only(bottom: 5),
                      child: Container(
                        padding: EdgeInsets.only(top: 10, bottom: 20.0),
                        width: (MediaQuery.of(context).size.width),
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          border: Border(
                              bottom: BorderSide(color: Colors.grey, width: 3)),
                        ),
                        child: Center(
                          child: Text(
                            "Your Order",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                      color: Colors.black.withOpacity(0.3),
                                      offset: Offset(8, 8),
                                      blurRadius: 15),
                                ]),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              order != null
                  ? ListView.builder(
                      shrinkWrap: true,
                      // separatorBuilder: (context, index) =>
                      //     Divider(
                      //       color: Colors.black,
                      //     ),
                      itemCount: order.cart.length,
                      itemBuilder: (context, index) {
                        _controllers.add(new TextEditingController());
                        return Card(
                          // elevation: 2,
                          margin: new EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6.0),
                          child: Container(
                            decoration: BoxDecoration(color: Colors.white),
                            child: makeListTitle(context, index),
                          ),
                        );
                      })
                  : Container(),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    new Text("Subtotal"),
                    new Text(order != null
                        ? "RM" + order.subtotal.toStringAsFixed(2)
                        : '')
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    new Text("Delivery Fees"),
                    new Text(order != null
                        ? "RM" + order.deliveryfee.toStringAsFixed(2)
                        : '')
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    new Text(
                      "Total",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    new Text(
                      order != null
                          ? "RM" + order.amount.toStringAsFixed(2)
                          : '',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Text("Payment Option: *"),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton<Map>(
                            hint: Text("Payment Options"),
                            value: _selected,
                            onChanged: (Map newValue) {
                              setState(() {
                                _selected = newValue;
                                order.payment = _selected['name'];
                              });
                            },
                            items: _myJson.map((bankItem) {
                              return DropdownMenuItem<Map>(
                                  value: bankItem,
                                  child: Row(
                                    children: [
                                      Image.asset(bankItem['image'], width: 25),
                                      Container(
                                        margin: EdgeInsets.only(left: 10),
                                        child: Text(bankItem['name']),
                                      )
                                    ],
                                  ));
                            }).toList(),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Center(
                child: InkWell(
                  onTap: () {
                    placeorder();
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
                        "Place Order",
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
            ],
          ),
        ),
      ),
    );
  }

  ListTile makeListTitle(BuildContext context, int index) => ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        trailing: Column(children: <Widget>[
          Text(order != null
              ? 'RM ' +
                  order.cart[index].product.productprice.toStringAsFixed(2)
              : ''),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 2, 0),
            child: Text("\nx" + order.cart[index].quantity.toString()),
          )
        ]),
        leading: Container(
          width: 50,
          height: 150,
          alignment: Alignment.center,
          child: Image.network(
            order != null ? order.cart[index].product.productimage.url : '',
            height: 150,
          ),
        ),
        title: Padding(
          padding: EdgeInsets.all(5),
          child: Text(
            order != null ? order.cart[index].product.name : '',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        subtitle: Padding(
          padding: EdgeInsets.fromLTRB(4, 0, 0, 0),
          child: Wrap(
            direction: Axis.vertical,
            children: [
              Text(
                vendorProvider?.vendor?.vname ?? "",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                ),
              ),
              SizedBox(height: 4),
              // Text(
              //   "RM ",
              //   style: TextStyle(
              //     color: Colors.black,
              //   ),
              // ),

              // Align(alignment: Alignment.bottomRight, child: Text("total"))
            ],
          ),
        ),
      );

  _pickedDate() async {
    DateTime date = await showDatePicker(
      context: context,
      // firstDate: DateTime.now().add(Duration(days: 2)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2022),
      initialDate: pickedDate,
    );

    if (date != null)
      setState(() {
        pickedDate = date;
        order.pickupdate = pickedDate;
      });
  }

  // _pickedTime() async {
  //   TimeOfDay t = await showTimePicker(
  //     context: context,
  //     initialTime: time,
  //   );

  //   if (t != null)
  //     setState(() {
  //       time = t;
  //     });
  // }
}
