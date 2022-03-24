import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_db/constants/theme.dart';
import 'package:movie_db/models/genre_model.dart';

class GenreTile extends StatelessWidget {
  const GenreTile({Key? key, required this.genres}) : super(key: key);
  final Genres genres;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      borderRadius: BorderRadius.circular(8),
      child: ColoredBox(
        color: genres.color,
        child: Stack(
          children: [
            const SizedBox(
              height: double.infinity,
              width: double.infinity,
            ),
            Positioned(
              bottom: -5,
              right: -20,
              child: RotationTransition(
                turns: const AlwaysStoppedAnimation(380 / 360),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: CachedNetworkImage(
                      imageUrl: genres.image,
                      fit: BoxFit.cover,
                      width: 60,
                      height: 75,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
              child: Text(
                genres.name,
                style: normalText.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
