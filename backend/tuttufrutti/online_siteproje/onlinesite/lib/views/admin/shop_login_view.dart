import 'package:flutter/material.dart';
import '../../core/services/api_service.dart';

class ShopLoginView extends StatefulWidget {
  const ShopLoginView({super.key});

  @override
  State<ShopLoginView> createState() => _ShopLoginViewState();
}

class _ShopLoginViewState extends State<ShopLoginView> {
  bool isLoginView = true;
  bool isLoading = false;

  final TextEditingController shopNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    shopNameController.dispose();
    descriptionController.dispose();
    emailController.dispose();
    passwordController.dispose();
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

  Future<void> handleShopAuth() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showMessage('E-posta ve şifre boş bırakılamaz.');
      return;
    }

    if (password.length < 6) {
      showMessage('Şifre en az 6 karakter olmalı.');
      return;
    }

    if (!isLoginView) {
      if (shopNameController.text.trim().isEmpty) {
        showMessage('Mağaza adı boş bırakılamaz.');
        return;
      }
    }

    setState(() {
      isLoading = true;
    });

    try {
      if (isLoginView) {
        await ApiService.shopLogin(
          email: email,
          password: password,
        );

        if (!mounted) return;

        showMessage(
          'Mağaza girişi başarılı.',
          color: Colors.green,
        );
      } else {
        await ApiService.shopRegister(
          shopName: shopNameController.text.trim(),
          description: descriptionController.text.trim().isEmpty
              ? 'Yeni mağaza'
              : descriptionController.text.trim(),
          email: email,
          password: password,
        );

        if (!mounted) return;

        showMessage(
          'Mağaza kaydı başarılı.',
          color: Colors.green,
        );
      }

      Navigator.pushReplacementNamed(context, '/admin');
    } catch (e) {
      if (!mounted) return;

      showMessage(
        e.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Widget buildTabButton(String text, bool selected, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: isLoading ? null : onTap,
        child: Column(
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                color: selected ? Colors.amber[800] : Colors.grey,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              height: 2,
              color: selected ? Colors.amber[800] : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      appBar: AppBar(
        title: const Text('Mağaza Paneli'),
        backgroundColor: Colors.amber[700],
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons.storefront,
                  size: 80,
                  color: Colors.amber[700],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Satıcı Paneli',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 28),

                Row(
                  children: [
                    buildTabButton(
                      'Giriş Yap',
                      isLoginView,
                      () => setState(() => isLoginView = true),
                    ),
                    buildTabButton(
                      'Mağaza Kaydı',
                      !isLoginView,
                      () => setState(() => isLoginView = false),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                if (!isLoginView) ...[
                  TextField(
                    controller: shopNameController,
                    decoration: InputDecoration(
                      labelText: 'Mağaza Adı',
                      prefixIcon: const Icon(Icons.store),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Mağaza Açıklaması',
                      prefixIcon: const Icon(Icons.description),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Mağaza E-posta',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Şifre',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: isLoading ? null : handleShopAuth,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
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
                      : Text(
                          isLoginView
                              ? 'Mağaza Girişi Yap'
                              : 'Mağaza Kaydı Oluştur',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),

                const SizedBox(height: 16),

                if (isLoginView)
                  const Text(
                    'Test hesapları:\ntech@shop.com / 123456\nstyle@shop.com / 123456',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}