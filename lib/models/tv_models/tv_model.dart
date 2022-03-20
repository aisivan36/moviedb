import 'package:movie_db/helpers/debug_mode.dart';

import '../helper_model/formated_timer_generator.dart';

class TvModel {
  final String title;
  final String poster;
  final String id;
  final String backdrop;
  final double voteAverage;
  final String year;
  final String releaseDate;
  TvModel({
    required this.title,
    required this.poster,
    required this.id,
    required this.backdrop,
    required this.voteAverage,
    required this.year,
    required this.releaseDate,
  });

  factory TvModel.fromJson(Map<String, dynamic> json) {
    String string = "Not Available";
    // print('first $string');
    Future<void> getString() async {
      try {
        string =
            "${monthgenrater(await json['first_air_date'].split("-")[1])} ${await json['first_air_date'].split("-")[2]}, ${await json['first_air_date'].split("-")[0]}";

        // print('Second $string');
      } catch (e) {
        printLog(level: LogLevel.error, error: e, message: 'TV MODEL');
      }
    }

    getString();
    return TvModel(
      backdrop: json['backdrop_path'] != null
          ? "https://image.tmdb.org/t/p/w500" + json['backdrop_path']
          : "https://images.pexels.com/photos/4089658/pexels-photo-4089658.jpeg?cs=srgb&dl=pexels-victoria-borodinova-4089658.jpg&fm=jpg",
      poster: json['poster_path'] != null
          ? "https://image.tmdb.org/t/p/w500" + json['poster_path']
          : "https://images.pexels.com/photos/4089658/pexels-photo-4089658.jpeg?cs=srgb&dl=pexels-victoria-borodinova-4089658.jpg&fm=jpg",
      id: json['id'].toString(),
      title: json['name'],
      year: json['first_air_date'].toString(),
      voteAverage: json['vote_average'].toDouble() ?? 0.0,
      releaseDate: string,
    );
  }
}

class TvModelList {
  final List<TvModel> movies;
  TvModelList({
    required this.movies,
  });
  factory TvModelList.fromJson(List<dynamic> json) {
    return TvModelList(
        movies: (json).map((list) => TvModel.fromJson(list)).toList());
  }
}
