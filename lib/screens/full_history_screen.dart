import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/design_system.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../models/transaction.dart' as model;
import 'history_screen.dart';

class FullHistoryScreen extends StatefulWidget {
  const FullHistoryScreen({super.key});

  @override
  State<FullHistoryScreen> createState() => _FullHistoryScreenState();
}

class _FullHistoryScreenState extends State<FullHistoryScreen> {
  String _selectedFilter = 'all';
  DateTimeRange? _dateRange;
  bool _filterExpanded = false;

  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  List<model.Transaction> _allTransactions = [];

  @override
  Widget build(BuildContext context) {
    _allTransactions = context.watch<TransactionProvider>().transactions;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'すべての履歴を表示',
          style: GoogleFonts.inter(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
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
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildFilterBar(),
            const SizedBox(height: 24),
            _buildTable(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  //Filter bar

  Widget _buildFilterBar() {
    // Collapsed: compact square button
    if (!_filterExpanded) {
      return GestureDetector(
        onTap: () => setState(() => _filterExpanded = true),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: AppColors.border),
          ),
          child: Center(
            child: Icon(Icons.tune, size: 18, color: AppColors.primaryBlue),
          ),
        ),
      );
    }

    // Expanded: full-width bar with chips
    return SizedBox(
      width: double.infinity,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () => setState(() => _filterExpanded = false),
              child: Container(
                width: 28,
                height: 44,
                color: Colors.transparent,
                child: Center(
                  child: Icon(
                    Icons.tune,
                    size: 16,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 7,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: _buildDateRangeChip(),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: _buildTypeChip('payment', '決済'),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: _buildTypeChip('charge', 'チャージ'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildDateRangeChip() {
    final hasRange = _dateRange != null;
    return GestureDetector(
      onTap: () async {
        final picked = await _showManualDateRangeDialog();
        if (picked != null) {
          setState(() => _dateRange = picked);
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            hasRange ? _formatDate(_dateRange!.start) : '全日程',
            style: GoogleFonts.inter(
              color: hasRange ? Colors.white : Colors.grey[400],
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (hasRange) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                'に',
                style: GoogleFonts.inter(color: Colors.grey[500], fontSize: 13),
              ),
            ),
            Text(
              _formatDate(_dateRange!.end),
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: () => setState(() => _dateRange = null),
              child: const Icon(Icons.close, size: 13, color: AppColors.border),
            ),
          ] else ...[
            const SizedBox(width: 4),
            Icon(Icons.arrow_drop_down, size: 16, color: Colors.grey[500]),
          ],
        ],
      ),
    );
  }

  Widget _buildTypeChip(String filterVal, String label) {
    final isSelected = _selectedFilter == filterVal;
    return GestureDetector(
      onTap: () =>
          setState(() => _selectedFilter = isSelected ? 'all' : filterVal),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 9,
            height: 9,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? AppColors.primaryBlue : Colors.grey[700],
              border: Border.all(
                color: isSelected ? AppColors.primaryBlue : Colors.grey[600]!,
                width: 1.5,
              ),
            ),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.inter(
              color: isSelected ? Colors.white : Colors.grey[400],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  //Transaction table

  Widget _buildTable() {
    final transactions = _getFilteredTransactions();
    const rowHeight = 44.0;
    const borderColor = AppColors.border;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: Column(
          children: [
            // Header row
            Container(
              height: rowHeight,
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
                          fontSize: 18,
                          color: AppColors.primaryBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(width: 1, color: borderColor),
                  Expanded(
                    flex: 16,
                    child: Center(
                      child: Text(
                        '種別',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          color: AppColors.primaryBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(width: 1, color: borderColor),
                  Expanded(
                    flex: 22,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Text(
                        'ポイント',
                        textAlign: TextAlign.right,
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          color: AppColors.primaryBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Data rows
            ...transactions.map((tx) {
              void navigate() => Navigator.of(
                context,
              ).pushNamed('/transaction-detail', arguments: tx);
              return InkWell(
                onTap: navigate,
                child: Container(
                  height: rowHeight,
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: borderColor)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 22,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Text(
                            '${tx.date.year}/${tx.date.month.toString().padLeft(2, '0')}/${tx.date.day.toString().padLeft(2, '0')}',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 1,
                        height: rowHeight,
                        color: borderColor,
                      ),
                      Expanded(
                        flex: 16,
                        child: Center(
                          child: Text(
                            tx.type == 'charge' ? 'チャージ' : '決済',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 1,
                        height: rowHeight,
                        color: borderColor,
                      ),
                      Expanded(
                        flex: 22,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Text(
                            '${tx.type == 'charge' ? '+' : '-'}${_formatNumber(tx.amount.toInt())}P',
                            textAlign: TextAlign.right,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: tx.type == 'charge'
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
            }),
          ],
        ),
      ),
    );
  }

  //Helpers

  Future<DateTimeRange?> _showManualDateRangeDialog() async {
    _startDateController.text = _dateRange == null
        ? ''
        : _formatDate(_dateRange!.start);
    _endDateController.text = _dateRange == null
        ? ''
        : _formatDate(_dateRange!.end);
    DateTime? selectedStart = _dateRange?.start;
    DateTime? selectedEnd = _dateRange?.end;
    String? errorText;

    final pickedRange = await showDialog<DateTimeRange>(
      context: context,
      builder: (dialogContext) {
        Future<void> pickDate({required bool isStart}) async {
          final initialDate = isStart
              ? (selectedStart ?? DateTime.now())
              : (selectedEnd ?? selectedStart ?? DateTime.now());
          final firstDate = isStart
              ? DateTime(2020)
              : (selectedStart ?? DateTime(2020));
          final picked = await showDatePicker(
            context: dialogContext,
            initialDate: initialDate,
            firstDate: firstDate,
            lastDate: DateTime(2030),
            helpText: isStart ? '開始日を選択' : '終了日を選択',
            useRootNavigator: false,
            barrierColor: Colors.black54,
            initialEntryMode: DatePickerEntryMode.calendarOnly,
          );
          if (picked == null) return;
          if (isStart) {
            selectedStart = picked;
            _startDateController.text = _formatDate(picked);
            if (selectedEnd != null && selectedEnd!.isBefore(picked)) {
              selectedEnd = picked;
              _endDateController.text = _formatDate(picked);
            }
          } else {
            selectedEnd = picked;
            _endDateController.text = _formatDate(picked);
          }
        }

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: Text(
                '日付範囲を選択',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              content: SizedBox(
                width: 340,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildDateInputRow(
                      label: '開始日',
                      controller: _startDateController,
                      onPickCalendar: () async {
                        await pickDate(isStart: true);
                        setDialogState(() => errorText = null);
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildDateInputRow(
                      label: '終了日',
                      controller: _endDateController,
                      onPickCalendar: () async {
                        await pickDate(isStart: false);
                        setDialogState(() => errorText = null);
                      },
                    ),
                    if (errorText != null) ...[
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          errorText!,
                          style: GoogleFonts.inter(
                            color: AppColors.error,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text(
                    'キャンセル',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final parsedStart = _tryParseInputDate(
                      _startDateController.text,
                    );
                    final parsedEnd = _tryParseInputDate(
                      _endDateController.text,
                    );
                    if (parsedStart == null || parsedEnd == null) {
                      setDialogState(
                        () => errorText = '日付は dd/MM/yyyy 形式で入力してください',
                      );
                      return;
                    }
                    if (parsedEnd.isBefore(parsedStart)) {
                      setDialogState(() => errorText = '終了日は開始日以降にしてください');
                      return;
                    }
                    if (parsedStart.isBefore(DateTime(2020)) ||
                        parsedEnd.isAfter(DateTime(2030, 12, 31))) {
                      setDialogState(
                        () => errorText = '有効な範囲は 2020/01/01〜2030/12/31 です',
                      );
                      return;
                    }
                    Navigator.of(
                      dialogContext,
                    ).pop(DateTimeRange(start: parsedStart, end: parsedEnd));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(8.0),
                  ),
                  child: const Text('適用'),
                ),
              ],
            );
          },
        );
      },
    );

    return pickedRange;
  }

  Widget _buildDateInputRow({
    required String label,
    required TextEditingController controller,
    required Future<void> Function() onPickCalendar,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.datetime,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'dd/MM/yyyy',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  filled: true,
                  fillColor: AppColors.surfaceLight,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.primaryBlue),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: onPickCalendar,
              icon: const Icon(Icons.calendar_today, size: 18),
              color: Colors.white70,
              style: IconButton.styleFrom(
                backgroundColor: AppColors.surfaceLight,
                side: const BorderSide(color: AppColors.border),
              ),
              tooltip: 'カレンダーを開く',
            ),
          ],
        ),
      ],
    );
  }

  DateTime? _tryParseInputDate(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return null;
    final parts = text.split(RegExp(r'[/\\-]'));
    if (parts.length != 3) return null;
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (day == null || month == null || year == null) return null;
    final parsed = DateTime(year, month, day);
    if (parsed.year != year || parsed.month != month || parsed.day != day) {
      return null;
    }
    return parsed;
  }

  List<model.Transaction> _getFilteredTransactions() {
    return _allTransactions.where((tx) {
      final txDate = tx.date;

      final dateMatch = _dateRange == null
          ? true
          : !txDate.isBefore(_dateRange!.start) &&
                !txDate.isAfter(_dateRange!.end);

      final typeMatch = _selectedFilter == 'charge'
          ? tx.type == 'charge'
          : _selectedFilter == 'payment'
          ? tx.type == 'payment'
          : true;

      return dateMatch && typeMatch;
    }).toList();
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
  }
}
