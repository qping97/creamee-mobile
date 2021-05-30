import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Checkout extends StatefulWidget {
  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  DateTime pickedDate;
  TimeOfDay time;
  List<TextEditingController> _controllers = [];
  String _selected;
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
    _tabController = TabController(length: 2, vsync: this);
    // pickedDate = new DateTime.now();
    pickedDate = new DateTime.now().add(Duration(days: 2));
    time = TimeOfDay.now();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                height: 80,
                child: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.home),
                        title: new TextField(
                          decoration:
                              const InputDecoration(hintText: 'Address...'),
                        ),
                      ),
                    ),
                    Card(
                        child: new ListTile(
                      title: Text('Vendor Address'),
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
                        Text('Name:'),
                        Text('Contact No:'),
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
              ListTile(
                title: Text("Time: ${time.hour}:${time.minute}"),
                trailing: Icon(Icons.keyboard_arrow_down),
                onTap: _pickedTime,
              ),
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
              ListView.builder(
                  shrinkWrap: true,
                  // separatorBuilder: (context, index) =>
                  //     Divider(
                  //       color: Colors.black,
                  //     ),
                  itemCount: 3,
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
                  }),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [new Text("Subtotal"), new Text("RM 100.00")],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [new Text("Delivery Fees"), new Text("RM 5.00")],
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
                      "RM 105.00",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Text("Payment Option:"),
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
                          child: DropdownButton(
                            hint: Text("Payment Options"),
                            value: _selected,
                            onChanged: (newValue) {
                              setState(() {
                                _selected = newValue;
                              });
                            },
                            items: _myJson.map((bankItem) {
                              return DropdownMenuItem(
                                  value: bankItem['id'].toString(),
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
            ],
          ),
        ),
      ),
    );
  }

  ListTile makeListTitle(BuildContext context, int index) => ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        trailing: Column(children: <Widget>[
          Text("RM 30.00"),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 2, 0),
            child: Text("\nx2"),
          )
        ]),
        leading: Container(
          width: 50,
          height: 150,
          alignment: Alignment.center,

          // child: Image.network(
          //   "image",
          //   height: 150,
          // ),
        ),
        title: Padding(
          padding: EdgeInsets.all(5),
          child: Text(
            "Cheese Cake",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        subtitle: Padding(
          padding: EdgeInsets.fromLTRB(4, 0, 0, 0),
          child: Wrap(
            direction: Axis.vertical,
            children: [
              Text(
                "Vendor name",
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
              Text(
                'Order Note:',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                ),
              ),
              SizedBox(height: 2),
              Container(
                color: Colors.grey[100],
                child: SizedBox(
                  width: 140,
                  child: TextField(
                    controller: _controllers[index],
                    maxLines: 3,
                    textAlign: TextAlign.start,
                    decoration: new InputDecoration.collapsed(
                      hintText: 'Write here...',
                      hintStyle:
                          TextStyle(fontSize: 13.0, color: Colors.grey[600]),
                    ),
                  ),
                ),
              ),
              // Align(alignment: Alignment.bottomRight, child: Text("total"))
            ],
          ),
        ),
      );

  _pickedDate() async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime.now().add(Duration(days: 2)),
      lastDate: DateTime(2022),
      initialDate: pickedDate,
    );

    if (date != null)
      setState(() {
        pickedDate = date;
      });
  }

  _pickedTime() async {
    TimeOfDay t = await showTimePicker(
      context: context,
      initialTime: time,
    );

    if (t != null)
      setState(() {
        time = t;
      });
  }
}
