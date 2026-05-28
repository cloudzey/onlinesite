class ProductModel {
  final int productId;
  final String productName;
  final String description;
  final double price;
  final int stock;
  final String imageUrl;

  // Eski Flutter kodlarının kullandığı alan
  final String category;

  // Backend'den gelen ek alanlar
  final int? categoryId;
  final int? shopId;
  final String? categoryName;
  final String? shopName;

  ProductModel({
    required this.productId,
    required this.productName,
    required this.description,
    required this.price,
    required this.stock,
    required this.imageUrl,
    required this.category,
    this.categoryId,
    this.shopId,
    this.categoryName,
    this.shopName,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productId: json['product_id'] ?? 0,
      productName: json['product_name'] ?? '',
      description: json['description'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      stock: json['stock'] ?? 0,
      imageUrl: json['image_url'] ?? '',
      category: json['category_name'] ?? '',
      categoryId: json['category_id'],
      shopId: json['shop_id'],
      categoryName: json['category_name'],
      shopName: json['shop_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'description': description,
      'price': price,
      'stock': stock,
      'image_url': imageUrl,
      'category': category,
      'category_id': categoryId,
      'shop_id': shopId,
      'category_name': categoryName,
      'shop_name': shopName,
    };
  }
}