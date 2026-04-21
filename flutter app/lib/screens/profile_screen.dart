import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/design_system.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const String _passwordPlaceholder = '********';

  // Mock editing controllers
  final _nameController = TextEditingController(text: '山田 太郎');
  final _kanaController = TextEditingController(text: 'ヤマダ タロウ');
  final _phoneController = TextEditingController(text: '+81000000');
  final _emailController = TextEditingController(text: 'abc@gmail.com');
  final _passwordController = TextEditingController(text: _passwordPlaceholder);

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    if (user == null) return;
    _nameController.text = (user.name?.isNotEmpty ?? false)
        ? user.name!
        : _nameController.text;
    _kanaController.text = (user.furigana?.isNotEmpty ?? false)
        ? user.furigana!
        : _kanaController.text;
    _phoneController.text = (user.phoneNumber?.isNotEmpty ?? false)
        ? user.phoneNumber!
        : _phoneController.text;
    _emailController.text = user.email;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _kanaController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('プロフィール', style: AppTextStyles.headlineMedium),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primaryBlue),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Image with Edit Icon
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[300],
                  child: const Icon(Icons.person, size: 60, color: Colors.grey),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.surfaceLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            _buildField('企業名 / 屋号 (漢字)', _nameController),
            _buildField('フリガナ (カタカナ)', _kanaController),
            _buildField('電話番号', _phoneController),
            _buildField('メール', _emailController),
            _buildField('パスワード', _passwordController, obscure: true),

            const SizedBox(height: 30),

            Center(
              child: SizedBox(
                width: 287,
                height: 60,
                child: ElevatedButton(
                  onPressed: _onSavePressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '保存',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Future<void> _onSavePressed() async {
    final authProvider = context.read<AuthProvider>();
    final passwordInput = _passwordController.text.trim();
    final shouldChangePassword =
        passwordInput.isNotEmpty && passwordInput != _passwordPlaceholder;

    final profileSaved = await authProvider.updateProfile(
      name: _nameController.text.trim(),
      furigana: _kanaController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      email: _emailController.text.trim(),
    );

    if (!mounted) return;

    if (!profileSaved) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('保存に失敗しました')));
      return;
    }

    if (shouldChangePassword) {
      Navigator.of(context, rootNavigator: true).pushNamed(
        '/biometric-auth',
        arguments: {
          'purpose': 'password_reset',
          'email': _emailController.text.trim(),
          'resetSource': 'profile',
        },
      );
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('保存しました')));
  }

  Widget _buildField(
    String label,
    TextEditingController controller, {
    bool obscure = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            obscureText: obscure,
            style: const TextStyle(
              color: Colors.grey,
            ), // Grey text implies read-only/default style
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF0D1B2A),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
