import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/verification_provider.dart';
import '../theme/design_system.dart';
import '../widgets/loading_spinner.dart';
import 'upload_success_screen.dart';

class FaceCaptureScreen extends StatefulWidget {
  const FaceCaptureScreen({super.key});

  @override
  State<FaceCaptureScreen> createState() => _FaceCaptureScreenState();
}

class _FaceCaptureScreenState extends State<FaceCaptureScreen> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  bool _isCapturing = false;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      final camera = _cameras!.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras!.first,
      );
      _controller = CameraController(camera, ResolutionPreset.high);
      await _controller!.initialize();
      if (mounted) {
        setState(() => _isCameraInitialized = true);
      }
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    final controller = _controller;
    _controller = null;
    controller?.dispose();
    super.dispose();
  }

  Future<void> _onCapture() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized || _isCapturing) {
      return;
    }

    setState(() => _isCapturing = true);

    try {
      await controller.takePicture();
      if (mounted && !_isDisposed) {
        context.read<VerificationProvider>().completeVerification();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const UploadSuccessScreen()),
          (route) => route.isFirst,
        );
      }
    } catch (e) {
      debugPrint('Face capture error: $e');
      if (mounted && !_isDisposed) setState(() => _isCapturing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFF161616);

    if (!_isCameraInitialized) {
      return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          title: Text(
            '本人確認用の顔写真を撮影',
            style: GoogleFonts.inter(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: bgColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.primaryBlue,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: const Center(child: LoadingSpinner()),
      );
    }

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.primaryBlue,
                      size: 24,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Text(
                    '本人確認用の顔写真を撮影',
                    style: GoogleFonts.inter(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // Camera preview with face oval overlay
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (_controller != null) CameraPreview(_controller!),
                  Positioned.fill(
                    child: CustomPaint(painter: _FaceFramePainter()),
                  ),
                  // Instruction text above the oval
                  Positioned(
                    top: 16,
                    left: 20,
                    right: 20,
                    child: Text(
                      '正面を向き顔が枠内に収まるようにしてください',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 13,
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Capture button — centered
            _buildControlBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildControlBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Center(
        child: GestureDetector(
          onTap: _isCapturing ? null : _onCapture,
          child: Container(
            width: 70,
            height: 70,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryBlue,
            ),
            child: _isCapturing
                ? const LoadingSpinner()
                : const Icon(Icons.camera_alt, color: Colors.white, size: 30),
          ),
        ),
      ),
    );
  }
}

// Dark overlay with face oval cutout and border
class _FaceFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final overlayPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.55)
      ..style = PaintingStyle.fill;

    final ovalWidth = size.width - 80;
    final ovalHeight = size.height * 0.625;
    final ovalLeft = (size.width - ovalWidth) / 2;
    final ovalTop = size.height * 0.25;
    final ovalRect = Rect.fromLTWH(ovalLeft, ovalTop, ovalWidth, ovalHeight);

    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addOval(ovalRect)
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, overlayPaint);

    canvas.drawOval(
      ovalRect,
      Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 11,
    );
  }

  @override
  bool shouldRepaint(covariant _FaceFramePainter old) => false;
}
