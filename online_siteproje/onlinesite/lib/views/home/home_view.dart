import 'package:flutter/material.dart';
import '../../core/models/product_model.dart'; // Modelimizi import ettik

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth > 600 ? 4 : 2;

    // 1. DİNAMİK ÜRÜN LİSTEMİZ (Admin paneli bağlandığında bu liste SQL'den dolacak)
    final List<ProductModel> dummyProducts = [
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
      ProductModel(
        productId: 3,
        productName: 'Sırt Çantası Ergonomik',
        price: 850.0,
        stock: 20,
        imageUrl: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=500',
        description: 'Su geçirmez kumaş, laptop bölmeli konforlu çanta.',
      ),
      ProductModel(
        productId: 4,
        productName: 'Mekanik Oyuncu Klavyesi',
        price: 1950.0,
        stock: 5,
        imageUrl: 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=500',
        description: 'RGB aydınlatmalı, kırmızı switch mekanik klavye.',
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Başlık
                const Text(
                  'Merhaba, Keyifli Alışverişler! 👋',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),

                // Admin Paneli Test Butonu
                ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/admin'),
                  icon: const Icon(Icons.admin_panel_settings),
                  label: const Text('Admin Paneline Git (Test)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[100], 
                    foregroundColor: Colors.amber[900],
                  ),
                ),
                const SizedBox(height: 15),

                // Arama Çubuğu
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Ürün, kategori veya marka ara...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
                const SizedBox(height: 25),

                // Kategoriler
                const Text(
                  'Kategoriler',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildCategoryChip('Tümü', true),
                      _buildCategoryChip('Elektronik', false),
                      _buildCategoryChip('Giyim', false),
                      _buildCategoryChip('Ayakkabı', false),
                    ],
                  ),
                ),
                const SizedBox(height: 25),

                // Ürünler Izgarası
                const Text(
                  'Günün Fırsatları',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: dummyProducts.length, // Eleman sayısı listeden geliyor
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.70, // Resimler net sığsın diye biraz uzattık
                  ),
                  itemBuilder: (context, index) {
                    // O anki ürünü karta parametre olarak gönderiyoruz
                    return _buildProductCard(context, dummyProducts[index]);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.deepPurple : Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // 2. KART TASARIMINI MODEL VERİLERİNE BAĞLADIK
  Widget _buildProductCard(BuildContext context, ProductModel product) {
    return GestureDetector(
      onTap: () {
        // İleride detay sayfasına bu ürünü göndereceğiz
        Navigator.pushNamed(context, '/product_detail');
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gerçek İnternet Resmi (NetworkImage)
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    // Resim yüklenirken hata oluşursa boş ikon gösterir:
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, color: Colors.grey),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.productName, // Dinamik İsim
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${product.price.toStringAsFixed(0)} TL', // Dinamik Fiyat
                    style: const TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Icon(Icons.favorite_border, size: 20, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}