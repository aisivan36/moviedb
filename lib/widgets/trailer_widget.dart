import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_db/animation.dart';
import 'package:movie_db/constants/theme.dart';
import 'package:movie_db/models/movies/image_backdrop_model.dart';
import 'package:movie_db/models/movies/trailer_model.dart';
import 'package:movie_db/widgets/video_player.dart';

class TrailerWidget extends StatelessWidget {
  const TrailerWidget({
    Key? key,
    required this.backdrop,
    required this.backdropsList,
    required this.trailers,
  }) : super(key: key);

  final List<TrailerModel> trailers;
  final List<ImageBackdrop> backdropsList;
  final String backdrop;

  @override
  Widget build(BuildContext context) {
    return DelayedDisplay(
      delay: const Duration(microseconds: 1100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              'Trailers',
              style: heading.copyWith(color: Colors.white),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: trailers.map((data) {
                if (data.site == 'YouTube') {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: GestureDetector(
                      onTap: () {
                        //
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => VideoPlayer(id: data.key),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey[900],
                                    boxShadow: kElevationToShadow[12],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      imageUrl: backdrop.isNotEmpty
                                          ? backdropsList[0].image
                                          : backdrop,
                                      height: 120,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 120,
                                  width: 200,
                                  child: Center(
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.6),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.play_arrow,
                                        size: 30,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return const SizedBox.shrink(
                    child: Text('Empty'),
                  );
                }
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
