import 'package:flutter/material.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  // Giriş Yap ekranı mı yoksa Kayıt Ol ekranı mı aktif, onu tutuyoruz
  bool isLoginView = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 1. UYGULAMA LOGO ALANI
                    const Icon(
                      Icons.shopping_bag_outlined,
                      size: 80,
                      color: Colors.deepPurple,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'TUTTUFRUTTİ',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                    ),
                    const SizedBox(height: 30),

                    // 2. GİRİŞ YAP / KAYIT OL SEKME BUTONLARI
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => setState(() => isLoginView = true),
                            child: Column(
                              children: [
                                Text(
                                  'Giriş Yap',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: isLoginView ? FontWeight.bold : FontWeight.normal,
                                    color: isLoginView ? Colors.deepPurple : Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  height: 2,
                                  color: isLoginView ? Colors.deepPurple : Colors.transparent,
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () => setState(() => isLoginView = false),
                            child: Column(
                              children: [
                                Text(
                                  'Kayıt Ol',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: !isLoginView ? FontWeight.bold : FontWeight.normal,
                                    color: !isLoginView ? Colors.deepPurple : Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  height: 2,
                                  color: !isLoginView ? Colors.deepPurple : Colors.transparent,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // 3. E-POSTA ALANI
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'E-posta Adresi',
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 4. ŞİFRE ALANI
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Şifre',
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 12),

                    if (isLoginView)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text('Şifremi Unuttum', style: TextStyle(color: Colors.grey)),
                        ),
                      ),
                    const SizedBox(height: 20),

                    // 5. ANA AKSİYON BUTONU
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/main_wrapper');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        isLoginView ? 'Giriş Yap' : 'Kayıt Ol',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}