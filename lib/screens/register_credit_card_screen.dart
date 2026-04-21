import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/payment_methods_provider.dart';
import '../theme/design_system.dart';
import '../widgets/loading_spinner.dart';

class RegisterCreditCardScreen extends StatefulWidget {
  const RegisterCreditCardScreen({super.key});

  @override
  State<RegisterCreditCardScreen> createState() =>
      _RegisterCreditCardScreenState();
}

class _RegisterCreditCardScreenState extends State<RegisterCreditCardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _cardNumberController.addListener(_updateState);
    _expiryController.addListener(_updateState);
    _cvvController.addListener(_updateState);
    _cardHolderController.addListener(_updateState);
  }

  @override
  void dispose() {
    _cardNumberController.removeListener(_updateState);
    _expiryController.removeListener(_updateState);
    _cvvController.removeListener(_updateState);
    _cardHolderController.removeListener(_updateState);
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _cardHolderController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      // validate expiry format again and normalize
      final expiryRaw = _expiryController.text.trim();
      if (!_isExpiryValid(expiryRaw)) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('有効期限の形式が正しくありません')));
        return;
      }
      final normalizedExpiry = _normalizeExpiry(expiryRaw);
      // Register credit card with provider
      context.read<PaymentMethodsProvider>().registerCreditCard(
        cardNumber: _cardNumberController.text,
        expiry: normalizedExpiry,
        holderName: _cardHolderController.text,
      );

      // Navigate directly to success screen
      Navigator.of(context).pushReplacementNamed(
        '/charge-success',
        arguments: {'type': 'registration', 'message': '登録が完了しました'},
      );
    }
  }

  void _updateState() => setState(() {});

  bool _isCardFormValid() {
    final card = _cardNumberController.text.trim();
    final expiry = _expiryController.text.trim();
    final cvv = _cvvController.text.trim();
    final holder = _cardHolderController.text.trim();

    final digitsOnlyCard = card.replaceAll(RegExp(r'\D'), '');
    final cardValid =
        digitsOnlyCard.length == 15 || digitsOnlyCard.length == 16;
    final cvvValid = cvv.length >= 3 && cvv.length <= 4;
    final expiryValid = _isExpiryValid(expiry);
    final holderValid = holder.isNotEmpty;
    return cardValid && cvvValid && expiryValid && holderValid;
  }

  bool _isExpiryValid(String input) {
    final m = RegExp(r'^\s*(\d{1,2})/(\d{2}|\d{4})\s*$').firstMatch(input);
    if (m == null) return false;
    final month = int.tryParse(m.group(1)!) ?? 0;
    if (month < 1 || month > 12) return false;
    var year = int.tryParse(m.group(2)!) ?? 0;
    if (m.group(2)!.length == 2) year += 2000;
    final expiryMoment = DateTime(year, month + 1, 1);
    return expiryMoment.isAfter(DateTime.now());
  }

  String _normalizeExpiry(String input) {
    final m = RegExp(r'^\s*(\d{1,2})/(\d{2}|\d{4})\s*$').firstMatch(input);
    if (m == null) return input;
    final month = int.parse(m.group(1)!).toString().padLeft(2, '0');
    var year = int.parse(m.group(2)!);
    if (m.group(2)!.length == 2) year += 2000;
    return '$month/${year.toString().padLeft(4, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final bool isValid = _isCardFormValid();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'クレジットカードを登録',
          style: GoogleFonts.inter(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primaryBlue),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card Number
              _buildLabel('カード番号'),
              _buildTextField(
                controller: _cardNumberController,
                hint: '例.123XXXXXXXXXXXXX',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                ],
              ),

              const SizedBox(height: 20),

              // Expiry and CVV row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('有効期限'),
                        _buildTextField(
                          controller: _expiryController,
                          hint: '例.01/2028',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'\d|/')),
                            LengthLimitingTextInputFormatter(7),
                            ExpiryInputFormatter(),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'この項目は必須です';
                            }
                            if (!_isExpiryValid(value.trim())) {
                              return '有効期限が無効です';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('CVV'),
                        _buildTextField(
                          controller: _cvvController,
                          hint: '例.000',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                          ],
                          obscure: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Card Holder Name
              _buildLabel('クレジットカードの名義人氏名'),
              _buildTextField(
                controller: _cardHolderController,
                hint: '例.TARO YAMADA',
              ),

              const SizedBox(height: 24),

              // Warning text
              Text(
                'お支払いには3Dセキュア認証が必要です',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 60),

              // Save button
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
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: (isValid && !_isLoading) ? _save : null,
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
                            '保存',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isValid ? Colors.white : Colors.white24,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 14,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    bool obscure = false,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      obscureText: obscure,
      style: GoogleFonts.inter(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFF0D1B2A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primaryBlue),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      validator:
          validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'この項目は必須です';
            }
            return null;
          },
    );
  }
}

class ExpiryInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text;
    // keep only digits
    final digitsOnly = text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.length <= 2) {
      return TextEditingValue(
        text: digitsOnly,
        selection: TextSelection.collapsed(offset: digitsOnly.length),
      );
    }
    final month = digitsOnly.substring(0, 2);
    var rest = '';
    if (digitsOnly.length > 2) rest = digitsOnly.substring(2);
    var formatted = '$month/$rest';
    if (formatted.length > 7) formatted = formatted.substring(0, 7);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
