import 'package:flutter/material.dart';

import 'views/auth/auth_view.dart';
import 'views/home/home_view.dart';
import 'views/product_detail/productdetail_view.dart';
import 'views/favorites/favorites_view.dart';
import 'views/cartandcheckout/checkout_view.dart';   
import 'views/admin/admin_view.dart';
import 'views/main_wrapper/main_wrapper_view.dart'; 
import 'views/admin/admin_shop_view.dart';// YENİ EKLEDİĞİMİZ SATIR

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Ticaret Projesi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/auth', 
      routes: {
        '/auth': (context) => const AuthView(),
        '/main_wrapper': (context) => const MainWrapperView(), // YENİ ROTA (Alt menülü ana ekran)
        '/home': (context) => const HomeView(),
        '/product_detail': (context) => const ProductDetailView(),
        '/favorites': (context) => const FavoritesView(),
        '/cart': (context) => const CartView(), 
        '/admin': (context) => const AdminView(),
        '/admin_shop': (context) => const AdminShopView(),
      },
    );
  }
}