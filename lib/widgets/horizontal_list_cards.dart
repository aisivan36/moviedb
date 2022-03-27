import 'package:flutter/material.dart';
import 'package:movie_db/animation.dart';

import 'package:movie_db/models/movies/movie_model.dart';
import 'package:movie_db/models/tv_models/tv_model.dart';
import 'package:movie_db/screens/movie_detail_screen/movie_detail_screen.dart';
import 'package:movie_db/widgets/movie_cards.dart';

/// Horizontal List View Movies
class HorizontalListViewMovies extends StatelessWidget {
  const HorizontalListViewMovies({Key? key, this.color, required this.list})
      : super(key: key);

  final List<MovieModel> list;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 310,
      child: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
          const SizedBox(width: 7),
          // for (int i = 0; i < list.length; i++)
          //   MovieCard(
          //     poster: list[i].poster,
          //     name: list[i].title,
          //     backdrop: list[i].backdrop,
          //     date: list[i].releaseDate,
          //     id: list[i].id,
          //     color: color == null ? Colors.white : color!,
          //     isMovie: true,
          //     onTap: () {
          //
          //     },
          //   ),
          ...list.map(
            (data) => MovieCard(
              poster: data.poster,
              name: data.title,
              backdrop: data.backdrop,
              date: data.releaseDate,
              id: data.id,
              color: color == null ? Colors.white : color!,
              isMovie: true,
              onTap: () {
                pushNewScreen(context,
                    MovieDetailScreen(backdrop: data.backdrop, id: data.id));
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Horizontal List View TV
class HorizontalListViewTv extends StatelessWidget {
  const HorizontalListViewTv({
    Key? key,
    required this.list,
    this.color,
  }) : super(key: key);
  final List<TvModel> list;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 310,
      child: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 7),
        children: [
          // const SizedBox(width: 7),
          // for (Widget i in movie())
          //   SizedBox(
          //     child: i,
          //   ),
          ...movie(context),
        ],
      ),
    );
  }

  /// Movie Card
  List<Widget> movie(BuildContext context) {
    return list.map((dataMovie) {
      return MovieCard(
        poster: dataMovie.poster,
        name: dataMovie.title,
        backdrop: dataMovie.backdrop,
        date: dataMovie.releaseDate,
        id: dataMovie.id,
        color: color == null ? Colors.white : color!,
        isMovie: true,
        onTap: () {
          pushNewScreen(
            context,
            MovieDetailScreen(backdrop: dataMovie.backdrop, id: dataMovie.id),
          );
        },
      );
    }).toList();
  }
}
