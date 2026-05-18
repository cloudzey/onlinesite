import 'package:flutter/material.dart';

class ProductDetailView extends StatelessWidget {
  const ProductDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ürün Detayı'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new), // iOS tarzı zarif geri oku
          onPressed: () => Navigator.pop(context),   // Bir önceki sayfaya döner
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ÜST KISIM: Kaydırılabilir İçerik (Resim ve Açıklamalar)
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Büyük Ürün Resmi (Esnek Kutu)
                      Container(
                        width: double.infinity,
                        height: 300,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: Icon(Icons.image, size: 80, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 2. Ürün Başlığı ve Fiyatı
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Kablosuz Kulaklık Pro',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '1.250 TL',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // 3. Puan ve Stok Bilgisi (Küçük Detaylar)
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          const Text('4.8 (120 Değerlendirme)', style: TextStyle(fontWeight: FontWeight.w500)),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green[500]!.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Stokta Var',
                              style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // 4. Ürün Açıklaması
                      const Text(
                        'Ürün Açıklaması',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Bu bluetooth kulaklık, yüksek ses kalitesi ve aktif gürültü engelleme (ANC) özelliği ile harika bir müzik deneyimi sunar. iOS ve Web platformlarıyla tam uyumlu olup, tek şarjla 8 saate kadar kesintisiz kullanım sağlar. Ergonomik tasarımı sayesinde kulakları yormaz.',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.5),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ALT KISIM: Sabit Butonlar Paneli (Her Ekranda Altta Sabit Kalır)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Sepete Ekle Butonu (Çerçeveli)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // İleride sepet fonksiyonu buraya bağlanacak
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Ürün sepete eklendi!')),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Colors.deepPurple),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Sepete Ekle', style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Hemen Satın Al Butonu (Dolu Mor)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Direkt sepet/ödeme sayfasına yönlendirir
                        Navigator.pushNamed(context, '/cart');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Hemen Satın Al', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
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