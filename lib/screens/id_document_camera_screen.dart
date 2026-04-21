import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_app/l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/design_system.dart';
import '../widgets/loading_spinner.dart';
import 'image_preview_screen.dart';

class IdDocumentCameraScreen extends StatefulWidget {
  const IdDocumentCameraScreen({super.key});

  @override
  State<IdDocumentCameraScreen> createState() => _IdDocumentCameraScreenState();
}

class _IdDocumentCameraScreenState extends State<IdDocumentCameraScreen> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
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
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => _cameras!.first,
      );
      _controller = CameraController(camera, ResolutionPreset.high);
      await _controller!.initialize();
      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const bgColor = Color(0xFF161616);

    if (!_isCameraInitialized) {
      return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          title: Text(
            '本人確認書類を撮影',
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
                    '本人確認書類を撮影',
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
            // Camera fills all remaining space, with overlaid content
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  const topRatio = 0.20;
                  final cardWidth = constraints.maxWidth - 27;
                  final cardHeight = cardWidth / 1.812;
                  final cardTop = constraints.maxHeight * topRatio;
                  final cardBottom = cardTop + cardHeight;

                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      if (_controller != null) CameraPreview(_controller!),
                      // Dark overlay
                      Positioned.fill(
                        child: CustomPaint(
                          painter: const _CardFramePainter(topRatio: topRatio),
                        ),
                      ),
                      // Instruction text
                      Positioned(
                        top: 16,
                        left: 20,
                        right: 20,
                        child: Text(
                          '顔写真付きの本人確認書類を、カメラで撮影してください。\n書類全体が枠内に収まるよう、明るい場所で撮影してください。',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 13,
                            height: 1.6,
                          ),
                        ),
                      ),
                      // Valid documents list — anchored below the card frame
                      Positioned(
                        top: cardBottom + 16,
                        left: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '有効な本人確認書類',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '以下のいずれかをご用意ください。',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '・ 運転免許証',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              '・ マイナンバーカード',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              '・ 在留カード',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '※ 有効期限内のものに限ります',
                              style: GoogleFonts.inter(
                                color: Colors.white70,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            _buildControlBar(l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildControlBar(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Gallery
          GestureDetector(
            onTap: _onGalleryPressed,
            child: Container(
              width: 70,
              height: 70,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: const Icon(
                Icons.photo_library,
                color: Colors.black87,
                size: 30,
              ),
            ),
          ),
          // Capture
          GestureDetector(
            onTap: _onTakePicturePressed,
            child: Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryBlue,
              ),
              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 42,
              ),
            ),
          ),
          // Flip camera
          GestureDetector(
            onTap: _onSwitchCamera,
            child: Container(
              width: 70,
              height: 70,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: const Icon(
                Icons.flip_camera_ios,
                color: Colors.black87,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onTakePicturePressed() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    try {
      final image = await controller.takePicture();

      if (mounted && !_isDisposed) {
        // Navigate to the preview screen with the captured image path
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ImagePreviewScreen(imagePath: image.path),
          ),
        );
      }
    } catch (e) {
      // Handle error
    }
  }

  void _onSwitchCamera() async {
    if (_cameras == null || _cameras!.length < 2 || _controller == null) return;

    final lensDirection = _controller!.description.lensDirection;
    CameraDescription newDescription;
    if (lensDirection == CameraLensDirection.front) {
      newDescription = _cameras!.firstWhere(
        (description) => description.lensDirection == CameraLensDirection.back,
      );
    } else {
      newDescription = _cameras!.firstWhere(
        (description) => description.lensDirection == CameraLensDirection.front,
      );
    }

    final oldController = _controller;
    _controller = null;
    if (oldController != null) {
      await oldController.dispose();
    }

    _controller = CameraController(newDescription, ResolutionPreset.high);

    try {
      await _controller!.initialize();
      if (mounted && !_isDisposed) {
        setState(() {});
      }
    } catch (e) {
      debugPrint("Camera switch error: $e");
    }
  }

  Future<void> _onGalleryPressed() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null && mounted) {
        // Navigate to the preview screen with the picked image path
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ImagePreviewScreen(imagePath: image.path),
          ),
        );
      }
    } catch (e) {
      debugPrint("Gallery picker error: $e");
    }
  }
}

// Dark overlay with card frame cutout and border
class _CardFramePainter extends CustomPainter {
  final double topRatio;

  const _CardFramePainter({this.topRatio = 0.20});

  @override
  void paint(Canvas canvas, Size size) {
    final overlayPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.55)
      ..style = PaintingStyle.fill;

    final cardWidth = size.width - 27;
    final cardHeight = cardWidth / 1.812;
    const left = 13.5;
    final top = size.height * topRatio;

    // Dark overlay outside the card
    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(left, top, cardWidth, cardHeight),
          const Radius.circular(14),
        ),
      )
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, overlayPaint);

    // Black border
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(left, top, cardWidth, cardHeight),
        const Radius.circular(14),
      ),
      Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4,
    );
  }

  @override
  bool shouldRepaint(covariant _CardFramePainter old) =>
      old.topRatio != topRatio;
}
