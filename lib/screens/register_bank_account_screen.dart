import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/payment_methods_provider.dart';
import '../theme/design_system.dart';
import '../widgets/loading_spinner.dart';

class RegisterBankAccountScreen extends StatefulWidget {
  const RegisterBankAccountScreen({super.key});

  @override
  State<RegisterBankAccountScreen> createState() =>
      _RegisterBankAccountScreenState();
}

class _RegisterBankAccountScreenState extends State<RegisterBankAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  String _accountType = '';
  final _bankNameController = TextEditingController();
  final _branchNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _accountHolderController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _bankNameController.addListener(_updateState);
    _branchNameController.addListener(_updateState);
    _accountNumberController.addListener(_updateState);
    _accountHolderController.addListener(_updateState);
  }

  void _updateState() => setState(() {});

  @override
  void dispose() {
    _bankNameController.removeListener(_updateState);
    _branchNameController.removeListener(_updateState);
    _accountNumberController.removeListener(_updateState);
    _accountHolderController.removeListener(_updateState);
    _bankNameController.dispose();
    _branchNameController.dispose();
    _accountNumberController.dispose();
    _accountHolderController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_isBankFormValid()) return;

    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Register bank account with provider (provider now returns Future)
      await context.read<PaymentMethodsProvider>().registerBankAccount(
        bankName: _bankNameController.text,
        branchName: _branchNameController.text,
        accountNumber: _accountNumberController.text,
        accountType: _accountType,
        holderName: _accountHolderController.text,
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      // Navigate to success screen
      Navigator.of(context).pushReplacementNamed(
        '/charge-success',
        arguments: {'type': 'registration', 'message': '登録が完了しました'},
      );
    }
  }

  bool _isBankFormValid() {
    final bankName = _bankNameController.text.trim();
    final branchName = _branchNameController.text.trim();
    final accountNumber = _accountNumberController.text.trim();
    final holder = _accountHolderController.text.trim();

    final digitsOnly = accountNumber.replaceAll(RegExp(r'\D'), '');

    return bankName.isNotEmpty &&
        branchName.isNotEmpty &&
        holder.isNotEmpty &&
        digitsOnly.length >= 7 &&
        _accountType.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final bool isValid = _isBankFormValid();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          '銀行口座を登録',
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
              // Bank Name
              _buildLabel('銀行名'),
              _buildTextField(
                controller: _bankNameController,
                hint: '例.PayPay銀行',
              ),

              const SizedBox(height: 20),

              // Branch Name
              _buildLabel('支店名'),
              _buildTextField(controller: _branchNameController, hint: '例.シブヤ'),

              const SizedBox(height: 20),

              // Account Type
              _buildLabel('口座種別'),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRadioOption('普通'),
                  const SizedBox(height: 12),
                  _buildRadioOption('当座'),
                ],
              ),

              const SizedBox(height: 20),

              // Account Number
              _buildLabel('口座番号'),
              _buildTextField(
                controller: _accountNumberController,
                hint: '例.1234567',
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 20),

              // Account Holder
              _buildLabel('口座名義（カタカナ）'),
              _buildTextField(
                controller: _accountHolderController,
                hint: '例.山田 太郎',
              ),

              const SizedBox(height: 16),

              // Warning text
              Text(
                '口座名義は登録された氏名と一致している必要があります。',
                style: GoogleFonts.inter(fontSize: 12, color: Colors.white70),
              ),

              const SizedBox(height: 40),

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
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'この項目は必須です';
        }
        return null;
      },
    );
  }

  Widget _buildRadioOption(String value) {
    return GestureDetector(
      onTap: () => setState(() => _accountType = value),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: _accountType == value
                    ? AppColors.primaryBlue
                    : Colors.grey,
                width: 2,
              ),
            ),
            child: _accountType == value
                ? Center(
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
