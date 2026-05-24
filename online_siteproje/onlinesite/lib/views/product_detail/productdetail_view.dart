import 'package:flutter/material.dart';
import '../../core/models/product_model.dart';
import '../../core/constants/app_constants.dart';
import '../../core/models/cart_model.dart'; // Modelimizi dahil ettik

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
                        onPressed: () {
                        // 1. Sepette bu ürün zaten var mı kontrol et
                        final mevcutSepet = AppConstants.cartNotifier.value;
                        int index = mevcutSepet.indexWhere((item) => item.product.productId == product.productId);

                        if (index != -1) {
                          // Ürün zaten varsa adetini (quantity) 1 arttır
                          mevcutSepet[index] = CartItemModel(
                            cartItemId: mevcutSepet[index].cartItemId,
                            product: mevcutSepet[index].product,
                            quantity: mevcutSepet[index].quantity + 1,
                          );
                          AppConstants.cartNotifier.value = [...mevcutSepet];
                        } else {
                          // Ürün sepette yoksa yeni bir CartItemModel olarak ekle (ER diyagramı uyumlu)
                          final yeniSepetElemani = CartItemModel(
                            cartItemId: DateTime.now().millisecondsSinceEpoch, // Benzersiz cart_item_id
                            product: product,
                            quantity: 1,
                          );
                          AppConstants.cartNotifier.value = [...mevcutSepet, yeniSepetElemani];
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${product.productName} sepete eklendi! 🛒'),
                            backgroundColor: Colors.deepPurple,
                          ),
                        );
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