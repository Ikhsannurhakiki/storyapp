import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:storyapp/provider/main_provider.dart';
import 'package:storyapp/screen/profile_screen.dart';
import 'package:storyapp/screen/stories_list_screen.dart';

import '../style/colors/app_colors.dart';
import 'camera_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> _screens = [
    const StoriesListScreen(),
    const ProfileScreen(),
  ];

  int _currentIndex = 0;

  void _onTap(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: _currentIndex, children: _screens),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showPostOptions(context),
        backgroundColor: isDarkMode
            ? AppColors.darkTeal.color
            : AppColors.lightTeal.color,
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: BorderSide(
            color: isDarkMode ? Colors.black : Colors.white,
            width: 3,
          ),
        ),
        child: const Icon(Icons.add, size: 25),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomAppBar(
          height: 80,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.home,
                  color: _currentIndex == 0
                      ? AppColors.navyBlue.color
                      : Colors.grey,
                  size: 30,
                ),
                onPressed: () => _onTap(0),
              ),
              const SizedBox(width: 3),
              IconButton(
                icon: Icon(
                  Icons.person,
                  color: _currentIndex == 1
                      ? AppColors.navyBlue.color
                      : Colors.grey,
                  size: 30,
                ),
                onPressed: () => _onTap(1),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onGalleryView() async {
    final provider = context.read<MainProvider>();
    final navigator = GoRouter.of(context);

    final isMacOS = defaultTargetPlatform == TargetPlatform.macOS;
    final isLinux = defaultTargetPlatform == TargetPlatform.linux;
    if (isMacOS || isLinux) return;

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);

      navigator.push('/home/preview');
    }
  }

  _onCameraView() async {
    final provider = context.read<MainProvider>();
    final router = GoRouter.of(context);

    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    final isiOS = defaultTargetPlatform == TargetPlatform.iOS;
    final isNotMobile = !(isAndroid || isiOS);
    if (isNotMobile) return;

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
      router.push('/home/preview');
    }
  }

  _onCustomCameraView() async {
    final provider = context.read<MainProvider>();
    final navigator = Navigator.of(context);
    final goRouter = GoRouter.of(context);

    final isMacOS = defaultTargetPlatform == TargetPlatform.macOS;
    final isLinux = defaultTargetPlatform == TargetPlatform.linux;
    if (isMacOS || isLinux) return;

    final cameras = await availableCameras();

    final XFile? resultImageFile = await navigator.push(
      MaterialPageRoute(builder: (context) => CameraScreen(cameras: cameras)),
    );

    if (resultImageFile != null) {
      provider.setImageFile(resultImageFile);
      provider.setImagePath(resultImageFile.path);
      goRouter.push('/home/preview');
    }
  }

  void _showPostOptions(BuildContext context) {
    final provider = context.read<MainProvider>();
    provider.clearImagePath();
    provider.clearImageFile();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Gallery'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _onGalleryView();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Camera'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _onCameraView();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_enhance_rounded),
                  title: const Text('Custom Camera'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _onCustomCameraView();
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.close),
                  title: const Text('Cancel'),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
