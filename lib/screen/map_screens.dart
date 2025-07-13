import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' hide Location;
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:provider/provider.dart';

import '../provider/map_provider.dart';
import '../style/colors/app_colors.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Location _locationService = Location();
  GoogleMapController? _mapController;
  LatLng? _currentLatLng;
  Set<Marker> _markers = {};
  geo.Placemark? _placemark;
  MapType _currentMapType = MapType.normal;
  LatLng _currentPosition = const LatLng(-6.200000, 106.816666);

  Future<void> _getMyLocation() async {
    final hasPermission = await _locationService.hasPermission();
    if (hasPermission == PermissionStatus.denied) {
      await _locationService.requestPermission();
    }

    final locationData = await _locationService.getLocation();
    setState(() {
      _currentPosition = LatLng(
        locationData.latitude!,
        locationData.longitude!,
      );
    });

    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(_currentPosition, 16),
    );
  }

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    final dataProvider = context.read<MapProvider>();
    LatLng? latLng = dataProvider.latLng;
    Placemark? placemark = dataProvider.placemark;

    if (latLng == null) {
      bool serviceEnabled = await _locationService.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _locationService.requestService();
        if (!serviceEnabled) return;
      }

      PermissionStatus permissionGranted = await _locationService
          .hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await _locationService.requestPermission();
        if (permissionGranted != PermissionStatus.granted) return;
      }

      final locationData = await _locationService.getLocation();
      if (locationData.latitude == null || locationData.longitude == null)
        return;

      latLng = LatLng(locationData.latitude!, locationData.longitude!);

      final placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );
      if (placemarks.isNotEmpty) {
        placemark = placemarks.first;
        dataProvider.setPlacemark(placemark);
      }

      dataProvider.setLatLng(latLng);
    }

    setState(() {
      _currentLatLng = latLng!;
      _placemark = placemark;

      _markers = {
        Marker(
          markerId: const MarkerId("current_location"),
          position: latLng,
          infoWindow: InfoWindow(title: placemark?.street ?? "Picked Location"),
        ),
      };
    });

    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(latLng, 16));
  }

  Future<void> _onTapMap(LatLng latLng) async {
    try {
      final placemarks = await geo.placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );

      final place = placemarks.first;

      setState(() {
        _currentLatLng = latLng;
        _placemark = place;
        _markers = {
          Marker(
            markerId: const MarkerId("selected"),
            position: latLng,
            infoWindow: const InfoWindow(title: "Selected Location"),
          ),
        };
      });

      _mapController?.animateCamera(CameraUpdate.newLatLngZoom(latLng, 16));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to fetch location details.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mapProvider = context.read<MapProvider>();
    return Scaffold(
      body: _currentLatLng == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _currentLatLng!,
                    zoom: 16,
                  ),
                  markers: _markers,
                  myLocationEnabled: true,
                  mapType: _currentMapType,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  onMapCreated: (controller) => _mapController = controller,
                  onTap: _onTapMap,
                ),
                Positioned(
                  bottom: _placemark != null ? 200 : 20,
                  right: 16,
                  child: Row(
                    children: [
                      FloatingActionButton(
                        heroTag: 'btn_my_location',
                        mini: true,
                        onPressed: _getMyLocation,
                        tooltip: 'My Location',
                        child: const Icon(Icons.my_location),
                      ),
                      FloatingActionButton.small(
                        onPressed: null,
                        child: PopupMenuButton<MapType>(
                          offset: const Offset(0, 54),
                          icon: const Icon(Icons.layers_outlined),
                          onSelected: (MapType item) {
                            setState(() {
                              _currentMapType = item;
                            });
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<MapType>>[
                                const PopupMenuItem<MapType>(
                                  value: MapType.normal,
                                  child: Text('Normal'),
                                ),
                                const PopupMenuItem<MapType>(
                                  value: MapType.satellite,
                                  child: Text('Satellite'),
                                ),
                                const PopupMenuItem<MapType>(
                                  value: MapType.terrain,
                                  child: Text('Terrain'),
                                ),
                                const PopupMenuItem<MapType>(
                                  value: MapType.hybrid,
                                  child: Text('Hybrid'),
                                ),
                              ],
                        ),
                      ),
                      FloatingActionButton.small(
                        heroTag: "zoom-in",
                        onPressed: () {
                          _mapController?.animateCamera(CameraUpdate.zoomIn());
                        },
                        child: const Icon(Icons.add),
                      ),
                      FloatingActionButton.small(
                        heroTag: "zoom-out",
                        onPressed: () {
                          _mapController?.animateCamera(CameraUpdate.zoomOut());
                        },
                        child: const Icon(Icons.remove),
                      ),
                    ],
                  ),
                ),
                if (_placemark != null)
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _placemark!.street ?? "Unknown street",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${_placemark!.subLocality ?? ""}, '
                              '${_placemark!.locality ?? ""}, '
                              '${_placemark!.subAdministrativeArea ?? ""}, '
                              '${_placemark!.administrativeArea ?? ""}, '
                              '${_placemark!.postalCode ?? ""}, '
                              '${_placemark!.country ?? ""}',
                            ),
                            SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                    ),
                                    onPressed: () => context.pop(),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.cancel_outlined,
                                          color: Colors.red,
                                        ),
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
                                      backgroundColor:
                                          AppColors.lightTeal.color,
                                    ),
                                    onPressed: () {
                                      if (_currentLatLng != null &&
                                          _placemark != null) {
                                        mapProvider.setLatLng(_currentLatLng!);
                                        mapProvider.setPlacemark(_placemark!);
                                        context.go('/home/post');
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Please tap the map to select a location",
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.add_location_outlined,
                                          color: Colors.black,
                                        ),
                                        Text(
                                          "Pick",
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
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
