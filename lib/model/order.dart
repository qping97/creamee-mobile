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
  String deliverymethod;
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
    if (json['customer'] != null) customer = User.fromJson(json['customer']);
    if (json['cart'] != null) {
      List<dynamic> items = json['cart']['products'];
      cart = items.map((e) => CartItem.fromJson(e)).toList();
      subtotal = double.parse(json['cart']['subTotal']);
      amount = double.parse(json['cart']['total']);
      deliveryfee = double.parse(json['cart']['deliveryFee']);
    }
    // cart= CartItem.fomJson(json)
    subtotal ??= double.parse(json['subTotal'] ?? '0');

    id = json['id'];
    if (json['order_date'] != null) {
      orderdate = DateTime.parse('${json['order_date']} 00:00:00.000');
    }
    if (json['pickup_date'] != null) {
      pickupdate = DateTime.parse('${json['pickup_date']} 00:00:00.000');
    }
    orderstatus = json['order_status'];
    shippingaddress = json['shipping_address'];
    amount ??= double.parse(json['amount'] ?? '0');
    payment = json['payment'];
    deliverymethod = json['delivery_method'];
    deliveryfee ??= double.parse(json['deliveryFee'] ?? '0');
    ordernotes = json['order_notes'];
    customerid = json['customer_id'];
    vendorid = json['vendor_id'];
  }

  Map<String, dynamic> toJson() => {
        // 'id': id,
        // 'order_date': orderdate,
        'pickup_date':
            "${pickupdate.year}-${pickupdate.month}-${pickupdate.day}",
        // 'order_status': orderstatus,
        'shipping_address': shippingaddress,
        'amount': amount,
        'payment': payment,
        'delivery_method': deliverymethod,
        // 'delivery_fee': deliveryfee,
        'order_notes': ordernotes,
        'customer_id': customerid,
        'vendor_id': vendorid,
      };
}
