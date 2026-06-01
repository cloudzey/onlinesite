import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/product_model.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:5000';

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  static Future<Map<String, String>> authHeaders() async {
    final token = await getToken();

    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<List<ProductModel>> getProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/api/products'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => ProductModel.fromJson(item)).toList();
    } else {
      throw Exception('Ürünler getirilemedi');
    }
  }

  static Future<List<dynamic>> getCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/api/categories'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Kategoriler getirilemedi');
    }
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      await saveToken(data['token']);
      return data;
    } else {
      throw Exception(data['message'] ?? 'Giriş başarısız');
    }
  }

  static Future<Map<String, dynamic>> register({
    required String name,
    required String surname,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'surname': surname,
        'email': email,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return data;
    } else {
      throw Exception(data['message'] ?? 'Kayıt başarısız');
    }
  }

  static Future<Map<String, dynamic>> getProfile() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/auth/profile'),
      headers: await authHeaders(),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    } else {
      throw Exception(data['message'] ?? 'Profil getirilemedi');
    }
  }

  static Future<Map<String, dynamic>> getCart() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/cart'),
      headers: await authHeaders(),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    } else {
      throw Exception(data['message'] ?? 'Sepet getirilemedi');
    }
  }

  static Future<Map<String, dynamic>> addToCart({
    required int productId,
    int quantity = 1,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/cart/add'),
      headers: await authHeaders(),
      body: jsonEncode({
        'product_id': productId,
        'quantity': quantity,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201 || response.statusCode == 200) {
      return data;
    } else {
      throw Exception(data['message'] ?? 'Ürün sepete eklenemedi');
    }
  }

  static Future<Map<String, dynamic>> updateCartItem({
    required int productId,
    required int quantity,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/cart/update'),
      headers: await authHeaders(),
      body: jsonEncode({
        'product_id': productId,
        'quantity': quantity,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    } else {
      throw Exception(data['message'] ?? 'Sepet güncellenemedi');
    }
  }

  static Future<Map<String, dynamic>> removeFromCart({
    required int productId,
  }) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/cart/remove/$productId'),
      headers: await authHeaders(),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    } else {
      throw Exception(data['message'] ?? 'Ürün sepetten silinemedi');
    }
  }

  static Future<Map<String, dynamic>> clearCart() async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/cart/clear'),
      headers: await authHeaders(),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    } else {
      throw Exception(data['message'] ?? 'Sepet temizlenemedi');
    }
  }

  static Future<Map<String, dynamic>> createOrder() async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/orders/create'),
      headers: await authHeaders(),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return data;
    } else {
      throw Exception(data['message'] ?? 'Sipariş oluşturulamadı');
    }
  }

  static Future<List<dynamic>> getOrders() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/orders'),
      headers: await authHeaders(),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    } else {
      throw Exception(data['message'] ?? 'Siparişler getirilemedi');
    }
  }

  static Future<Map<String, dynamic>> getOrderDetail({
    required int orderId,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/orders/$orderId'),
      headers: await authHeaders(),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    } else {
      throw Exception(data['message'] ?? 'Sipariş detayı getirilemedi');
    }
  }
}