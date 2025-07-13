import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:storyapp/provider/map_provider.dart';
import 'package:storyapp/style/colors/app_colors.dart';
import 'package:storyapp/style/typography/story_app_text_styles.dart';
import 'package:storyapp/utils/date_utils_helper.dart';

import '../model/story.dart';

class StoryCard extends StatefulWidget {
  final Story stories;
  final Function() onTap;

  const StoryCard({super.key, required this.stories, required this.onTap});

  @override
  State<StoryCard> createState() => _StoryCardState();
}

class _StoryCardState extends State<StoryCard> {
  Placemark? placemark;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      if (widget.stories.lat != null && widget.stories.lon != null) {
        final placemarks = await context.read<MapProvider>().getPlacemark(
          LatLng(widget.stories.lat!, widget.stories.lon!),
        );

        if (placemarks.isNotEmpty) {
          setState(() {
            placemark = placemarks.first;
          });
        }
      }
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

    return GestureDetector(
      onTap: widget.onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.warmPeach.color,
                  child: Text(
                    widget.stories.name.isNotEmpty
                        ? widget.stories.name[0].toUpperCase()
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
                      widget.stories.name,
                      style: StoryAppTextStyles.bodyLargeBold,
                    ),
                    placemark != null
                        ? Row(
                            children: [
                              Icon(Icons.pin_drop_outlined, size: 15),
                              SizedBox(width: 6),
                              textWidth > MediaQuery.sizeOf(context).width * 0.6
                                  ? SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.7,
                                      height: 20,
                                      child: Marquee(
                                        text:
                                            "${placemark!.subAdministrativeArea.toString()}, ${placemark!.administrativeArea.toString()}",
                                        style:
                                            StoryAppTextStyles.bodyLargeMedium,
                                        scrollAxis: Axis.horizontal,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        blankSpace: 20.0,
                                        numberOfRounds: 1,
                                        velocity: 30.0,
                                        pauseAfterRound: Duration(seconds: 1),
                                        startPadding: 10.0,
                                        accelerationDuration: Duration(
                                          seconds: 1,
                                        ),
                                        accelerationCurve: Curves.fastOutSlowIn,
                                        decelerationDuration: Duration(
                                          milliseconds: 500,
                                        ),
                                        decelerationCurve: Curves.easeOut,
                                      ),
                                    )
                                  : Text(
                                      "${placemark!.subAdministrativeArea.toString()}, ${placemark!.administrativeArea.toString()}",
                                      style: StoryAppTextStyles.bodyLargeMedium,
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
                imageUrl: widget.stories.photoUrl,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(
                    color: AppColors.lightTeal.color,
                  ),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),

          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text.rich(
              maxLines: 2,
              TextSpan(
                children: [
                  TextSpan(
                    text: widget.stories.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: " ${widget.stories.description}"),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(DateUtilsHelper.getTimeAgo(widget.stories.createdAt)),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
