import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MainProvider extends ChangeNotifier{

  int _tabIndex = 0;
  int get tabIndex => _tabIndex;
  String? imagePath;
  XFile? imageFile;

  void setTabIndex(int index) {
    _tabIndex = index;
    notifyListeners();
  }

  void setImagePath(String? value) {
    imagePath = value;
    notifyListeners();
  }

  void setImageFile(XFile? value) {
    imageFile = value;
    notifyListeners();
  }

  void clearImage() {
    imagePath = null;
    imageFile = null;
    notifyListeners();
  }
}