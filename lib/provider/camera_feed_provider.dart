import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:sizer/sizer.dart';

class CameraFeedProvider extends ChangeNotifier {
  List<CameraDescription> cameras = <CameraDescription>[];

  CameraController? controller;
  double containerWidth = 40.w;
  double containerHeight = 25.h;
  Offset containerOffset = const Offset(100, 100);
  Offset resizeDelta = Offset.zero;
  Offset startDragOffset = Offset.zero;
  bool showControls = true;

  toggleControls() {
    showControls = !showControls;
    notifyListeners();
  }

  resize(DragUpdateDetails details) {
    double newWidth = containerWidth + details.delta.dx;
    double newHeight = containerHeight + details.delta.dy;

    if (newWidth >= 100.0 && newWidth <= 250.0) {
      containerWidth = newWidth;
    }
    if (newHeight >= 100.0 && newHeight <= 250.0) {
      containerHeight = newHeight;
    }
    notifyListeners();
  }

  onPanStart(DragStartDetails details) {
    startDragOffset = details.localPosition;
    notifyListeners();
  }

  onPanUpdate(DragUpdateDetails details) {
    containerOffset = containerOffset + details.delta;
    notifyListeners();
  }

  Future<void> initializeCamera() async {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      controller = CameraController(cameras[1], ResolutionPreset.medium);
      await controller?.initialize();
      notifyListeners();
    }
  }

  void toggleCamera() async {
    final newDirection =
        controller?.description.lensDirection == CameraLensDirection.front
            ? CameraLensDirection.back
            : CameraLensDirection.front;

    final newCamera =
        cameras.firstWhere((camera) => camera.lensDirection == newDirection);

    await controller?.dispose();
    controller = CameraController(newCamera, ResolutionPreset.medium);
    await controller?.initialize();
    notifyListeners();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
