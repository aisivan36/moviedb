import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_db/animation.dart';

import 'package:movie_db/constants/theme.dart';
import 'package:movie_db/screens/movie_detail_screen/movie_detail_screen.dart';
import 'package:movie_db/screens/tvshow_detail_screen/tvshow_detail_screen.dart';
import 'package:movie_db/widgets/star_icon_widget.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({
    Key? key,
    required this.poster,
    required this.name,
    required this.backdrop,
    required this.date,
    required this.id,
    required this.color,
    required this.onTap,
    required this.isMovie,
  }) : super(key: key);

  final String poster;
  final String name;
  final String backdrop;
  final String date;
  final String id;
  final Color color;
  final VoidCallback onTap;
  final bool isMovie;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 200),
          child: SizedBox(
            // color: Colors.red,
            width: 130,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.shade900,
                    border: Border.all(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        width: 01.31),
                    boxShadow: kElevationToShadow[8],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: poster,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: normalText.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  date,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: normalText.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: color.withOpacity(0.8)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Horizontal Movie Card
class HorizontalMovieCard extends StatelessWidget {
  /// Whether it is movie false or true
  const HorizontalMovieCard({
    Key? key,
    required this.poster,
    required this.name,
    required this.backdrop,
    required this.date,
    required this.rate,
    required this.id,
    required this.color,
    this.isMovie = false,
  }) : super(key: key);
  final String poster;
  final String name;
  final String backdrop;
  final String date;
  final double rate;
  final String id;
  final Color color;

  /// Whether it is movie false or true
  final bool isMovie;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: InkWell(
        onTap: () {
          if (isMovie) {
            pushNewScreen(
              context,
              MovieDetailScreen(backdrop: backdrop, id: id),
            );
          } else {
            pushNewScreen(
              context,
              TvShowDetailScreen(id: id, backdrop: backdrop),
            );
            Scaffold(
              appBar: AppBar(
                title: const Text('TODO Tv Show Detail Screen'),
              ),
            );
          }
        },
        child: Row(
          children: [
            Flexible(
              flex: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  boxShadow: kElevationToShadow[8],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: AspectRatio(
                    aspectRatio: 9 / 14,
                    child: CachedNetworkImage(
                      imageUrl: poster,
                      fit: BoxFit.cover,
                      progressIndicatorBuilder: (BuildContext context,
                          String url, DownloadProgress downloadProgress) {
                        return ColoredBox(color: Colors.grey[900]!);
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Flexible(
              fit: FlexFit.tight,
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: normalText.copyWith(
                        fontSize: 18,
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      date,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: normalText.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: color.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        IconTheme(
                          data: const IconThemeData(
                            color: Colors.cyanAccent,
                            size: 20,
                          ),
                          child: StarDisplay(
                            value: ((rate * 5) / 10).round(),
                          ),
                        ),
                        Text(
                          '  $rate/10',
                          style: normalText.copyWith(
                              color: Colors.amber, letterSpacing: 1.2),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
