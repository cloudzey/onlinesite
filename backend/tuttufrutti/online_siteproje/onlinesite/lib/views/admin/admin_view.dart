import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/models/product_model.dart';

class AdminView extends StatefulWidget {
  const AdminView({super.key});

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  // Kontrolcüleri (Form verilerini okumak için) burada tanımlıyoruz
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  @override
  void dispose() {
    // Hafıza sızıntısını önlemek için temizliyoruz
    nameController.dispose();
    priceController.dispose();
    stockController.dispose();
    imageController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
        title: const Text('Mağaza Yönetim Paneli'),
        backgroundColor: Colors.amber[700],
        foregroundColor: Colors.white,
        actions: [
          // Admin Shop sayfasına gitme butonu
          TextButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/admin_shop'),
            icon: const Icon(Icons.storefront, color: Colors.white),
            label: const Text('Ürünleri Yönet', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Yeni Ürün Ekleme Formu',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Girdi Alanları
              _buildTextField(nameController, 'Ürün Adı', Icons.shopping_bag),
              _buildTextField(priceController, 'Fiyat (TL)', Icons.attach_money, isNumber: true),
              _buildTextField(stockController, 'Stok Adedi', Icons.analytics, isNumber: true),
              _buildTextField(categoryController, 'Kategori (Örn: Elektronik, Moda, Kozmetik)', Icons.category),
              _buildTextField(imageController, 'Resim URL Adresi', Icons.link),

              const SizedBox(height: 30),

              // ÜRÜN EKLEME BUTONU
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Validasyon (Boş bırakmama kontrolü)
                    if (nameController.text.isEmpty || priceController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Lütfen en azından ürün adı ve fiyatı alanlarını doldurun!')),
                      );
                      return;
                    }

                    // 1. Yeni Ürün Nesnesini Oluşturuyoruz
                    final yeniUrun = ProductModel(
                      productId: DateTime.now().millisecondsSinceEpoch, // Benzersiz ID
                      productName: nameController.text,
                      price: double.tryParse(priceController.text) ?? 0.0,
                      stock: int.tryParse(stockController.text) ?? 0,
                      imageUrl: imageController.text.isEmpty
                          ? 'https://images.unsplash.com/photo-1531403009284-440f080d1e12?w=500' // Varsayılan görsel
                          : imageController.text,
                      description: 'Admin tarafından eklenen harika bir ürün.',
                      category: categoryController.text.isEmpty ? 'Genel' : categoryController.text,
                    );

                    // 2. Küresel Listeye (Notifier) Yeni Ürünü Ekliyoruz
                    AppConstants.productsNotifier.value = [
                      yeniUrun,
                      ...AppConstants.productsNotifier.value,
                    ];

                    // 3. Formu Temizle ve Başarı Mesajı Göster
                    nameController.clear();
                    priceController.clear();
                    stockController.clear();
                    imageController.clear();
                    categoryController.clear();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Ürün başarıyla mağaza vitrinine eklendi!'),
                        backgroundColor: Colors.green,
                      ),
                    );

                    // Ürün eklendikten sonra ana sayfaya geri dön
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[700],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Ürünü Mağazaya Yükle', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Yardımcı Metot: Şık Tasarımlı Input Alanı
  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.amber[700]),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.amber[700]!, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}