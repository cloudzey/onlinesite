import 'package:flutter/material.dart';
import '../../core/models/product_model.dart';
import '../../core/services/api_service.dart';

class AdminShopView extends StatefulWidget {
  const AdminShopView({super.key});

  @override
  State<AdminShopView> createState() => _AdminShopViewState();
}

class _AdminShopViewState extends State<AdminShopView> {
  late Future<List<ProductModel>> productsFuture;
late Future<Map<String, dynamic>> shopProfileFuture;
bool isDeleting = false;

  @override
void initState() {
  super.initState();
  productsFuture = ApiService.getProductsByShop();
  shopProfileFuture = ApiService.getShopProfile();
}

  void refreshProducts() {
  setState(() {
    productsFuture = ApiService.getProductsByShop();
    shopProfileFuture = ApiService.getShopProfile();
  });
}

  void showMessage(String message, {Color color = Colors.deepPurple}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  Future<void> deleteProduct(ProductModel product) async {
    setState(() {
      isDeleting = true;
    });

    try {
      await ApiService.deleteProduct(productId: product.productId);

      if (!mounted) return;

      Navigator.pop(context);

      showMessage(
        '${product.productName} başarıyla backend’den silindi.',
        color: Colors.redAccent,
      );

      refreshProducts();
    } catch (e) {
      if (!mounted) return;

      Navigator.pop(context);

      showMessage(
        e.toString().replaceFirst('Exception: ', ''),
        color: Colors.red,
      );
    } finally {
      if (mounted) {
        setState(() {
          isDeleting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Mağaza Satıcı Paneli'),
        backgroundColor: Colors.amber[700],
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Ürünleri Yenile',
            onPressed: refreshProducts,
          ),
        ],
      ),
      body: FutureBuilder<List<ProductModel>>(
        future: productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.amber),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString().replaceFirst('Exception: ', ''),
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final tumUrunler = snapshot.data ?? [];

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder<Map<String, dynamic>>(
  future: shopProfileFuture,
  builder: (context, shopSnapshot) {
    final shop = shopSnapshot.data;

    final shopName = shop?['shop_name']?.toString() ?? 'Mağaza';
    final shopId = shop?['shop_id']?.toString() ?? '-';
    final description = shop?['description']?.toString() ?? 'Satıcı mağazası';

    return Container(
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
            color: Colors.orange.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            child: const Icon(
              Icons.store,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shopName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Satıcı ID: #$shopId',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildProfileBadge(
                      Icons.inventory,
                      '${tumUrunler.length} Ürün',
                    ),
                    const SizedBox(width: 8),
                    _buildProfileBadge(Icons.star, '4.9 Puan'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  },
),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'Vitrinindeki Ürünler',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),

                if (tumUrunler.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.0),
                      child: Text(
                        'Mağazanızda henüz hiçbir ürün listelenmiyor.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: tumUrunler.length,
                    itemBuilder: (context, index) {
                      final urun = tumUrunler[index];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
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
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.image,
                                    size: 40,
                                    color: Colors.grey,
                                  );
                                },
                              ),
                            ),
                            title: Text(
                              urun.productName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                'Kategori: ${urun.category}  |  Stok: ${urun.stock} Adet\nFiyat: ${urun.price.toStringAsFixed(0)} TL',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                  height: 1.3,
                                ),
                              ),
                            ),
                            isThreeLine: true,
                            trailing: Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    IconButton(
      icon: const Icon(
        Icons.edit,
        color: Colors.blueAccent,
        size: 25,
      ),
      tooltip: 'Ürünü Düzenle',
      onPressed: () {
        _showEditProductDialog(urun);
      },
    ),
    IconButton(
      icon: const Icon(
        Icons.delete_outline,
        color: Colors.redAccent,
        size: 26,
      ),
      tooltip: 'Ürünü Sil',
      onPressed: isDeleting
          ? null
          : () {
              _showDeleteDialog(context, urun);
            },
    ),
  ],
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

  Widget _buildProfileBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, ProductModel urun) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Ürünü Mağazadan Kaldır?'),
          content: Text(
            '${urun.productName} isimli ürün backend veritabanından silinecek. Emin misiniz?',
          ),
          actions: [
            TextButton(
              child: const Text(
                'İptal',
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () => Navigator.pop(dialogContext),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: isDeleting
                  ? null
                  : () {
                      deleteProduct(urun);
                    },
              child: isDeleting
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Evet, Sil'),
            ),
          ],
        );
      },
    );
  }

  void _showEditProductDialog(ProductModel urun) {
  final editNameController =
      TextEditingController(text: urun.productName);
  final editDescriptionController =
      TextEditingController(text: urun.description);
  final editPriceController =
      TextEditingController(text: urun.price.toString());
  final editStockController =
      TextEditingController(text: urun.stock.toString());
  final editImageController =
      TextEditingController(text: urun.imageUrl);

  String selectedCategory = urun.category;

  int getCategoryIdFromName(String categoryName) {
  final category = categoryName.trim().toLowerCase();

  if (category == 'elektronik') return 1;
  if (category == 'giyim' || category == 'moda') return 2;
  if (category == 'kozmetik') return 3;

  return urun.categoryId ?? 1;
}

  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('Ürünü Düzenle'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: editNameController,
                    decoration: const InputDecoration(
                      labelText: 'Ürün Adı',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: editDescriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Açıklama',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: editPriceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Fiyat',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: editStockController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Stok',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: ['Elektronik', 'Giyim', 'Kozmetik']
                            .contains(selectedCategory)
                        ? selectedCategory
                        : 'Elektronik',
                    decoration: const InputDecoration(
                      labelText: 'Kategori',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Elektronik',
                        child: Text('Elektronik'),
                      ),
                      DropdownMenuItem(
                        value: 'Giyim',
                        child: Text('Giyim'),
                      ),
                      DropdownMenuItem(
                        value: 'Kozmetik',
                        child: Text('Kozmetik'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == null) return;

                      setDialogState(() {
                        selectedCategory = value;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: editImageController,
                    decoration: const InputDecoration(
                      labelText: 'Resim URL',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('İptal'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[700],
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  final newName = editNameController.text.trim();
                  final newDescription =
                      editDescriptionController.text.trim();
                  final newPrice = double.tryParse(
                    editPriceController.text.trim().replaceAll(',', '.'),
                  );
                  final newStock =
                      int.tryParse(editStockController.text.trim());
                  final newImageUrl = editImageController.text.trim();

                  if (newName.isEmpty) {
                    showMessage('Ürün adı boş bırakılamaz.',
                        color: Colors.red);
                    return;
                  }

                  if (newPrice == null || newPrice <= 0) {
                    showMessage('Fiyat 0’dan büyük olmalı.',
                        color: Colors.red);
                    return;
                  }

                  if (newStock == null || newStock < 0) {
                    showMessage('Stok 0 veya daha büyük olmalı.',
                        color: Colors.red);
                    return;
                  }

                  try {
                    await ApiService.updateProduct(
                      productId: urun.productId,
                      productName: newName,
                      description: newDescription.isEmpty
                          ? 'Admin tarafından güncellenen ürün.'
                          : newDescription,
                      price: newPrice,
                      stock: newStock,
                      imageUrl: newImageUrl.isEmpty
                          ? 'https://images.unsplash.com/photo-1531403009284-440f080d1e12?w=500'
                          : newImageUrl,
                      categoryId: getCategoryIdFromName(selectedCategory),
                      shopId: urun.shopId ?? 1,
                    );

                    if (!mounted) return;

                    Navigator.pop(dialogContext);

                    showMessage(
                      'Ürün başarıyla güncellendi.',
                      color: Colors.green,
                    );

                    refreshProducts();
                  } catch (e) {
                    if (!mounted) return;

                    showMessage(
                      e.toString().replaceFirst('Exception: ', ''),
                      color: Colors.red,
                    );
                  }
                },
                child: const Text('Kaydet'),
              ),
            ],
          );
        },
      );
    },
  );
}
}