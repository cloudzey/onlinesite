import 'package:flutter/material.dart';
import '../../core/models/product_model.dart';
import '../../core/constants/app_constants.dart';

class AdminView extends StatefulWidget {
  const AdminView({super.key});

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  // 1. KUTULARDAKİ VERİLERİ YAKALAYACAK KUMANDALAR (CONTROLLER)
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Bellek sızıntısını (Memory Leak) önlemek için kumandaları işi bitince kapatıyoruz
  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    _imageController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mağaza Yönetim Paneli'),
        backgroundColor: Colors.amber[700],
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Yeni Ürün Ekleme Formu',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Buraya girdiğiniz ürünler backend tetiklendiğinde SQL veritabanına yazılacaktır.',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 25),

                // 2. KUTULARA KUMANDALARI (CONTROLLER) BAĞLIYORUZ
                TextField(
                  controller: _nameController, // Bağlantı kuruldu
                  decoration: InputDecoration(
                    labelText: 'Ürün Adı',
                    hintText: 'Örn: iPhone 15 Pro Max',
                    prefixIcon: const Icon(Icons.shopping_bag),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: _priceController, //鍵Bağlantı kuruldu
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Ürün Fiyatı (TL)',
                    hintText: 'Örn: 75000',
                    prefixIcon: const Icon(Icons.attach_money),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: _categoryController, // Bağlantı kuruldu
                  decoration: InputDecoration(
                    labelText: 'Kategori',
                    hintText: 'Örn: Elektronik, Giyim...',
                    prefixIcon: const Icon(Icons.category),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: _imageController, // Bağlantı kuruldu
                  decoration: InputDecoration(
                    labelText: 'Ürün Resim Linki (URL)',
                    hintText: 'https://example.com/resim.png',
                    prefixIcon: const Icon(Icons.link),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: _descriptionController, // Bağlantı kuruldu
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Ürün Açıklaması',
                    hintText: 'Ürünün özelliklerini yazınız...',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 30),

                // 3. BUTONA BASILDIĞINDA VERİLERİ KONSOLA YAZDIRMA TESTİ
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      String urunAdi = _nameController.text;
                      String urunFiyati = _priceController.text;
                      String urunKategori = _categoryController.text;
                      String urunResim = _imageController.text;
                      String urunAciklama = _descriptionController.text;

                      if (urunAdi.isEmpty || urunFiyati.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Lütfen ürün adı ve fiyatı alanlarını doldurun!'), backgroundColor: Colors.red),
                        );
                        return;
                      }

                      // 1. ER DİYAGRAMINA UYUMLU YENİ ÜRÜN NESNESİNİ OLUŞTURUYORUZ
                      final yeniUrun = ProductModel(
                        productId: DateTime.now().millisecondsSinceEpoch, // Benzersiz random ID üretir
                        productName: urunAdi,
                        price: double.tryParse(urunFiyati) ?? 0.0,
                        stock: 10, // Varsayılan stok
                        imageUrl: urunResim.isEmpty ? 'https://via.placeholder.com/150' : urunResim, // Boşsa şablon resim
                        description: urunAciklama,
                      );

                      // 2. GLOBAL HAVUZDAKİ LİSTEYİ GÜNCELLİYORUZ
                      // Mevcut listeyi kopyalayıp içine yeni ürünü ekliyoruz ve notifier'ı tetikliyoruz
                      AppConstants.productsNotifier.value = [
                        ...AppConstants.productsNotifier.value,
                        yeniUrun
                      ];

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('$urunAdi başarıyla mağazaya eklendi ve vitrine kondu! 🚀'),
                          backgroundColor: Colors.green,
                        ),
                      );

                      // Kutuları temizle
                      _nameController.clear();
                      _priceController.clear();
                      _categoryController.clear();
                      _imageController.clear();
                      _descriptionController.clear();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_circle_outline),
                        SizedBox(width: 8),
                        Text('Ürünü Mağazaya Yükle', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}