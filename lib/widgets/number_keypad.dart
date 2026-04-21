import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NumberKeypad extends StatelessWidget {
  const NumberKeypad({
    super.key,
    required this.onKeyPressed,
    required this.onBackspace,
    this.showDot = true,
    this.buttonHeight = 60,
  });

  final void Function(String value) onKeyPressed;
  final VoidCallback onBackspace;

  /// Whether to enable the dot (.) key.
  final bool showDot;

  final double buttonHeight;

  // Thin gap between buttons that acts as a divider line.
  static const double _gap = 4.0;
  static const Color _dividerColor = Color(0xFF111827);
  static const Color _buttonColor = Color(0xFF1E2A3A);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Container(
        color: _dividerColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildRow(['1', '2', '3']),
            SizedBox(height: _gap),
            _buildRow(['4', '5', '6']),
            SizedBox(height: _gap),
            _buildRow(['7', '8', '9']),
            SizedBox(height: _gap),
            Row(
              children: [
                _buildKey('.', enabled: showDot),
                SizedBox(width: _gap),
                _buildKey('0'),
                SizedBox(width: _gap),
                _buildBackspaceKey(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Row _buildRow(List<String> keys) {
    return Row(
      children: [
        _buildKey(keys[0]),
        SizedBox(width: _gap),
        _buildKey(keys[1]),
        SizedBox(width: _gap),
        _buildKey(keys[2]),
      ],
    );
  }

  Widget _buildKey(String value, {bool enabled = true}) {
    return Expanded(
      child: GestureDetector(
        onTap: enabled ? () => onKeyPressed(value) : null,
        child: Container(
          height: buttonHeight,
          alignment: Alignment.center,
          color: _buttonColor,
          child: Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 32,
              fontWeight: FontWeight.w500,
              color: enabled ? Colors.white : Colors.white38,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackspaceKey() {
    return Expanded(
      child: GestureDetector(
        onTap: onBackspace,
        child: Container(
          height: buttonHeight,
          alignment: Alignment.center,
          color: _buttonColor,
          child: const Icon(
            Icons.backspace_outlined,
            color: Colors.white,
            size: 32,
          ),
        ),
      ),
    );
  }
}
