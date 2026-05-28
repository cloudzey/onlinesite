import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/cart_model.dart';
import '../models/order_model.dart';

class AppConstants {
  // 1. ÜRÜN HAVUZU (Kategorileriyle Birlikte ER Diyagramına Tam Uyumlu)
  static final ValueNotifier<List<ProductModel>> productsNotifier = ValueNotifier<List<ProductModel>>([
    ProductModel(
      productId: 1,
      productName: 'Kablosuz Kulaklık Pro',
      price: 1250.0,
      stock: 15,
      imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500',
      description: 'Yüksek ses kalitesi ve aktif gürültü engelleme özelliği.',
      category: 'Elektronik',
    ),
    ProductModel(
      productId: 2,
      productName: 'Akıllı Saat Series 9',
      price: 4500.0,
      stock: 8,
      imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500',
      description: 'Adım sayar, nabız ölçer ve su geçirmez spor akıllı saat.',
      category: 'Elektronik',
    ),
  ]);

  // 2. SEPET HAVUZU (CartItems Yapısı)
  static final ValueNotifier<List<CartItemModel>> cartNotifier = ValueNotifier<List<CartItemModel>>([]);

  // 3. SİPARİŞ HAVUZU (Orders Tablosu Simülasyonu)
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
}