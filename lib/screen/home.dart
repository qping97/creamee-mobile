import 'dart:async';
import 'dart:convert';
import 'package:creamee/provider/vendorprovider.dart';
import 'package:creamee/screen/customorder.dart';
import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:creamee/screen/categorylist.dart';
import 'package:creamee/screen/productlist.dart';
import 'package:creamee/screen/login.dart';
import 'package:creamee/screen/cart.dart';
// import 'package:creamee/network_utils/api.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:creamee/provider/userprovider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:creamee/screen/alert_logindialog.dart';
import 'package:creamee/model/vendor.dart';
import 'package:geolocator/geolocator.dart';

class Home extends StatefulWidget {
  // static  kInitialPosition = LatLng(0, 0);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // void checkUser() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var sharedUserResponseinString = prefs.getString('refresh_token');
  //   print(sharedUserResponseinString);
  //   if (sharedUserResponseinString == null) {
  //     print("No route");
  //   } else {
  //     bool success =
  //     if (success) {
  //       Provider.of<UserProvider>(context, listen: false).timeStart(context);
  //       // Navigator.push(
  //       //     context,
  //       //     MaterialPageRoute(
  //       //         settings: RouteSettings(name: DeskScreen.routeName),
  //       //         builder: (context) {
  //       //           return DeskScreen();
  //       //         }));
  //     }
  //   }
  // }

  // Completer<GoogleMapController> _controller = Completer();
  List<Vendor> vendors = [];
  VendorProvider vendorProvider;
  UserProvider userProvider;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    this.fetchVendor();
    this.getLocation();
  }

  void getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position);
    userProvider.currentposition = position;
    // var lat = position.latitude;
    // var long = position.longitude;
    // print(lat);
  }

  fetchVendor() async {
    var url = "http://192.168.0.187:8000/api/vendors";
    var response = await http.get(url);
    // print(response.body);
    if (response.statusCode == 200) {
      List<dynamic> items = json.decode(response.body)['data'];
      setState(() {
        vendors = items.map((vendor) => Vendor.fromJson(vendor)).toList();

        // isLoading = false;
      });
    } else {
      setState(() {
        vendors = [];
      });
      // isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);
    vendorProvider = Provider.of<VendorProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Creamee"),
        backgroundColor: Colors.red[200],
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.shopping_bag_outlined),
              onPressed: () {
                if (Provider.of<UserProvider>(context, listen: false).user ==
                    null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Login(topage: "cart")),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Cart()),
                  );
                }
              }
              // onPressed: () => Navigator.pushNamed(context, '/checkout'),
              )
        ],
      ),
      body: Stack(
        children: <Widget>[
          // searchBar(),
          ListView.builder(
            shrinkWrap: true,
            itemCount: vendors.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 2.0,
                margin:
                    new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                child: Container(
                  decoration: BoxDecoration(color: Colors.white),
                  child: makeListTitle(context, index),
                ),
              );
            },
          ),
          // _googlemap(context),
        ],
      ),
    );
  }

  ListTile makeListTitle(BuildContext context, int index) => ListTile(
        onTap: () {
          vendorProvider.vendorSelected(vendors[index]);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryList(),
            ),
          );
        },
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
        leading: Container(
          width: 60,
          height: 250,
          // color: Colors.green,
          alignment: Alignment.center,
          child: Image.network(
            vendors[index].image.url,
            // widget.cartitem.product.productimage.url,
            height: 150,
          ),
        ),
        title: Row(children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
            child: Text(
              vendors[index].vname,
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Container(
              //   padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
              //   child: Text(
              //     // (userProvider.currentposition.latitude -
              //     //         vendors[index].latitude)
              //     //     .toString(),
              //     '900 m',
              //     style: TextStyle(
              //       color: Colors.grey[400],
              //       fontSize: 26,
              //       fontWeight: FontWeight.bold,
              //       // shadows: [
              //       //   Shadow(
              //       //       color: Colors.white10.withOpacity(0.6),
              //       //       offset: Offset(8, 8),
              //       //       blurRadius: 15),
              //       // ],
              //     ),
              //     textAlign: TextAlign.left,
              //   ),
              // ),
            ],
          ),
        ]),
        subtitle: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(5),
              child: Wrap(
                direction: Axis.vertical,
                children: [
                  Row(
                    children: <Widget>[
                      Icon(Icons.phone, color: Colors.grey[350]),
                      Text(
                        vendors[index].contactno,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.email, color: Colors.grey[350]),
                        Text(
                          vendors[index].email,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.place, color: Colors.grey[350]),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Text(
                            vendors[index].address,
                            // maxLines: 5,
                            // overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );

  Widget searchBar() {
    return FloatingSearchBar(
      hint: 'Search.....',
      openAxisAlignment: 0.0,
      maxWidth: 600,
      axisAlignment: 0.0,
      scrollPadding: EdgeInsets.only(top: 16, bottom: 20),
      elevation: 4.0,
      physics: BouncingScrollPhysics(),
      onQueryChanged: (query) {
        //Your methods will be here
      },
      // showDrawerHamburger: false,
      transitionCurve: Curves.easeInOut,
      transitionDuration: Duration(milliseconds: 500),
      transition: CircularFloatingSearchBarTransition(),
      debounceDelay: Duration(milliseconds: 500),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: Icon(Icons.place),
            onPressed: () {
              print('Places Pressed');
            },
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Material(
            color: Colors.white,
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: vendors.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        splashColor: Colors.yellow,
                        onTap: () {
                          vendorProvider.vendorSelected(vendors[index]);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoryList(),
                            ),
                          );
                          // print("dfdshfds");
                        },
                        child: ListTile(
                          title: Text(vendors[index].vname),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
