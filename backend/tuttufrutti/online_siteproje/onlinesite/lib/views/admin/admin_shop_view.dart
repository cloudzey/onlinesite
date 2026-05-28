import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/models/product_model.dart';

class AdminShopView extends StatelessWidget {
  const AdminShopView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Sayfa arka planını hafif gri yaparak kartları öne çıkarıyoruz
      appBar: AppBar(
        title: const Text('Mağaza Satıcı Paneli'),
        backgroundColor: Colors.amber[700],
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: ValueListenableBuilder<List<ProductModel>>(
        valueListenable: AppConstants.productsNotifier, // Küresel havuzu dinle
        builder: (context, tumUrunler, child) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                // 1. BÖLÜM: HESABIM / MAĞAZA PROFİL KARTI
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.amber[700]!, Colors.orange[600]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Mağaza Avatarı / Logosu
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        child: const Icon(Icons.store, size: 40, color: Colors.white),
                      ),
                      const SizedBox(width: 16),
                      // Mağaza Detayları
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'ShopStream Resmi Mağazası',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Satıcı ID: #KOÜ2026', // Kocaeli Üniversitesi'ne göz kırpan küçük detay
                              style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13),
                            ),
                            const SizedBox(height: 8),
                            // Küçük Bilgi Rozetleri
                            Row(
                              children: [
                                _buildProfileBadge(Icons.inventory, '${tumUrunler.length} Ürün'),
                                const SizedBox(width: 8),
                                _buildProfileBadge(Icons.star, '4.9 Puan'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // BÖLÜM BAŞLIĞI
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'Vitrinindeki Ürünler',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                ),

                // 2. BÖLÜM: ÜRÜN LİSTESİ
                if (tumUrunler.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.0),
                      child: Text('Mağazanızda henüz hiçbir ürün listelenmiyor.', style: TextStyle(color: Colors.grey)),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true, // SingleChildScrollView içinde düzgün çalışması için
                    physics: const NeverScrollableScrollPhysics(), // Kaydırmayı üst ana frameworke devret
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: tumUrunler.length,
                    itemBuilder: (context, index) {
                      final urun = tumUrunler[index];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 1,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                urun.imageUrl,
                                width: 55,
                                height: 55,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, size: 40, color: Colors.grey),
                              ),
                            ),
                            title: Text(urun.productName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                'Kategori: ${urun.category}  |  Stok: ${urun.stock} Adet\nFiyat: ${urun.price.toStringAsFixed(0)} TL',
                                style: TextStyle(color: Colors.grey[600], fontSize: 13, height: 1.3),
                              ),
                            ),
                            isThreeLine: true,
                            
                            // ÜRÜN SİLME AKSİYONU
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 26),
                              onPressed: () {
                                _showDeleteDialog(context, urun);
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  // Yardımcı Metot: Profil Rozetleri Tasarımı
  Widget _buildProfileBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // Yardımcı Metot: Silme Onay Kutusu
  void _showDeleteDialog(BuildContext context, ProductModel urun) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Ürünü Mağazadan Kaldır?'),
          content: Text('${urun.productName} isimli ürün vitrinden tamamen silinecek. Emin misiniz?'),
          actions: [
            TextButton(
              child: const Text('İptal', style: TextStyle(color: Colors.grey)),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Evet, Sil'),
              onPressed: () {
                AppConstants.productsNotifier.value = AppConstants.productsNotifier.value
                    .where((p) => p.productId != urun.productId)
                    .toList();
                    
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${urun.productName} başarıyla kaldırıldı.'),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}