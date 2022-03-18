import 'package:movie_db/helpers/debug_mode.dart';

import 'episode_model.dart';
import 'helper_model/formated_timer_generator.dart';

class SeasonModel {
  final String name;
  final String overview;
  final String id;
  final String posterPath;
  final String seasonNumber;
  final String customDate;
  final List<EpisodeModel> episodes;
  SeasonModel({
    required this.name,
    required this.overview,
    required this.id,
    required this.posterPath,
    required this.seasonNumber,
    required this.customDate,
    required this.episodes,
  });

  factory SeasonModel.fromJson(json) {
    String string = "Not Available";
    void getString() {
      try {
        string =
            "${monthgenrater(json['air_date'].split("-")[1])} ${json['air_date'].split("-")[2]}, ${json['air_date'].split("-")[0]}";
        // ignore: empty_catches
      } catch (e) {
        printLog(level: LogLevel.error, message: 'Season Model: ', error: e);
      }
    }

    getString();
    return SeasonModel(
      name: json['name'] ?? '',
      overview: json['overview'] == "" ? "N/A" : json['overview'] ?? "",
      id: json['id'].toString(),
      posterPath: json['poster_path'] != null
          ? "https://image.tmdb.org/t/p/w500" + json['poster_path']
          : "https://images.pexels.com/photos/4089658/pexels-photo-4089658.jpeg?cs=srgb&dl=pexels-victoria-borodinova-4089658.jpg&fm=jpg",
      seasonNumber: json['season_number'].toString(),
      episodes: ((json['episodes'] ?? []) as List)
          .map((episode) => EpisodeModel.fromJson(episode))
          .toList(),
      customDate: string,
    );
  }
}
