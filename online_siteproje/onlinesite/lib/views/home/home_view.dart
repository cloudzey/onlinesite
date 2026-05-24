import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart'; // Havuzu import ettik
import '../../core/models/product_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // Kullanıcının o an seçtiği kategoriyi hafızada tutuyoruz (Varsayılan: Tümü)
  String seciliKategori = 'Tümü';

  // Kategorilerin tam listesi (Görseldeki butonlarla birebir uyumlu)
  final List<String> kategoriler = ['Tümü', 'Elektronik', 'Giyim'];

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth > 600 ? 4 : 2;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Teke düşürüldü, hata çözüldü!
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ÜST BAŞLIK ALANI
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // spaceBetween olarak düzeltildi!
                  children: [
                    const Text(
                      'Merhaba, Keyifli Alışverişler! 👋',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    // Şık ve küçük Admin Butonu
                    IconButton(
                      onPressed: () => Navigator.pushNamed(context, '/admin'),
                      icon: const Icon(Icons.admin_panel_settings, color: Colors.amber, size: 28),
                      tooltip: 'Admin Paneli',
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                // ARAMA ÇUBUĞU
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Ürün, kategori veya marka ara...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
                const SizedBox(height: 25),

                // KATEGORİLER BAŞLIĞI
                const Text('Kategoriler', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),

                // 1. DİNAMİK KATEGORİ LİSTESİ
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: kategoriler.length,
                    itemBuilder: (context, index) {
                      final kategoriAdi = kategoriler[index];
                      final bool isSelected = seciliKategori == kategoriAdi;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            seciliKategori = kategoriAdi; // Kategoriyi değiştir ve ekranı tetikle!
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.deepPurple : Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              kategoriAdi,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 25),

                const Text('Günün Fırsatları', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),

                // 2. FİLTRELENEN DİNAMİK VİTRİN
                ValueListenableBuilder<List<ProductModel>>(
                  valueListenable: AppConstants.productsNotifier, // Havuzu dinle
                  builder: (context, currentProducts, child) {
                    
                    // Seçilen kategoriye göre listedeki elemanları süzüyoruz
                    final filtrelenmisUrunler = seciliKategori == 'Tümü'
                        ? currentProducts
                        : currentProducts.where((urun) => urun.category == seciliKategori).toList();

                    if (filtrelenmisUrunler.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40.0),
                          child: Text(
                            '$seciliKategori kategorisinde henüz ürün yok.',
                            style: const TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ),
                      );
                    }

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filtrelenmisUrunler.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.70,
                      ),
                      itemBuilder: (context, index) {
                        return _buildProductCard(context, filtrelenmisUrunler[index]);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ÜRÜN KART TASARIMI (Eski tasarımın birebir aynısı, yeni renk standartlarına uyarlandı)
  Widget _buildProductCard(BuildContext context, ProductModel product) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/product_detail',
          arguments: product,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.grey[100], borderRadius: const BorderRadius.vertical(top: Radius.circular(12))),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
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
                  Text(product.productName, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('${product.price.toStringAsFixed(0)} TL', style: const TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Align(alignment: Alignment.bottomRight, child: Icon(Icons.favorite_border, size: 20, color: Colors.grey[600])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}