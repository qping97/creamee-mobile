class Payload {
  var subTotal;
  dynamic products;
  Payload({this.subTotal, this.products});

  Payload.fromJson(Map<String, dynamic> json) {
    products = json['products'];
    subTotal = json['subTotal'].toString();
    // subTotal = double.parse(json['subTotal']);
  }
}
