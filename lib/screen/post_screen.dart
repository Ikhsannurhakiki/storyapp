import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../provider/main_provider.dart';
import '../provider/upload_provider.dart';
import '../style/colors/app_colors.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final TextEditingController _controller = TextEditingController();
  bool isFull = false;

  @override
  Widget build(BuildContext context) {
    final imagePath = context.read<MainProvider>().imagePath;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: 150,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.lightTeal.color,
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.file(
                    width: 150,
                    height: 200,
                    File(imagePath.toString()),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(height: 50),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: isFull ? 15 : 5,
                minLines: isFull ? 10 : 4,
                maxLength: 400,
                keyboardType: TextInputType.multiline,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(isFull ? "Minimize" : "Maximize"),
                  IconButton(
                    icon: Icon(
                      isFull ? Icons.fullscreen_exit : Icons.fullscreen,
                    ),
                    onPressed: () {
                      setState(() {
                        isFull = !isFull;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Consumer<UploadProvider>(
        builder: (context, provider, _) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    onPressed: provider.isUploading
                        ? null
                        : () => context.pop(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.cancel_outlined, color: Colors.red),
                        const Text(
                          "Cancel",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.lightTeal.color,
                    ),
                    onPressed: () => provider.isUploading ? null : _onUpload(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        provider.isUploading
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(
                                Icons.upload_outlined,
                                color: Colors.black,
                              ),
                        provider.isUploading
                            ? const Text(
                                "Posting ...",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : const Text(
                                "Post",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  _onUpload() async {
    final description = _controller.text.trim();

    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Description cannot be empty")),
      );
      return;
    }
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final uploadProvider = context.read<UploadProvider>();
    final homeProvider = context.read<MainProvider>();
    final router = GoRouter.of(context);

    final imagePath = homeProvider.imagePath;
    final imageFile = homeProvider.imageFile;
    if (imagePath == null || imageFile == null) return;

    final fileName = imageFile.name;
    final bytes = await imageFile.readAsBytes();
    final newBytes = await uploadProvider.compressImage(bytes);

    await uploadProvider.upload(newBytes, fileName, description);

    if (uploadProvider.uploadResponse != null) {
      homeProvider.setImageFile(null);
      homeProvider.setImagePath(null);
    }

    scaffoldMessenger.showSnackBar(
      SnackBar(content: Text(uploadProvider.message)),
    );

    router.go("/home");
  }
}
