import 'package:creamee/screen/productlist.dart';

class CartItem {
  int id;
  int customerid;
  int productid;
  int quantity;
  Product product;

  CartItem({
    this.id,
    this.customerid,
    this.productid,
    this.quantity,
    this.product,
  });

  CartItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerid = json['customer_id'];
    productid = json['product_id'];
    quantity = json['quantity'];
    product = Product.fromJson(json['product']);
  }
}
