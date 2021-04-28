import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';

class CustomOrder extends StatefulWidget {
  @override
  _CustomOrderState createState() => _CustomOrderState();
}

class _CustomOrderState extends State<CustomOrder> {
  int _stackIndex = 0;
  String _singleValue = "Text alignment right";
  String _verticalGroupValue = "Pending";
  List<String> _status = ["Pending", "Released", "Blocked"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Custom Order"),
        backgroundColor: Colors.red[200],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "Select Cake Size",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          // SizedBox(height:1.0 ),
          Expanded(
            child: IndexedStack(
              index: _stackIndex,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    RadioButton(
                      description: "Size 1",
                      value: "Size 1",
                      groupValue: _singleValue,
                      onChanged: (value) => setState(
                        () => _singleValue = value,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    RadioGroup<String>.builder(
                      groupValue: _verticalGroupValue,
                      onChanged: (value) => setState(() {
                        _verticalGroupValue = value;
                      }),
                      items: _status,
                      itemBuilder: (item) => RadioButtonBuilder(
                        item,
                      ),
                    ),
                  ],
                ),
                RadioGroup<String>.builder(
                  direction: Axis.horizontal,
                  groupValue: _verticalGroupValue,
                  onChanged: (value) => setState(() {
                    _verticalGroupValue = value;
                  }),
                  items: _status,
                  itemBuilder: (item) => RadioButtonBuilder(
                    item,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      // body: Container(
      //   padding: EdgeInsets.all(20),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       Text(
      //         "Select Cake Size",
      //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      //       ),
      //       SizedBox(height: 15),

      //     ],
      //   ),
      // ),
    );
  }
}
