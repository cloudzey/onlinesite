import 'package:flutter/material.dart';
import '../../core/models/product_model.dart';
import '../../core/services/api_service.dart';

class ProductDetailView extends StatelessWidget {
  const ProductDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ana sayfadan gönderilen ProductModel nesnesini burada yakalıyoruz
    final ProductModel product = ModalRoute.of(context)!.settings.arguments as ProductModel;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.productName), // Dinamik Başlık
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. DİNAMİK ÜRÜN RESMİ
              Container(
                width: double.infinity,
                height: 300,
                color: Colors.grey[100],
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, size: 50, color: Colors.grey),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 2. DİNAMİK ÜRÜN ADI
                    Text(
                      product.productName,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),

                    // 3. DİNAMİK FİYAT VE STOK DURUMU (ER Diyagramına uyumlu)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${product.price.toStringAsFixed(0)} TL',
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Stok: ${product.stock}', // ER diyagramından gelen stok sütunu
                            style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 10),

                    // 4. DİNAMİK AÇIKLAMA
                    const Text(
                      'Ürün Açıklaması',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.description.isEmpty ? 'Bu ürün için bir açıklama girilmemiş.' : product.description,
                      style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.4),
                    ),
                    const SizedBox(height: 30),

                    // 5. SEPETE EKLE BUTONU
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        
        onPressed: () async {
                        try {
                          print('EKLENEN ÜRÜN ID: ${product.productId}');
print('EKLENEN ÜRÜN ADI: ${product.productName}');
                        await ApiService.addToCart(
                        productId: product.productId,
                        quantity: 1,
                        );

                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                        content: Text('${product.productName} sepete eklendi! 🛒'),
                        backgroundColor: Colors.deepPurple,
                        ),
                        );
                       } catch (e) {
                       if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                        content: Text(e.toString().replaceFirst('Exception: ', '')),
                        backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                        icon: const Icon(Icons.shopping_cart_checkout),
                        label: const Text('Sepete Ekle', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}