import 'package:movie_db/helpers/debug_mode.dart';
import 'package:movie_db/models/tv_models/season_tvmodel.dart';

import '../helper_model/formated_timer_generator.dart';

class TvInfoModel {
  final String tmdbId;
  final String overview;
  final String title;
  final List languages;
  final String backdrops;
  final String poster;
  final String tagline;
  final double rating;
  final String homepage;
  final List genres;
  final List<Seasons> seasons;
  final List created;
  final List networks;
  final String numberOfSeasons;
  final String date;
  final String formatedDate;
  final String episoderuntime;
  TvInfoModel({
    required this.tmdbId,
    required this.overview,
    required this.title,
    required this.languages,
    required this.backdrops,
    required this.poster,
    required this.tagline,
    required this.rating,
    required this.homepage,
    required this.genres,
    required this.seasons,
    required this.created,
    required this.networks,
    required this.numberOfSeasons,
    required this.date,
    required this.formatedDate,
    required this.episoderuntime,
  });
  factory TvInfoModel.fromJson(json) {
    String string = "Not Available";
    try {
      string =
          "${monthgenrater(json['first_air_date'].split("-")[1])} ${json['first_air_date'].split("-")[2]}, ${json['first_air_date'].split("-")[0]}";
    } catch (e) {
      printLog(level: LogLevel.error, error: e, message: 'TV INFO MODEL: ');
    }
    return TvInfoModel(
      title: json['name'] ?? '',
      homepage: json['homepage'] ?? "",
      languages: (json['spoken_languages'] as List)
          .map((laung) => laung['english_name'])
          .toList(),
      created:
          (json['created_by'] as List).map((laung) => laung['name']).toList(),
      genres: (json['genres'] as List).map((laung) => laung['name']).toList(),
      networks:
          (json['networks'] as List).map((laung) => laung['name']).toList(),
      overview: json['overview'] ?? '',
      backdrops: json['backdrop_path'] != null
          ? "https://image.tmdb.org/t/p/w500" + json['backdrop_path']
          : "https://images.pexels.com/photos/4089658/pexels-photo-4089658.jpeg?cs=srgb&dl=pexels-victoria-borodinova-4089658.jpg&fm=jpg",
      poster: json['poster_path'] != null
          ? "https://image.tmdb.org/t/p/w500" + json['poster_path']
          : "https://images.pexels.com/photos/4089658/pexels-photo-4089658.jpeg?cs=srgb&dl=pexels-victoria-borodinova-4089658.jpg&fm=jpg",
      rating: json['vote_average'].toDouble() ?? 0.0,
      tagline: json['tagline'] ?? '',
      tmdbId: json['id'].toString(),
      numberOfSeasons: json['number_of_seasons'].toString(),
      seasons: (json['seasons'] as List)
          .map((season) => Seasons.fromJson(season))
          .toList(),
      date: json['first_air_date'] ?? '',
      episoderuntime: (json['episode_run_time'] as List).isNotEmpty
          ? json['episode_run_time'][0].toString() + " Minutes"
          : "N/A",
      formatedDate: string,
    );
  }
}
