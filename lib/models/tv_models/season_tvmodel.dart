import 'package:movie_db/helpers/debug_mode.dart';

import '../helper_model/formated_timer_generator.dart';

class Seasons {
  final String overview;
  final String name;
  final String id;
  final String image;
  final String date;
  final String customOverView;
  final String episodes;
  final String snum;
  Seasons({
    required this.overview,
    required this.name,
    required this.id,
    required this.image,
    required this.date,
    required this.customOverView,
    required this.episodes,
    required this.snum,
  });

  factory Seasons.fromJson(json) {
    String string = "Not Available";
    void getString() {
      try {
        string =
            "premiered on ${monthgenrater(json['air_date'].split("-")[1])} ${json['air_date'].split("-")[2]}, ${json['air_date'].split("-")[0]}";
      } catch (e) {
        printLog(level: LogLevel.error, error: e, message: 'Season TV MODEL: ');
      }
    }

    getString();
    return Seasons(
      date: json['air_date'] ?? '',
      episodes: json['episode_count'].toString(),
      id: json['id'].toString(),
      image: json['poster_path'] != null
          ? "https://image.tmdb.org/t/p/w500" + (json['poster_path'] ?? "")
          : "https://images.pexels.com/photos/4089658/pexels-photo-4089658.jpeg?cs=srgb&dl=pexels-victoria-borodinova-4089658.jpg&fm=jpg",
      name: json['name'] ?? '',
      overview: json['overview'] == "" ? "N/A" : json['overview'] ?? "",
      customOverView: string,
      snum: json['season_number'].toString(),
    );
  }
}
