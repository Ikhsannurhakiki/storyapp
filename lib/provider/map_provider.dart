import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapProvider extends ChangeNotifier {
  bool _isMapPicker = true;
  bool get isMapPicker => _isMapPicker;
  Placemark? _placemark;
  Placemark? get placemark => _placemark;
  LatLng? _latLng;
  LatLng? get latLng => _latLng;

  void setIsMapPicker(bool isMapPicker) {
    _isMapPicker = isMapPicker;
    notifyListeners();
  }

  void resetIsMapPicker() {
    _isMapPicker = true;
    notifyListeners();
  }

  void setPlacemark(Placemark placemark) {
    _placemark = placemark;
    notifyListeners();
  }

  void resetPlacemark() {
    _placemark = null;
    notifyListeners();
  }

  void setLatLng(LatLng latLng) {
    _latLng = latLng;
    print(latLng);
    notifyListeners();
  }
  void resetLatLng() {
    _latLng = const LatLng(0, 0);
    notifyListeners();
  }

  Future<List<Placemark>> getPlacemark(LatLng latLng) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );
      return placemarks;
    } catch (e) {
      print('Failed to get placemark: $e');
      return []; // or rethrow if you want to handle higher up
    }
  }
}
