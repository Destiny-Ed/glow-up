import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:glow_up/main_activity/main_activity.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CameraScreen extends StatefulWidget {
  final bool isFirst; // For onboarding flow
  const CameraScreen({super.key, this.isFirst = false});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  bool _isFlashOn = false;
  XFile? _pickedImage;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    // Use front camera (index 1 usually)
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );
    _controller = CameraController(frontCamera, ResolutionPreset.high);
    if (mounted) setState(() {});
  }

  Future<void> _toggleFlash() async {
    setState(() => _isFlashOn = !_isFlashOn);
    await _controller?.setFlashMode(
      _isFlashOn ? FlashMode.torch : FlashMode.off,
    );
  }

  // Switch between Front and Rear Camera
  Future<void> _switchCamera() async {
    final cameras = await availableCameras();
    if (cameras.length < 2) return;

    final currentLensDirection = _controller?.description.lensDirection;
    final newCamera = cameras.firstWhere(
      (camera) => camera.lensDirection != currentLensDirection,
      orElse: () => cameras.first,
    );

    // Dispose old controller
    await _controller?.dispose();

    // Create new controller with opposite camera
    _controller = CameraController(newCamera, ResolutionPreset.high);

    // Re-initialize
    await _controller?.initialize();

    // Optional: Preserve flash state if possible
    if (_isFlashOn && newCamera.lensDirection == CameraLensDirection.back) {
      await _controller?.setFlashMode(FlashMode.torch);
    } else {
      await _controller?.setFlashMode(FlashMode.off);
      setState(() => _isFlashOn = false);
    }

    if (mounted) setState(() {});
  }

  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _pickedImage = picked);
    }
  }

  Future<void> _takeOrConfirmPhoto() async {
    try {
      File imageFile;
      if (_pickedImage != null) {
        imageFile = File(_pickedImage!.path);
      } else {
        await _controller?.initialize();
        final image = await _controller?.takePicture();
        imageFile = File(image?.path ?? "");
        setState(() {});
      }

      // final uid = AuthService().currentUser?.uid ?? '';
      // if (uid.isEmpty) {
      //   Fluttertoast.showToast(msg: 'Please sign in first');
      //   return;
      // }

      // final photoUrl = await StorageService().uploadPhoto(imageFile, "uid");
      // await DatabaseService(uid: uid).postDailyPhoto(photoUrl);

      Fluttertoast.showToast(msg: 'Today\'s fit posted! 🔥');

      // Navigate to home or next screen
      if (mounted) {
        // Navigator.pushReplacementNamed(
        //   context,
        //   '/home',
        // ); // Adjust route as needed
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainActivityScreen()),
        );
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera Preview or Picked Image
          if (_pickedImage != null)
            Positioned.fill(
              child: Image.file(File(_pickedImage!.path), fit: BoxFit.cover),
            )
          else
            FutureBuilder<void>(
              future: _controller?.initialize(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Positioned.fill(child: CameraPreview(_controller!));
                }
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              },
            ),

          // Pose Guide Silhouette (Dashed)
          Center(
            // child: DottedBorder(
            //   options: RectDottedBorderOptions(
            //     // radius: const Radius.circular(16),
            //     dashPattern: const [10, 8],
            //     color: Colors.white.withOpacity(0.7),
            //     strokeWidth: 3,
            //   ),
            //   child: Padding(
            //     padding: const EdgeInsets.all(40.0),
            //     child: CustomPaint(
            //       size: Size(
            //         MediaQuery.of(context).size.width * 0.6,
            //         MediaQuery.of(context).size.height * 0.7,
            //       ),
            //       painter: HumanPosePainter(),
            //     ),
            //   ),
            // ),
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: CustomPaint(
                size: Size(
                  MediaQuery.of(context).size.width * 0.6,
                  MediaQuery.of(context).size.height * 0.4,
                ),
                painter: HumanPosePainter(),
              ),
            ),
          ),

          // Top Bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    'Snap Today\'s Fit',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _isFlashOn ? Icons.flash_on : Icons.flash_off,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: _toggleFlash,
                  ),
                ],
              ),
            ),
          ),

          // Bottom Controls
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Tabs
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // _buildTab('VIDEO', false),
                      _buildTab('PHOTO', true),
                      // _buildTab('BATTLE', false),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildBottomIcon(Icons.photo_library, _pickFromGallery),
                      _buildShutterButton(),
                      _buildBottomIcon(Icons.flip_camera_ios, () {
                        _switchCamera();
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String text, bool active) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Text(
            text,
            style: TextStyle(
              color: active ? Theme.of(context).primaryColor : Colors.white70,
              fontSize: 16,
            ),
          ),
          if (active)
            Container(
              margin: const EdgeInsets.only(top: 6),
              height: 3,
              width: 40,
              color: Theme.of(context).primaryColor,
            ),
        ],
      ),
    );
  }

  Widget _buildBottomIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black54,
        ),
        child: Icon(icon, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildShutterButton() {
    return GestureDetector(
      onTap: _takeOrConfirmPhoto,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 6),
          color: Colors.white,
        ),
      ),
    );
  }
}

// Custom Painter for Human Pose Silhouette
class HumanPosePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();

    // Head
    path.addOval(
      Rect.fromCircle(
        center: Offset(size.width / 2, size.height * 0.12),
        radius: size.width * 0.15,
      ),
    );

    // Body
    path.moveTo(size.width / 2, size.height * 0.22);
    path.lineTo(size.width / 2, size.height * 0.65);

    // Arms
    path.moveTo(size.width / 2, size.height * 0.35);
    path.lineTo(size.width * 0.25, size.height * 0.55);
    path.moveTo(size.width / 2, size.height * 0.35);
    path.lineTo(size.width * 0.75, size.height * 0.55);

    // Legs
    path.moveTo(size.width / 2, size.height * 0.65);
    path.lineTo(size.width * 0.35, size.height);
    path.moveTo(size.width / 2, size.height * 0.65);
    path.lineTo(size.width * 0.65, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
