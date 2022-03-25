import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_db/animation.dart';
import 'package:movie_db/constants/theme.dart';
import 'package:movie_db/models/genre_model.dart';
import 'package:movie_db/screens/search_screen/genre/cubit/genre_result_cubit.dart';
import 'package:movie_db/screens/search_screen/genre/genre_results.dart';

class GenreTile extends StatelessWidget {
  const GenreTile({Key? key, required this.genres}) : super(key: key);
  final Genres genres;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: GestureDetector(
        onTap: () {
          pushNewScreen(
            context,
            BlocProvider<GenreResultCubit>(
              create: (context) => GenreResultCubit()..init(genres.id),
              child: GenreResults(query: genres.name),
            ),
          );
        },
        child: ClipRRect(
          // clipBehavior: Clip.antiAliasWithSaveLayer,
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 4.0),
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
        ),
      ),
    );
  }
}
