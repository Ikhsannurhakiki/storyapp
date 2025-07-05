import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MainProvider extends ChangeNotifier{
<<<<<<< HEAD
  int _tabIndex = 0;
  int get tabIndex => _tabIndex;
  String? imagePath;
  XFile? imageFile;

  void setTabIndex(int index) {
    _tabIndex = index;
    notifyListeners();
  }

=======
  String? imagePath;
  XFile? imageFile;

>>>>>>> c91276863fb05f4c01eac9f46b8a603fe1c3067e
  void setImagePath(String? value) {
    imagePath = value;
    notifyListeners();
  }

  void setImageFile(XFile? value) {
    imageFile = value;
    notifyListeners();
  }

<<<<<<< HEAD
  void clearImage() {
    imagePath = null;
=======
  void clearImagePath() {
    imagePath = null;
    notifyListeners();
  }

  void clearImageFile() {
>>>>>>> c91276863fb05f4c01eac9f46b8a603fe1c3067e
    imageFile = null;
    notifyListeners();
  }
}