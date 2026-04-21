import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:camera/camera.dart';
import '../theme/design_system.dart';
import '../widgets/loading_spinner.dart';

class SelfieCaptureScreen extends StatefulWidget {
  const SelfieCaptureScreen({super.key});

  @override
  State<SelfieCaptureScreen> createState() => _SelfieCaptureScreenState();
}

class _SelfieCaptureScreenState extends State<SelfieCaptureScreen> {
  CameraController? _controller;
  bool _isInitialized = false;
  bool _isCapturing = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _controller = CameraController(frontCamera, ResolutionPreset.medium);

      await _controller!.initialize();
      if (mounted) {
        setState(() => _isInitialized = true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('カメラの初期化に失敗しました')));
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _capture() async {
    if (_controller == null || _isCapturing) return;

    setState(() => _isCapturing = true);

    try {
      await _controller!.takePicture();

      if (mounted) {
        // Navigate to success screen
        Navigator.of(context).pushReplacementNamed('/upload-success');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('撮影に失敗しました')));
        setState(() => _isCapturing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          '顔写真の撮影（セルフィー）',
          style: GoogleFonts.inter(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.bold,
            fontSize: 16,
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
      body: Column(
        children: [
          const SizedBox(height: 20),

          // Instructions
          Text(
            '本人確認用の顔写真を撮影',
            style: GoogleFonts.inter(fontSize: 16, color: Colors.white),
          ),

          const SizedBox(height: 40),

          // Camera preview with face outline
          Expanded(
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Camera preview
                  if (_isInitialized && _controller != null)
                    ClipOval(
                      child: SizedBox(
                        width: 280,
                        height: 350,
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width:
                                _controller!.value.previewSize?.height ?? 280,
                            height:
                                _controller!.value.previewSize?.width ?? 350,
                            child: CameraPreview(_controller!),
                          ),
                        ),
                      ),
                    )
                  else
                    Container(
                      width: 280,
                      height: 350,
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(140),
                      ),
                      child: const Center(
                        child: LoadingSpinner(
                          size: 40,
                          dotRadius: 4,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ),

                  // Face outline overlay
                  CustomPaint(
                    size: const Size(300, 380),
                    painter: _FaceOutlinePainter(),
                  ),
                ],
              ),
            ),
          ),

          // Capture button
          Padding(
            padding: const EdgeInsets.all(32),
            child: Center(
              child: SizedBox(
                width: 287,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                onPressed: _isInitialized && !_isCapturing ? _capture : null,
                child: Text(
                  _isCapturing ? '撮影中...' : '開始',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          ),
        ],
      ),
    );
  }
}

class _FaceOutlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryBlue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw face outline (oval)
    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: 200,
      height: 260,
    );
    canvas.drawOval(rect, paint);

    // Draw corner marks
    const markLength = 20.0;

    // Top-left
    canvas.drawLine(Offset(50, 30), Offset(50 + markLength, 30), paint);
    canvas.drawLine(Offset(50, 30), Offset(50, 30 + markLength), paint);

    // Top-right
    canvas.drawLine(
      Offset(size.width - 50, 30),
      Offset(size.width - 50 - markLength, 30),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - 50, 30),
      Offset(size.width - 50, 30 + markLength),
      paint,
    );

    // Bottom-left
    canvas.drawLine(
      Offset(50, size.height - 30),
      Offset(50 + markLength, size.height - 30),
      paint,
    );
    canvas.drawLine(
      Offset(50, size.height - 30),
      Offset(50, size.height - 30 - markLength),
      paint,
    );

    // Bottom-right
    canvas.drawLine(
      Offset(size.width - 50, size.height - 30),
      Offset(size.width - 50 - markLength, size.height - 30),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - 50, size.height - 30),
      Offset(size.width - 50, size.height - 30 - markLength),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
