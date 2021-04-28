import 'package:creamee/model/imagecustom.dart';

class User {
  int id;
  String name;
  String contactno;
  String address;
  String email;
  double longitude;
  double latitude;
  ImageCustom profilepic;
  bool isblock;

  User({
    this.id,
    this.name,
    this.contactno,
    this.address,
    this.email,
    this.longitude,
    this.latitude,
    this.profilepic,
    this.isblock,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    contactno = json['contact_no'];
    address = json['address'];
    email = json['email'];
    longitude = double.parse(json['longitude']);
    latitude = double.parse(json['latitude']);
    profilepic = json['profile_pic'] != null
        ? new ImageCustom.fromJson(json['profile_pic'])
        : null;
    isblock = json['isblock'] == "0" ? false : true;
  }
}
