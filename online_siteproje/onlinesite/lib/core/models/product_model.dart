class ProductModel {
  final int productId;
  final String productName;
  final double price;
  final int stock;
  final String imageUrl;
  final String description;
  final String category; // Yeni eklediğimiz kategori alanı

  ProductModel({
    required this.productId,
    required this.productName,
    required this.price,
    required this.stock,
    required this.imageUrl,
    required this.description,
    required this.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productId: json['product_id'] ?? 0,
      productName: json['product_name'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      stock: json['stock'] ?? 0,
      imageUrl: json['image_url'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? 'Genel',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'price': price,
      'stock': stock,
      'image_url': imageUrl,
      'description': description,
      'category': category,
    };
  }
}