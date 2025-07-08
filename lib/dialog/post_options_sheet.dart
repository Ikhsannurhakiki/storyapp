import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../provider/main_provider.dart';

class PostOptionsSheet extends StatelessWidget {
  const PostOptionsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<MainProvider>();
      provider.clearImage();
    });

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Wrap(
            children: [
              Center(
                child: const Text(
                  "Pick an image !",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Divider(height: 30, thickness: 2),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () async {
                  context.pop();
                  await Future.delayed(Duration(milliseconds: 200));
                  _onGalleryView(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  context.pop();
                  _onCameraView(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_enhance_rounded),
                title: const Text('Custom Camera'),
                onTap: () {
                  context.pop();
                  _onCustomCameraView(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onGalleryView(BuildContext context) async {
    final provider = context.read<MainProvider>();
    final goRouter = GoRouter.of(context);

    final isMacOS = defaultTargetPlatform == TargetPlatform.macOS;
    final isLinux = defaultTargetPlatform == TargetPlatform.linux;
    if (isMacOS || isLinux) return;

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);

      goRouter.push('/home/preview');
    }
  }

  void _onCameraView(BuildContext context) async {
    final provider = context.read<MainProvider>();
    final goRouter = GoRouter.of(context);

    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    final isiOS = defaultTargetPlatform == TargetPlatform.iOS;
    final isNotMobile = !(isAndroid || isiOS);
    if (isNotMobile) return;

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
      goRouter.push('/home/preview');
    }
  }

  void _onCustomCameraView(BuildContext context) async {
    final provider = context.read<MainProvider>();
    final goRouter = GoRouter.of(context);

    final isMacOS = defaultTargetPlatform == TargetPlatform.macOS;
    final isLinux = defaultTargetPlatform == TargetPlatform.linux;
    if (isMacOS || isLinux) return;

    final cameras = await availableCameras();

    final resultImageFile = await goRouter.push<XFile?>(
      '/camera',
      extra: cameras,
    );

    if (resultImageFile != null) {
      provider.setImageFile(resultImageFile);
      provider.setImagePath(resultImageFile.path);
      goRouter.push('/home/preview');
    }
  }
}
