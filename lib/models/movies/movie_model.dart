import 'package:movie_db/helpers/debug_mode.dart';

import '../helper_model/formated_timer_generator.dart';

class MovieModel {
  final String title;
  final String poster;
  final String id;
  final String backdrop;
  final double voteAverage;
  final String releaseDate;
  MovieModel({
    required this.title,
    required this.poster,
    required this.id,
    required this.backdrop,
    required this.voteAverage,
    required this.releaseDate,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    String string = "Not Available";
    void getString() {
      try {
        string =
            "${monthgenrater(json['release_date'].split("-")[1])} ${json['release_date'].split("-")[2]}, ${json['release_date'].split("-")[0]}";
        // ignore: empty_catches
      } catch (e) {
        printLog(message: 'Movie Model:', error: e, level: LogLevel.error);
      }
    }

    getString();
    return MovieModel(
      backdrop: json['backdrop_path'] != null
          ? "https://image.tmdb.org/t/p/w500" + json['backdrop_path']
          : "https://images.pexels.com/photos/4089658/pexels-photo-4089658.jpeg?cs=srgb&dl=pexels-victoria-borodinova-4089658.jpg&fm=jpg",
      poster: json['poster_path'] != null
          ? "https://image.tmdb.org/t/p/w500" + json['poster_path']
          : "https://images.pexels.com/photos/4089658/pexels-photo-4089658.jpeg?cs=srgb&dl=pexels-victoria-borodinova-4089658.jpg&fm=jpg",
      id: json['id'].toString(),
      title: json['title'] ?? '',
      voteAverage: json['vote_average'].toDouble() ?? 0.0,
      releaseDate: string,
    );
  }
}

class MovieModelList {
  final List<MovieModel> movies;
  MovieModelList({
    required this.movies,
  });
  factory MovieModelList.fromJson(List<dynamic> json) {
    return MovieModelList(
      movies: (json).map((list) => MovieModel.fromJson(list)).toList(),
    );
  }
}
