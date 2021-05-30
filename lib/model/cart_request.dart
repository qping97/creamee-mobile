// class CartRequestModel {
//   int customerId;
//   List<CartProduct> products;

//   CartRequestModel({this.customerId, this.products});

//   CartRequestModel.fromJson(Map<String, dynamic> json) {
//     customerId = json['customer_id'];
//     if (json['product'] != null) {
//       products = new List<CartProduct>();
//       json['product'].forEach((v) {
//         products.add(new CartProduct.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson(){
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['payload.']
//   }
// }
