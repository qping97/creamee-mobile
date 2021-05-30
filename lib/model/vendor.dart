import 'package:creamee/model/imagecustom.dart';

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
