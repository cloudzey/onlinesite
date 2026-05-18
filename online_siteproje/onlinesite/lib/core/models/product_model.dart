class ProductModel {
  final int productId; // Diyagrama göre product_id
  final String productName; // Diyagrama göre product_name
  final double price;
  final int stock; // Yeni eklenen stock alanı
  final String imageUrl; // Diyagrama göre image_url
  final String description;

  ProductModel({
    required this.productId,
    required this.productName,
    required this.price,
    required this.stock,
    required this.imageUrl,
    required this.description,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productId: json['product_id'] ?? 0,
      productName: json['product_name'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      stock: json['stock'] ?? 0,
      imageUrl: json['image_url'] ?? '',
      description: json['description'] ?? '',
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
    };
  }
}