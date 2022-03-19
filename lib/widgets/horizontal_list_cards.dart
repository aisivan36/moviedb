import 'package:flutter/material.dart';

import 'package:movie_db/models/movies/movie_model.dart';
import 'package:movie_db/models/tv_models/tv_model.dart';
import 'package:movie_db/widgets/movie_cards.dart';

/// Horizontal List View Movies
class HorizontalListViewMovies extends StatelessWidget {
  const HorizontalListViewMovies({Key? key, this.color, required this.list})
      : super(key: key);

  final List<MovieModel> list;
  final Color? color;

  /// Movie Card
  List<Widget> movie() {
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
          // TODO PushNewScreen to MovieDetailsScreen
        },
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 310,
      child: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
          SizedBox(width: 7),
          for (int i = 0; i < list.length; i++)
            MovieCard(
              poster: list[i].poster,
              name: list[i].title,
              backdrop: list[i].backdrop,
              date: list[i].releaseDate,
              id: list[i].id,
              color: color == null ? Colors.white : color!,
              isMovie: true,
              onTap: () {
                // TODO PushNewScreen to MovieDetailsScreen
              },
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
          for (Widget i in movie())
            SizedBox(
              child: i,
            ),
        ],
      ),
    );
  }

  /// Movie Card
  List<Widget> movie() {
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
          // TODO PushNewScreen to MovieDetailsScreen
        },
      );
    }).toList();
  }
}
