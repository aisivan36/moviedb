import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:movie_db/constants/theme.dart';

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
  final bool isMovie;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
