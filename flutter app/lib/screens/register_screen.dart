import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/design_system.dart';
import '../widgets/loading_spinner.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _furiganaController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_updateState);
    _furiganaController.addListener(_updateState);
    _phoneController.addListener(_updateState);
    _emailController.addListener(_updateState);
    _passwordController.addListener(_updateState);
  }

  void _updateState() => setState(() {});

  @override
  void dispose() {
    _nameController.removeListener(_updateState);
    _furiganaController.removeListener(_updateState);
    _phoneController.removeListener(_updateState);
    _emailController.removeListener(_updateState);
    _passwordController.removeListener(_updateState);
    _nameController.dispose();
    _furiganaController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String get _phoneDigits => _phoneController.text.replaceAll('-', '');

  bool get _hasValidPhoneLength =>
      RegExp(r'^\d{10,11}$').hasMatch(_phoneDigits);

  bool get _hasLetter => RegExp(r'[a-zA-Z]').hasMatch(_passwordController.text);

  bool get _hasNumber => RegExp(r'[0-9]').hasMatch(_passwordController.text);

  bool get _hasSymbol =>
      RegExp(r'[!-/:-@[-`{-~]').hasMatch(_passwordController.text);

  bool get _isPasswordValid =>
      _passwordController.text.length >= 8 &&
      _hasLetter &&
      _hasNumber &&
      _hasSymbol;

  String _formatPhoneNumber(String digits) {
    if (digits.length <= 3) return digits;

    final isTokyoOrOsaka = digits.startsWith('03') || digits.startsWith('06');

    if (digits.length <= 10) {
      if (isTokyoOrOsaka) {
        if (digits.length <= 6) {
          return '${digits.substring(0, 2)}-${digits.substring(2)}';
        }
        return '${digits.substring(0, 2)}-${digits.substring(2, 6)}-${digits.substring(6)}';
      }
      if (digits.length <= 6) {
        return '${digits.substring(0, 3)}-${digits.substring(3)}';
      }
      return '${digits.substring(0, 3)}-${digits.substring(3, 6)}-${digits.substring(6)}';
    }

    if (digits.length <= 7) {
      return '${digits.substring(0, 3)}-${digits.substring(3)}';
    }
    return '${digits.substring(0, 3)}-${digits.substring(3, 7)}-${digits.substring(7)}';
  }

  void _onPhoneChanged(String value) {
    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
    final trimmed = digits.length > 11 ? digits.substring(0, 11) : digits;
    final formatted = _formatPhoneNumber(trimmed);

    if (formatted != value) {
      _phoneController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }

  bool _isFormValid() {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return _nameController.text.isNotEmpty &&
        _furiganaController.text.isNotEmpty &&
        _hasValidPhoneLength &&
        emailRegex.hasMatch(_emailController.text) &&
        _isPasswordValid;
  }

  Future<void> _handleRegister() async {
    setState(() => _isLoading = true);
    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.register(
      _emailController.text,
      _passwordController.text,
      _passwordController.text,
      _nameController.text,
      _furiganaController.text,
      _phoneDigits,
    );

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        Navigator.of(context).pushReplacementNamed('/otp');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isValid = _isFormValid();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.primaryBlue,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            Center(child: Image.asset('assets/icons/fts_logo.png', height: 90)),
            const SizedBox(height: 16),
            Text(
              '登録',
              style: GoogleFonts.inter(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryBlue,
              ),
            ),
            const SizedBox(height: 32),
            _buildLabel('氏名'),
            _buildTextField(controller: _nameController, hintText: '例.山田 太郎'),
            const SizedBox(height: 16),
            _buildLabel('フリガナ（カタカナ）'),
            _buildTextField(
              controller: _furiganaController,
              hintText: '例.ヤマダ タロウ',
            ),
            const SizedBox(height: 16),
            _buildLabel('電話番号'),
            _buildTextField(
              controller: _phoneController,
              hintText: '例.03-1234-5678',
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9-]')),
                LengthLimitingTextInputFormatter(13),
              ],
              onChanged: _onPhoneChanged,
            ),
            const SizedBox(height: 16),
            _buildLabel('メール'),
            Text(
              '※ キャリアメール（携帯電話会社が提供するメールアドレス）は、通知が届かない場合があります。\nGmailなどのフリーメールアドレスの利用を推奨します。',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 10,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _emailController,
              hintText: '例.example@gmail.com',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            _buildLabel('パスワード'),
            _buildTextField(
              controller: _passwordController,
              hintText: '例.ab@12',
              obscureText: true,
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '8文字以上 / 英字・数字・記号を各1文字以上（大文字・小文字を区別）',
                style: GoogleFonts.inter(color: Colors.grey[500], fontSize: 10),
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: SizedBox(
                width: 287,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isValid
                        ? AppColors.primaryBlue
                        : const Color(0xFF2C2C2E),
                    disabledBackgroundColor: const Color(0xFF2C2C2E),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        12,
                      ), // Fixed: Now more rectangular
                    ),
                    elevation: 0,
                  ),
                  onPressed: (isValid && !_isLoading) ? _handleRegister : null,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: LoadingSpinner(
                            size: 20,
                            dotRadius: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          '登録',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isValid ? Colors.white : Colors.white24,
                          ),
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

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(
          text,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    ValueChanged<String>? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      style: GoogleFonts.inter(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.inter(color: Colors.grey[600]),
        filled: true,
        fillColor: const Color(0xFF151D27),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.primaryBlue,
            width: 1.5,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}
