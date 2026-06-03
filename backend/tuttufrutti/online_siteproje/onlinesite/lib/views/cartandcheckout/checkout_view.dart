import 'package:flutter/material.dart';
import '../../core/services/api_service.dart';
import '../orders/orders_view.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  late Future<Map<String, dynamic>> cartFuture;
  bool isCreatingOrder = false;

  final TextEditingController cardNameController = TextEditingController();
final TextEditingController cardNumberController = TextEditingController();
final TextEditingController expiryDateController = TextEditingController();
final TextEditingController cvvController = TextEditingController();

final TextEditingController addressTitleController = TextEditingController();
final TextEditingController cityController = TextEditingController();
final TextEditingController districtController = TextEditingController();
final TextEditingController fullAddressController = TextEditingController();
final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    cartFuture = ApiService.getCart();
  }

  @override
void dispose() {
  cardNameController.dispose();
  cardNumberController.dispose();
  expiryDateController.dispose();
  cvvController.dispose();
  addressTitleController.dispose();
cityController.dispose();
districtController.dispose();
fullAddressController.dispose();
phoneController.dispose();
  super.dispose();
}

  void refreshCart() {
    setState(() {
      cartFuture = ApiService.getCart();
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

  bool validateAddressForm() {
  final addressTitle = addressTitleController.text.trim();
  final city = cityController.text.trim();
  final district = districtController.text.trim();
  final fullAddress = fullAddressController.text.trim();
  final phone = phoneController.text.trim();

  if (addressTitle.isEmpty) {
    showMessage('Adres başlığı boş bırakılamaz.', color: Colors.red);
    return false;
  }

  if (city.isEmpty) {
    showMessage('Şehir boş bırakılamaz.', color: Colors.red);
    return false;
  }

  if (district.isEmpty) {
    showMessage('İlçe boş bırakılamaz.', color: Colors.red);
    return false;
  }

  if (fullAddress.isEmpty || fullAddress.length < 10) {
    showMessage('Açık adres en az 10 karakter olmalı.', color: Colors.red);
    return false;
  }

  final cleanPhone = phone.replaceAll(' ', '');

  if (cleanPhone.isEmpty) {
    showMessage('Telefon numarası boş bırakılamaz.', color: Colors.red);
    return false;
  }

  if (!RegExp(r'^[0-9]{10,11}$').hasMatch(cleanPhone)) {
    showMessage('Telefon numarası 10 veya 11 haneli olmalı.', color: Colors.red);
    return false;
  }

  return true;
}

  bool validatePaymentForm() {
  final cardName = cardNameController.text.trim();
  final cardNumber = cardNumberController.text.replaceAll(' ', '').trim();
  final expiryDate = expiryDateController.text.trim();
  final cvv = cvvController.text.trim();

  if (cardName.isEmpty) {
    showMessage('Kart üzerindeki isim boş bırakılamaz.', color: Colors.red);
    return false;
  }

  if (cardName.length < 3) {
    showMessage('Kart üzerindeki isim en az 3 karakter olmalı.', color: Colors.red);
    return false;
  }

  if (cardNumber.isEmpty) {
    showMessage('Kart numarası boş bırakılamaz.', color: Colors.red);
    return false;
  }

  if (!RegExp(r'^[0-9]{16}$').hasMatch(cardNumber)) {
    showMessage('Kart numarası 16 haneli olmalı ve sadece rakam içermeli.', color: Colors.red);
    return false;
  }

  if (expiryDate.isEmpty) {
    showMessage('Son kullanma tarihi boş bırakılamaz.', color: Colors.red);
    return false;
  }

  if (!RegExp(r'^(0[1-9]|1[0-2])\/[0-9]{2}$').hasMatch(expiryDate)) {
    showMessage('Son kullanma tarihi AA/YY formatında olmalı. Örn: 12/26', color: Colors.red);
    return false;
  }

  final parts = expiryDate.split('/');
  final month = int.parse(parts[0]);
  final year = int.parse('20${parts[1]}');

  final now = DateTime.now();
  final expiry = DateTime(year, month + 1, 0);

  if (expiry.isBefore(DateTime(now.year, now.month, 1))) {
    showMessage('Kartın son kullanma tarihi geçmiş olamaz.', color: Colors.red);
    return false;
  }

  if (cvv.isEmpty) {
    showMessage('CVV boş bırakılamaz.', color: Colors.red);
    return false;
  }

  if (!RegExp(r'^[0-9]{3}$').hasMatch(cvv)) {
    showMessage('CVV 3 haneli olmalı ve sadece rakam içermeli.', color: Colors.red);
    return false;
  }

  return true;
}

 Future<void> completeOrder() async {
  if (!validateAddressForm()) {
    return;
  }

  if (!validatePaymentForm()) {
    return;
  }

  setState(() {
    isCreatingOrder = true;
  });

    try {
      await ApiService.createOrder();

      if (!mounted) return;

      showMessage('Ödeme başarılı! Siparişiniz alındı. 🎉');

      cardNameController.clear();
      cardNumberController.clear();
      expiryDateController.clear();
      cvvController.clear();

      addressTitleController.clear();
      cityController.clear();
      districtController.clear();
      fullAddressController.clear();
      phoneController.clear();

      refreshCart();
    } catch (e) {
      if (!mounted) return;

      showMessage(
        e.toString().replaceFirst('Exception: ', ''),
        color: Colors.red,
      );
    } finally {
      if (mounted) {
        setState(() {
          isCreatingOrder = false;
        });
      }
    }
  }

  double calculateTotal(List<dynamic> items) {
    double total = 0;

    for (final item in items) {
      final price = double.tryParse(item['price'].toString()) ?? 0;
      final quantity = int.tryParse(item['quantity'].toString()) ?? 0;
      total += price * quantity;
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sepetim & Ödeme'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Sepeti Yenile',
            onPressed: refreshCart,
          ),
          IconButton(
            icon: const Icon(Icons.receipt_long_outlined),
            tooltip: 'Siparişlerim',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OrdersView()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: cartFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.deepPurple),
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

            final cartData = snapshot.data;
            final List<dynamic> items = cartData?['items'] ?? [];

            if (items.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Sepetiniz şu anda boş.',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
              );
            }

            final toplamTutar = calculateTotal(items);

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sepetteki Ürünler',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),

                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _buildCartItem(items[index]),
                        );
                      },
                    ),

                    const SizedBox(height: 25),

                    const Text(
  'Teslimat Adresi',
  style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
),
const SizedBox(height: 15),

