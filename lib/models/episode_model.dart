import 'package:movie_db/helpers/debug_mode.dart';

import 'helper_model/formated_timer_generator.dart';
import 'movies/cast_info_model.dart';

class EpisodeModel {
  final String id;
  final String name;
  final String overview;
  final String seasonNumber;
  final String stillPath;
  final double voteAverage;
  final String date;
  final String number;
  final String customDate;
  final List<CastInfo> castInfoList;

  EpisodeModel({
    required this.id,
    required this.name,
    required this.overview,
    required this.seasonNumber,
    required this.stillPath,
    required this.voteAverage,
    required this.date,
    required this.number,
    required this.customDate,
    required this.castInfoList,
  });

  factory EpisodeModel.fromJson(json) {
    String string = "Not Available";
    void getString() {
      try {
        string =
            "${monthgenrater(json['air_date'].split("-")[1])} ${json['air_date'].split("-")[2]}, ${json['air_date'].split("-")[0]}";
        // ignore: empty_catches
      } catch (e) {
        printLog(level: LogLevel.error, error: e, message: 'Episode Model: ');
      }
    }

    getString();
    return EpisodeModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      overview: json['overview'] ?? '',
      seasonNumber: json['season_number'].toString(),
      stillPath: json['still_path'] != null
          ? "https://image.tmdb.org/t/p/w500" + json['still_path']
          : "https://images.pexels.com/photos/4089658/pexels-photo-4089658.jpeg?cs=srgb&dl=pexels-victoria-borodinova-4089658.jpg&fm=jpg",
      voteAverage: json['vote_average'].toDouble() ?? 0.0,
      date: json['air_date'],
      number: json['episode_number'].toString(),
      castInfoList: (json['guest_stars'] as List)
          .map((star) => CastInfo.fromJson(star))
          .toList(),
      customDate: string,
    );
  }
}
