import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/cart_model.dart';
import '../models/order_model.dart'; // En üste eklemeyi unutma // Sepet modelini dahil ettik

class AppConstants {
  // Ürün havuzu
  static final ValueNotifier<List<ProductModel>> productsNotifier = ValueNotifier<List<ProductModel>>([
    ProductModel(
      productId: 1,
      productName: 'Kablosuz Kulaklık Pro',
      price: 1250.0,
      stock: 15,
      imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500',
      description: 'Yüksek ses kalitesi ve aktif gürültü engelleme özelliği.',
    ),
    ProductModel(
      productId: 2,
      productName: 'Akıllı Saat Series 9',
      price: 4500.0,
      stock: 8,
      imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500',
      description: 'Adım sayar, nabız ölçer ve su geçirmez spor akıllı saat.',
    ),
  ]);
  static final ValueNotifier<List<OrderModel>> ordersNotifier = ValueNotifier<List<OrderModel>>([
  OrderModel(
    orderId: 58392,
    orderStatus: 'Yolda',
    orderDate: '22.05.2026',
    totalAmount: 1250.0,
  ),
  OrderModel(
    orderId: 58120,
    orderStatus: 'Teslim Edildi',
    orderDate: '18.05.2026',
    totalAmount: 4500.0,
  ),
]);

  // YENİ: ER Diyagramındaki CartItems mantığına uygun küresel sepet havuzu
  static final ValueNotifier<List<CartItemModel>> cartNotifier = ValueNotifier<List<CartItemModel>>([]);
}