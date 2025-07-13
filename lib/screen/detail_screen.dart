import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:storyapp/provider/detail_provider.dart';
import 'package:storyapp/provider/map_provider.dart';
import 'package:storyapp/static/story_detail_result_state.dart';

import '../style/colors/app_colors.dart';
import '../style/typography/story_app_text_styles.dart';
import '../utils/date_utils_helper.dart';

class DetailScreen extends StatefulWidget {
  final String id;
  final LatLng? latLng;

  const DetailScreen({super.key, required this.id, this.latLng});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Placemark? placemark;
  final Set<Marker> markers = {};
  late LatLng _position;

  late GoogleMapController mapController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      context.read<DetailProvider>().getDetailStory(widget.id);
      context.read<MapProvider>().setIsMapPicker(false);
      final latLng = widget.latLng;
      if (latLng != null) {
        final placemarks = await context.read<MapProvider>().getPlacemark(
          latLng,
        );
        if (placemarks.isNotEmpty) {
          setState(() {
            placemark = placemarks.first;
          });
        }
      }
      _position = LatLng(widget.latLng!.latitude, widget.latLng!.longitude);
      final marker = Marker(
        draggable: true,
        markerId: const MarkerId("story"),
        position: _position,
        onTap: () {
          mapController.animateCamera(
            CameraUpdate.newLatLngZoom(_position, 19),
          );
        },
      );
      markers.add(marker);
    });
  }

  @override
  Widget build(BuildContext context) {
    double textWidth = 0;
    if (placemark != null) {
      String text =
          "${placemark!.subAdministrativeArea.toString()}, ${placemark!.administrativeArea.toString()}";
      TextStyle style = StoryAppTextStyles.bodyLargeMedium;

      final textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr,
      )..layout();
      textWidth = textPainter.size.width;
    }
    return Consumer<DetailProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Story App", style: StoryAppTextStyles.headlineMedium),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Consumer<DetailProvider>(
                builder: (context, value, child) {
                  return switch (value.resultState) {
                    StoryDetailLoadingState() => Center(
                      child: CircularProgressIndicator(
                        color: AppColors.lightTeal.color,
                      ),
                    ),
                    StoryDetailLoadedState(story: var story) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: AppColors.warmPeach.color,
                                child: Text(
                                  story.name.isNotEmpty
                                      ? story.name[0].toUpperCase()
                                      : '?',
                                  style: TextStyle(
                                    color: AppColors.darkTeal.color,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    story.name,
                                    style: StoryAppTextStyles.bodyLargeBold,
                                  ),
                                  placemark != null
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.pin_drop_outlined,
                                              size: 15,
                                            ),
                                            SizedBox(width: 6),
                                            textWidth >
                                                    MediaQuery.sizeOf(
                                                          context,
                                                        ).width *
                                                        0.6
                                                ? SizedBox(
                                                    width:
                                                        MediaQuery.of(
                                                          context,
                                                        ).size.width *
                                                        0.7,
                                                    height: 20,
                                                    child: Marquee(
                                                      text:
                                                          "${placemark!.subAdministrativeArea.toString()}, ${placemark!.administrativeArea.toString()}",
                                                      style: StoryAppTextStyles
                                                          .bodyLargeMedium,
                                                      scrollAxis:
                                                          Axis.horizontal,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      blankSpace: 20.0,
                                                      numberOfRounds: 1,
                                                      velocity: 30.0,
                                                      pauseAfterRound: Duration(
                                                        seconds: 1,
                                                      ),
                                                      startPadding: 10.0,
                                                      accelerationDuration:
                                                          Duration(seconds: 1),
                                                      accelerationCurve:
                                                          Curves.fastOutSlowIn,
                                                      decelerationDuration:
                                                          Duration(
                                                            milliseconds: 500,
                                                          ),
                                                      decelerationCurve:
                                                          Curves.easeOut,
                                                    ),
                                                  )
                                                : Text(
                                                    "${placemark!.subAdministrativeArea.toString()}, ${placemark!.administrativeArea.toString()}",
                                                    style: StoryAppTextStyles
                                                        .bodyLargeMedium,
                                                  ),
                                          ],
                                        )
                                      : SizedBox.shrink(),
                                ],
                              ),
                              const Spacer(),
                              const Icon(Icons.more_vert),
                            ],
                          ),
                        ),

                        Container(
                          color: Colors.black,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            child: CachedNetworkImage(
                              width: double.infinity,
                              height: 300,
                              fit: BoxFit.scaleDown,
                              imageUrl: story.photoUrl,
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.lightTeal.color,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: story.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(text: " ${story.description}"),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            DateUtilsHelper.getTimeAgo(story.createdAt),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                    StoryDetailErrorState(errorMessage: var message) => Center(
                      child: Text(message),
                    ),
                    _ => const SizedBox(),
                  };
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void defineMarker(LatLng latLng, String street, String address) {
    final marker = Marker(
      markerId: const MarkerId("source"),
      position: latLng,
      infoWindow: InfoWindow(title: street, snippet: address),
    );

    setState(() {
      markers.clear();
      markers.add(marker);
    });
  }
}
