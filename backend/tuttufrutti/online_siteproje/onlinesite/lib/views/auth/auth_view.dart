import 'package:flutter/material.dart';
import '../../core/services/api_service.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  bool isLoginView = true;
  bool isLoading = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> handleAuth() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showMessage('E-posta ve şifre boş bırakılamaz.');
      return;
    }

    if (!isLoginView) {
      final name = nameController.text.trim();
      final surname = surnameController.text.trim();

      if (name.isEmpty || surname.isEmpty) {
        showMessage('Ad ve soyad boş bırakılamaz.');
        return;
      }
    }

    setState(() {
      isLoading = true;
    });

    try {
      if (isLoginView) {
        await ApiService.login(
          email: email,
          password: password,
        );

        if (!mounted) return;

        showMessage('Giriş başarılı.');

        Navigator.pushReplacementNamed(context, '/main_wrapper');
      } else {
        await ApiService.register(
          name: nameController.text.trim(),
          surname: surnameController.text.trim(),
          email: email,
          password: password,
        );

        if (!mounted) return;

        showMessage('Kayıt başarılı. Şimdi giriş yapabilirsin.');

        setState(() {
          isLoginView = true;
        });
      }
    } catch (e) {
      showMessage(e.toString().replaceFirst('Exception: ', ''));
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
                    const Icon(
                      Icons.shopping_bag_outlined,
                      size: 80,
                      color: Colors.deepPurple,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'TUTTUFRUTTİ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 30),

                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: isLoading
                                ? null
                                : () => setState(() => isLoginView = true),
                            child: Column(
                              children: [
                                Text(
                                  'Giriş Yap',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: isLoginView
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: isLoginView
                                        ? Colors.deepPurple
                                        : Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  height: 2,
                                  color: isLoginView
                                      ? Colors.deepPurple
                                      : Colors.transparent,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: isLoading
                                ? null
                                : () => setState(() => isLoginView = false),
                            child: Column(
                              children: [
                                Text(
                                  'Kayıt Ol',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: !isLoginView
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: !isLoginView
                                        ? Colors.deepPurple
                                        : Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  height: 2,
                                  color: !isLoginView
                                      ? Colors.deepPurple
                                      : Colors.transparent,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    if (!isLoginView) ...[
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Ad',
                          prefixIcon: const Icon(Icons.person_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: surnameController,
                        decoration: InputDecoration(
                          labelText: 'Soyad',
                          prefixIcon: const Icon(Icons.person_outline),
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
                        labelText: 'E-posta Adresi',
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

                    const SizedBox(height: 12),

                    if (isLoginView)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: isLoading
    ? null
    : () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Şifre sıfırlama özelliği şu anda aktif değil.'),
            backgroundColor: Colors.grey,
          ),
        );
      },
                          child: const Text(
                            'Şifremi Unuttum',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),

                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: isLoading ? null : handleAuth,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
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
                              isLoginView ? 'Giriş Yap' : 'Kayıt Ol',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
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