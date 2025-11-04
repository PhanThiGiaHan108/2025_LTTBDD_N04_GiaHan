import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dang_ky.dart';
import 'trang_chu.dart';

class DangNhap extends StatefulWidget {
  const DangNhap({super.key});

  @override
  State<DangNhap> createState() => _DangNhapState();
}

class _DangNhapState extends State<DangNhap> {
  // 🎯 Controller để lấy giá trị từ TextField
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // 👁️ Biến để ẩn/hiện mật khẩu
  bool _obscurePassword = true;

  // 🧩 Hàm đăng nhập (tài khoản cứng)
  void _login() {
    // Logging (debug)
    const demoEmail = "demo@gmail.com";
    const demoPassword = "123456";

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('please_fill_info'.tr())));
      return;
    }

    if (email == demoEmail && password == demoPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('login_success'.tr())));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const TrangChu()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('wrong_credentials'.tr())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDE5),
      body: Stack(
        children: [
          // 🌤️ Decorative yellow shapes (top-right)
          Positioned(
            top: -40,
            right: -40,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFF3C4), Color(0xFFFFE082)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(2, 6),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            top: 30,
            right: 40,
            child: Container(
              width: 100,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7D9),
                borderRadius: BorderRadius.circular(32),
              ),
            ),
          ),

          // ☁️ Decorative bottom band
          Positioned(
            bottom: -20,
            left: -40,
            right: -40,
            child: Container(
              height: 160,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFFF7D9),
                    Color.fromARGB(255, 253, 255, 201),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(120),
                  topRight: Radius.circular(120),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
            ),
          ),

          // 🌸 Nội dung đăng nhập
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 🐥 Logo vịt
                    Image.asset('imgs/logo2.png', width: 120),

                    // 📄 Form đăng nhập bo góc
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 30,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            offset: const Offset(3, 4),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildInput(
                            'email_hint'.tr(),
                            controller: emailController,
                          ),
                          const SizedBox(height: 15),
                          _buildPasswordInput(
                            'password_hint'.tr(),
                            controller: passwordController,
                          ),
                          const SizedBox(height: 25),

                          // 🔑 Nút đăng nhập chính
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF9C27B0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 4,
                              minimumSize: const Size(double.infinity, 55),
                            ),
                            onPressed: _login,
                            child: Text(
                              'login'.tr(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => const DangKy(),
                                ),
                              );
                            },
                            child: Text(
                              'no_account_yet'.tr(),
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // 🌐 Đăng nhập Google
                          _buildSocialButton(
                            icon: Icons.g_mobiledata,
                            text: 'login_with_google'.tr(),
                            iconColor: Colors.redAccent,
                          ),
                          const SizedBox(height: 15),

                          // 💙 Đăng nhập Facebook
                          _buildSocialButton(
                            icon: Icons.facebook,
                            text: 'login_with_facebook'.tr(),
                            iconColor: Colors.blueAccent,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 🔗 Quên mật khẩu (styled button)
                    TextButton.icon(
                      onPressed: () {
                        _showForgotPasswordDialog();
                      },
                      icon: const Icon(
                        Icons.lock_outline,
                        color: Color(0xFF9C27B0),
                      ),
                      label: Text(
                        'forgot_password'.tr(),
                        style: const TextStyle(
                          color: Color(0xFF9C27B0),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFFFF9E6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        foregroundColor: const Color(0xFF9C27B0),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'forgot_password_note'.tr(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInput(
    String hint, {
    bool obscure = false,
    TextEditingController? controller,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        hintStyle: const TextStyle(color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.grey, width: 0.6),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFF9C27B0), width: 1.5),
        ),
      ),
    );
  }

  // 🔐 Widget mật khẩu với nút ẩn/hiện
  Widget _buildPasswordInput(String hint, {TextEditingController? controller}) {
    return TextField(
      controller: controller,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        hintStyle: const TextStyle(color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.grey, width: 0.6),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFF9C27B0), width: 1.5),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
      ),
    );
  }

  // 💬 Dialog quên mật khẩu
  void _showForgotPasswordDialog() {
    final TextEditingController forgotEmailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              const Icon(Icons.lock_reset, color: Color(0xFF9C27B0)),
              const SizedBox(width: 10),
              Text(
                'forgot_password'.tr(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'forgot_password_instruction'.tr(),
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: forgotEmailController,
                decoration: InputDecoration(
                  hintText: 'email_hint'.tr(),
                  prefixIcon: const Icon(Icons.email, color: Color(0xFF9C27B0)),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: Color(0xFF9C27B0),
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'cancel'.tr(),
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9C27B0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              onPressed: () {
                final email = forgotEmailController.text.trim();
                if (email.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('please_enter_email'.tr())),
                  );
                  return;
                }

                // Simulate sending reset email
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('reset_password_sent'.tr()),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Text(
                'send'.tr(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String text,
    required Color iconColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            offset: const Offset(2, 4),
            blurRadius: 6,
          ),
        ],
      ),
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          minimumSize: const Size(double.infinity, 55),
        ),
        onPressed: () {},
        icon: Icon(icon, color: iconColor, size: 28),
        label: Text(
          text,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
