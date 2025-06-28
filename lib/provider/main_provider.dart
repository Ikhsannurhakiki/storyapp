import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MainProvider extends ChangeNotifier{
  String? imagePath;
  XFile? imageFile;

  void setImagePath(String? value) {
    imagePath = value;
    notifyListeners();
  }

  void setImageFile(XFile? value) {
    imageFile = value;
    notifyListeners();
  }

  void clearImagePath() {
    imagePath = null;
    notifyListeners();
  }

  void clearImageFile() {
    imageFile = null;
    notifyListeners();
  }
}