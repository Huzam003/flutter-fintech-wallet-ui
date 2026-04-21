import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../theme/design_system.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  late MobileScannerController _controller;
  bool _hasScanned = false;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      autoStart: true,
      facing: CameraFacing.back,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_hasScanned) return;

    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (barcode.rawValue != null) {
        setState(() => _hasScanned = true);

        // Navigate to payment amount screen with scanned data
        Navigator.of(
          context,
        ).pushReplacementNamed('/payment-amount', arguments: barcode.rawValue);
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'QRコードをスキャン',
          style: GoogleFonts.inter(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primaryBlue),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          // Scanner
          MobileScanner(controller: _controller, onDetect: _onDetect),

          // Overlay with scan frame
          CustomPaint(
            painter: _ScanFramePainter(),
            child: const SizedBox.expand(),
          ),
        ],
      ),
    );
  }
}

class _ScanFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final frameSize = size.width * 0.7;
    final left = (size.width - frameSize) / 2;
    final top = (size.height - frameSize) / 2.5;

    // Draw semi-transparent overlay
    final overlayPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    // Top overlay
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, top), overlayPaint);
    // Bottom overlay
    canvas.drawRect(
      Rect.fromLTWH(
        0,
        top + frameSize,
        size.width,
        size.height - top - frameSize,
      ),
      overlayPaint,
    );
    // Left overlay
    canvas.drawRect(Rect.fromLTWH(0, top, left, frameSize), overlayPaint);
    // Right overlay
    canvas.drawRect(
      Rect.fromLTWH(left + frameSize, top, left, frameSize),
      overlayPaint,
    );

    // Draw rounded corner brackets — floated slightly inward from frame edge
    final cornerPaint = Paint()
      ..color = AppColors.primaryBlue
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    const cornerLength = 44.0;
    const radius = 12.0;
    const float = 6.0; // outset beyond the overlay boundary

    final cLeft = left - float;
    final cTop = top - float;
    final cRight = left + frameSize + float;
    final cBottom = top + frameSize + float;

    void drawCorner(
      Canvas c,
      Offset origin,
      double hDir, // +1 = right, -1 = left
      double vDir, // +1 = down,  -1 = up
    ) {
      final path = Path()
        ..moveTo(origin.dx + hDir * cornerLength, origin.dy)
        ..lineTo(origin.dx + hDir * radius, origin.dy)
        ..arcToPoint(
          Offset(origin.dx, origin.dy + vDir * radius),
          radius: const Radius.circular(radius),
          clockwise: hDir * vDir < 0,
        )
        ..lineTo(origin.dx, origin.dy + vDir * cornerLength);
      c.drawPath(path, cornerPaint);
    }

    drawCorner(canvas, Offset(cLeft, cTop), 1, 1);
    drawCorner(canvas, Offset(cRight, cTop), -1, 1);
    drawCorner(canvas, Offset(cLeft, cBottom), 1, -1);
    drawCorner(canvas, Offset(cRight, cBottom), -1, -1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
