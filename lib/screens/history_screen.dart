import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/design_system.dart';
import '../widgets/loading_spinner.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool _isLoading = false;
  bool _hasError = false;
  bool _isBalanceVisible = false;
  List<Transaction>? _transactions;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isLoading = false;
        _transactions = _getSampleTransactions();
      });
    }
  }

  List<Transaction> _getSampleTransactions() {
    return [
      Transaction(
        date: '2025/12/01',
        type: 'チャージ',
        amount: 10000,
        isCredit: true,
      ),
      Transaction(
        date: '2025/12/02',
        type: '決済',
        amount: 10000,
        isCredit: false,
      ),
      Transaction(
        date: '2025/12/03',
        type: 'チャージ',
        amount: 1000,
        isCredit: true,
      ),
      Transaction(
        date: '2025/12/04',
        type: '決済',
        amount: 1000,
        isCredit: false,
      ),
      Transaction(
        date: '2025/12/04',
        type: '決済',
        amount: 1000,
        isCredit: false,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          '取引履歴',
          style: GoogleFonts.inter(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.primaryBlue,
                  size: 20,
                ),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: LoadingSpinner());
    }

    if (_hasError) {
      return _buildErrorState();
    }

    if (_transactions == null || _transactions!.isEmpty) {
      return _buildEmptyState();
    }

    return _buildHistoryContent();
  }

  Widget _buildHistoryContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          // Balance summary section
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '現在の残高',
                style: GoogleFonts.inter(color: Colors.grey[500], fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Balance card
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF0D1B2A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isBalanceVisible
                    ? AppColors.primaryBlue.withValues(alpha: 0.5)
                    : AppColors.border,
              ),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () => setState(
                        () => _isBalanceVisible = !_isBalanceVisible,
                      ),
                      child: Icon(
                        _isBalanceVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.primaryBlue,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 20,
                    ),
                    child: Text(
                      _isBalanceVisible ? '10,000 P' : '****** P',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Transaction table
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: Column(
                children: [
                  // Header row (match full-history style)
                  Container(
                    height: 44,
                    color: const Color(0xFF0D1B2A),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 22,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Text(
                              '日付',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Container(width: 1, color: AppColors.border),
                        Expanded(
                          flex: 16,
                          child: Center(
                            child: Text(
                              '種別',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Container(width: 1, color: AppColors.border),
                        Expanded(
                          flex: 22,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Text(
                              'ポイント',
                              textAlign: TextAlign.right,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Transaction rows
                  ...?_transactions?.map((tx) => _buildTransactionRow(tx)),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Full history link
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pushNamed('/full-history'),
              child: Text(
                '全履歴表示',
                style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Expiring points notice
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF0D1B2A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: GoogleFonts.inter(fontSize: 13),
                children: const [
                  TextSpan(
                    text: '月末失効ポイント：',
                    style: TextStyle(color: Colors.white),
                  ),
                  TextSpan(
                    text: '0P',
                    style: TextStyle(
                      color: AppColors.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildTransactionRow(Transaction tx) {
    const rowHeight = 44.0;
    const borderColor = AppColors.border;
    return InkWell(
      onTap: () =>
          Navigator.of(context).pushNamed('/transaction-detail', arguments: tx),
      child: Container(
        height: rowHeight,
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: borderColor)),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 22,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Text(
                  tx.date,
                  style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
                ),
              ),
            ),
            Container(width: 1, height: rowHeight, color: borderColor),
            Expanded(
              flex: 16,
              child: Center(
                child: Text(
                  tx.type,
                  style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
                ),
              ),
            ),
            Container(width: 1, height: rowHeight, color: borderColor),
            Expanded(
              flex: 22,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Text(
                  '${tx.isCredit ? '+' : '-'}${_formatNumber(tx.amount)}P',
                  textAlign: TextAlign.right,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: tx.isCredit
                        ? AppColors.primaryBlue
                        : AppColors.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primaryBlue, width: 3),
              shape: BoxShape.circle,
            ),
            child: const Stack(
              alignment: Alignment.center,
              children: [
                Icon(Icons.access_time, size: 50, color: AppColors.primaryBlue),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Icon(
                    Icons.refresh,
                    size: 24,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Text(
            '現在、取引履歴がありません',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '取引可能になると、ここに表示されます',
            style: GoogleFonts.inter(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF0D1B2A),
            ),
            child: const Icon(
              Icons.error_outline,
              size: 48,
              color: AppColors.error,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            '読み込みに失敗しました',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'もう一度お試しください',
            style: GoogleFonts.inter(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: 200,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _loadTransactions,
              child: Text(
                'リトライ',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
  }
}

class Transaction {
  final String date;
  final String type;
  final int amount;
  final bool isCredit;

  Transaction({
    required this.date,
    required this.type,
    required this.amount,
    required this.isCredit,
  });
}
