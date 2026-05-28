import 'package:flutter/material.dart';
import '../home/home_view.dart';
import '../favorites/favorites_view.dart';
import '../cartandcheckout/checkout_view.dart'; // Sınıf adın CartView olduğu için

class MainWrapperView extends StatefulWidget {
  const MainWrapperView({super.key});

  @override
  State<MainWrapperView> createState() => _MainWrapperViewState();
}

class _MainWrapperViewState extends State<MainWrapperView> {
  // Aktif olan sekmenin indeksini tutar (0: Ana Sayfa, 1: Favoriler, 2: Sepet)
  int _currentIndex = 0;

  // Alt menüden tıklanınca sırasıyla açılacak sayfaların listesi
  final List<Widget> _pages = [
    const HomeView(),
    const FavoritesView(),
    const CartView(), // checkout_view.dart içindeki senin sınıfın
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Aktif olan indekse göre ekranda o sayfayı gösterir
      body: _pages[_currentIndex],
      
      // ALT NAVİGASYON BAR
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Tıklanan sekbeye geçiş yap ve ekranı yenile
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorilerim',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Sepetim',
          ),
        ],
      ),
    );
  }
}