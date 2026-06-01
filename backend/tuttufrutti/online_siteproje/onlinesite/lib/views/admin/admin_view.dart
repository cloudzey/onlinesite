import 'package:flutter/material.dart';
import '../../core/services/api_service.dart';

class AdminView extends StatefulWidget {
  const AdminView({super.key});

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    stockController.dispose();
    imageController.dispose();
    categoryController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void showMessage(String message, {Color color = Colors.red}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  int? getCategoryId(String categoryText) {
    final category = categoryText.trim().toLowerCase();

    if (category == 'elektronik') return 1;
    if (category == 'giyim' || category == 'moda') return 2;
    if (category == 'kozmetik') return 3;

    return null;
  }

  Future<void> addProduct() async {
    final name = nameController.text.trim();
    final priceText = priceController.text.trim();
    final stockText = stockController.text.trim();
    final imageUrl = imageController.text.trim();
    final categoryText = categoryController.text.trim();
    final description = descriptionController.text.trim();

    if (name.isEmpty) {
      showMessage('Ürün adı boş bırakılamaz.');
      return;
    }

    final price = double.tryParse(priceText.replaceAll(',', '.'));
    if (price == null || price <= 0) {
      showMessage('Fiyat 0’dan büyük bir sayı olmalı.');
      return;
    }

    final stock = int.tryParse(stockText);
    if (stock == null || stock < 0) {
      showMessage('Stok 0 veya daha büyük bir sayı olmalı.');
      return;
    }

    if (categoryText.isEmpty) {
      showMessage('Kategori boş bırakılamaz.');
      return;
    }

    final categoryId = getCategoryId(categoryText);
    if (categoryId == null) {
      showMessage('Kategori sadece Elektronik, Giyim/Moda veya Kozmetik olabilir.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await ApiService.addProduct(
        productName: name,
        description: description.isEmpty
            ? 'Admin tarafından eklenen ürün.'
            : description,
        price: price,
        stock: stock,
        imageUrl: imageUrl.isEmpty
            ? 'https://images.unsplash.com/photo-1531403009284-440f080d1e12?w=500'
            : imageUrl,
        categoryId: categoryId,
        shopId: 1,
      );

      if (!mounted) return;

      nameController.clear();
      priceController.clear();
      stockController.clear();
      imageController.clear();
      categoryController.clear();
      descriptionController.clear();

      showMessage(
        'Ürün başarıyla backend’e eklendi!',
        color: Colors.green,
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      showMessage(
        e.toString().replaceFirst('Exception: ', ''),
        color: Colors.red,
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mağaza Yönetim Paneli'),
        backgroundColor: Colors.amber[700],
        foregroundColor: Colors.white,
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/admin_shop'),
            icon: const Icon(Icons.storefront, color: Colors.white),
            label: const Text(
              'Ürünleri Yönet',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
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

              _buildTextField(
                nameController,
                'Ürün Adı',
                Icons.shopping_bag,
              ),
              _buildTextField(
                priceController,
                'Fiyat (TL)',
                Icons.attach_money,
                isNumber: true,
              ),
              _buildTextField(
                stockController,
                'Stok Adedi',
                Icons.analytics,
                isNumber: true,
              ),
              _buildTextField(
                categoryController,
                'Kategori: Elektronik, Giyim/Moda veya Kozmetik',
                Icons.category,
              ),
              _buildTextField(
                imageController,
                'Resim URL Adresi',
                Icons.link,
              ),
              _buildTextField(
                descriptionController,
                'Ürün Açıklaması',
                Icons.description,
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : addProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[700],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Ürünü Mağazaya Yükle',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.amber[700]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.amber[700]!, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}