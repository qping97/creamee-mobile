import 'package:creamee/model/cartitem.dart';
import 'package:creamee/model/user.dart';

class Order {
  User customer;
  List<CartItem> cart;
  double subtotal;
  int id;
  DateTime orderdate;
  DateTime pickupdate;
  String orderstatus;
  String shippingaddress;
  double amount;
  String payment;
  double deliverymethod;
  double deliveryfee;
  String ordernotes;
  int customerid;
  int vendorid;

  Order({
    this.customer,
    this.cart,
    this.subtotal,
    this.id,
    this.orderdate,
    this.pickupdate,
    this.orderstatus,
    this.shippingaddress,
    this.amount,
    this.payment,
    this.deliverymethod,
    this.deliveryfee,
    this.ordernotes,
    this.customerid,
    this.vendorid,
  });

  Order.fromJson(Map<String, dynamic> json) {
    customer = User.fromJson(json['customer']);
    List<dynamic> items = json['cart']['products'];
    cart = items.map((e) => CartItem.fromJson(e)).toList();
    // cart= CartItem.fomJson(json)
    subtotal = double.parse(json['subTotal'] ?? json['cart']['subTotal']);

    id = json['id'];
    orderdate = json['order_date'];
    pickupdate = json['pickup_date'];
    orderstatus = json['order_status'];
    shippingaddress = json['shipping_address'];
    amount = double.parse(json['total'] ?? json['cart']['total']);
    payment = json['payment'];
    deliverymethod = json['delivery_method'];
    deliveryfee =
        double.parse(json['deliveryFee'] ?? json['cart']['deliveryFee']);
    ordernotes = json['order_notes'];
    customerid = json['customer_id'];
    vendorid = json['vendor_id'];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'order_date': orderdate,
        'pickup_date': pickupdate,
        'order_status': orderstatus,
        'shipping_address': shippingaddress,
        'amount': amount,
        'payment': payment,
        'delivery_method': deliverymethod,
        'delivery_fee': deliveryfee,
        'order_notes': ordernotes,
        'customer_id': customerid,
        'vendor_id': vendorid,
      };
}
