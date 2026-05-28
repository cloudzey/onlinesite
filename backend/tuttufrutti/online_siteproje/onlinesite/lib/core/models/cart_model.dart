import 'product_model.dart';

class CartItemModel {
  final int cartItemId; // Diyagrama göre cart_item_id
  final ProductModel product;
  final int quantity;

  CartItemModel({
    required this.cartItemId,
    required this.product,
    required this.quantity,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      cartItemId: json['cart_item_id'] ?? 0,
      product: ProductModel.fromJson(json['product'] ?? {}),
      quantity: json['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cart_item_id': cartItemId,
      'product': product.toJson(),
      'quantity': quantity,
    };
  }
}