TextField(
  controller: addressTitleController,
  decoration: InputDecoration(
    labelText: 'Adres Başlığı',
    hintText: 'Ev, Yurt, İş...',
    prefixIcon: const Icon(Icons.bookmark_border),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
),
const SizedBox(height: 12),

Row(
  children: [
    Expanded(
      child: TextField(
        controller: cityController,
        decoration: InputDecoration(
          labelText: 'Şehir',
          prefixIcon: const Icon(Icons.location_city),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    ),
    const SizedBox(width: 12),
    Expanded(
      child: TextField(
        controller: districtController,
        decoration: InputDecoration(
          labelText: 'İlçe',
          prefixIcon: const Icon(Icons.map_outlined),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    ),
  ],
),

const SizedBox(height: 12),

TextField(
  controller: fullAddressController,
  maxLines: 3,
  decoration: InputDecoration(
    labelText: 'Açık Adres',
    hintText: 'Mahalle, sokak, bina no, daire no...',
    prefixIcon: const Icon(Icons.home_outlined),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
),

const SizedBox(height: 12),

TextField(
  controller: phoneController,
  keyboardType: TextInputType.phone,
  maxLength: 11,
  decoration: InputDecoration(
    counterText: '',
    labelText: 'Telefon Numarası',
    hintText: '05XXXXXXXXX',
    prefixIcon: const Icon(Icons.phone_outlined),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
),

const SizedBox(height: 30),

                    const Text(
                      'Kart Bilgileri ile Ödeme',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),

                    TextField(
                      controller: cardNameController,
                      decoration: InputDecoration(
                        labelText: 'Kart Üzerindeki İsim',
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    TextField(
                    controller: cardNumberController,
                    keyboardType: TextInputType.number,
                    maxLength: 16,
                    decoration: InputDecoration(
                    counterText: '',
                    labelText: 'Kart Numarası',
                        prefixIcon: const Icon(Icons.credit_card),
                        hintText: '0000 0000 0000 0000',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: TextField(
  controller: expiryDateController,
  keyboardType: TextInputType.text,
  maxLength: 5,
  decoration: InputDecoration(
    counterText: '',
    labelText: 'Son Kul. Tarihi',
                              hintText: 'AA/YY',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
  controller: cvvController,
  keyboardType: TextInputType.number,
  obscureText: true,
  maxLength: 3,
  decoration: InputDecoration(
    counterText: '',
    labelText: 'CVV',
                              hintText: '123',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Toplam Tutar:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '${toplamTutar.toStringAsFixed(0)} TL',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: isCreatingOrder ? null : completeOrder,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: isCreatingOrder
                                  ? const SizedBox(
                                      height: 22,
                                      width: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      'Ödemeyi Yap ve Siparişi Tamamla',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCartItem(Map<String, dynamic> item) {
  final productName = item['product_name']?.toString() ?? 'Ürün';
  final imageUrl = item['image_url']?.toString() ?? '';
  final quantity = item['quantity']?.toString() ?? '1';
  final price = double.tryParse(item['price'].toString()) ?? 0;
  final quantityNumber = int.tryParse(quantity) ?? 1;
  final cartItemId = int.tryParse(item['cart_item_id'].toString()) ?? 0;

  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey[200]!),
    ),
    child: Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.image, color: Colors.grey);
              },
            ),
          ),
        ),
        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                productName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    color: Colors.deepPurple,
                    onPressed: quantityNumber <= 1
                        ? null
                        : () async {
                            await ApiService.decreaseCartItem(cartItemId);
                            refreshCart();
                          },
                  ),
                  Text(
                    quantityNumber.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    color: Colors.deepPurple,
                    onPressed: () async {
                      await ApiService.increaseCartItem(cartItemId);
                      refreshCart();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    color: Colors.red,
                    onPressed: () async {
                      await ApiService.removeCartItem(cartItemId);
                      refreshCart();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),

        Text(
          '${(price * quantityNumber).toStringAsFixed(0)} TL',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
      ],
    ),
  );
}
}