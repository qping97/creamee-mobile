import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:creamee/screen/categorylist.dart';
import 'package:creamee/screen/login.dart';
import 'package:creamee/screen/cart.dart';
// import 'package:creamee/network_utils/api.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:http/http.dart' as http;
import 'package:creamee/model/imagecustom.dart';
import 'package:provider/provider.dart';
import 'package:creamee/provider/userprovider.dart';
// import 'package:creamee/screen/alert_logindialog.dart';

class Vendor {
  int id;
  String vname;
  String contactno;
  String address;
  String email;
  double longitude;
  double latitude;
  ImageCustom image;

  Vendor({
    this.id,
    this.vname,
    this.contactno,
    this.address,
    this.email,
    this.longitude,
    this.latitude,
    this.image,
  });

  Vendor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vname = json['vendor_name'];
    contactno = json['contact_no'];
    address = json['vendor_address'];
    email = json['email'];
    longitude = double.parse(json['longitude']);
    latitude = double.parse(json['latitude']);
    image =
        json['image'] != null ? new ImageCustom.fromJson(json['image']) : null;
  }
}

class Home extends StatefulWidget {
  // static  kInitialPosition = LatLng(0, 0);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Completer<GoogleMapController> _controller = Completer();
  List<Vendor> vendors = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    this.fetchVendor();
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

  // double zoomVal = 5.0;

  @override
  Widget build(BuildContext context) {
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
          searchBar(),
          // _googlemap(context),
        ],
      ),
    );
  }

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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CategoryList(vendor: vendors[index])),
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

  // Widget _googlemap(BuildContext content) {
  //   return Container(
  //     height: MediaQuery.of(context).size.height,
  //     width: MediaQuery.of(context).size.width,
  //     child: PlacePicker(
  //       usePlaceDetailSearch: true,
  //       apiKey: "AIzaSyAEZ1klRMBQxeGIeZuOkwzEbhbE3RpGXgM",
  //       onPlacePicked: (result) {
  //         // selectedPlace = result;
  //         print(result.formattedAddress);
  //         print(result.name);
  //         //lat come first then long (lat, long)
  //         print("lat: ${result.geometry.location.lat}");
  //         print("long: ${result.geometry.location.lng}");
  //         // setState(() {
  //         //   selectedPlaceName = result.name;
  //         //   selectedLat = result.geometry.location.lat;
  //         //   selectedLong = result.geometry.location.lng;
  //         // });
  //         // _getLongandLat();
  //         Navigator.of(context).pop();
  //         // _accessMethodName.add(
  //         //     deliverAccessMethod[index]
  //         //         .deliverAccessMethodName);
  //         // _accessMethodIndex.add(
  //         //     deliverAccessMethod[index]
  //         //         .deliverAccessMethodNameIndex);
  //         // print(_accessMethodName);
  //       },
  //       initialPosition: Home.kInitialPosition,
  //       useCurrentLocation: true,
  //     ),
  //     // child: GoogleMap(
  //     //   mapType: MapType.normal,
  //     //   initialCameraPosition:
  //     //       CameraPosition(target: LatLng(1.5535, 110.3593), zoom: 12),
  //     //   onMapCreated: (GoogleMapController controller) {
  //     //     _controller.complete(controller);
  //     //   },
  //     //   markers: {takaMarker, mitaMarker},
  //     // ),
  //   );
}

// _getLongandLat() async {
//     List<Placemark> placemark =
//         await Geolocator().placemarkFromAddress(selectedPlace.formattedAddress);
//     Placemark newplace = placemark[0];
//     print(newplace.position.latitude);
//     print(newplace.position.longitude);
//   }
//   Marker takaMarker = Marker(
//     markerId: MarkerId('taka'),
//     position: LatLng(1.5263113, 110.3743929),
//     infoWindow: InfoWindow(title: 'TAKA Cake House'),
//     icon: BitmapDescriptor.defaultMarkerWithHue(
//       BitmapDescriptor.hueViolet,
//     ),
//   );

//   Marker mitaMarker = Marker(
//     markerId: MarkerId('mita'),
//     position: LatLng(1.5263381, 110.3678),
//     infoWindow: InfoWindow(title: 'Mita Cake House'),
//     icon: BitmapDescriptor.defaultMarkerWithHue(
//       BitmapDescriptor.hueViolet,
//     ),
//   );
// }
