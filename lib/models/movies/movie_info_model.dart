import '../../helpers/debug_mode.dart';
import '../helper_model/formated_timer_generator.dart';

class MovieInfoModel {
  final String tmdbId;
  final String overview;
  final String title;
  final List languages;
  final String backdrops;
  final String poster;
  final int budget;
  final String tagline;
  final double rateing;
  final String dateByMonth;
  final int runtime;
  final String homepage;
  final String imdbid;
  final List genres;
  final String releaseDate;
  MovieInfoModel({
    required this.tmdbId,
    required this.overview,
    required this.title,
    required this.languages,
    required this.backdrops,
    required this.poster,
    required this.budget,
    required this.tagline,
    required this.rateing,
    required this.dateByMonth,
    required this.runtime,
    required this.homepage,
    required this.imdbid,
    required this.genres,
    required this.releaseDate,
  });
  factory MovieInfoModel.fromJson(Map<String, dynamic> json) {
    String string = "";
    void getString() {
      try {
        string =
            "${monthgenrater(json['release_date'].split("-")[1])} ${json['release_date'].split("-")[2]}, ${json['release_date'].split("-")[0]}";
        // ignore: empty_catches
      } catch (e) {
        printLog(
            level: LogLevel.error, error: e, message: 'Movie Info Model: ');
      }
    }

    getString();
    return MovieInfoModel(
      budget: json['budget'],
      title: json['title'] ?? '',
      homepage: json['homepage'] ?? "",
      imdbid: json['imdb_id'] ?? "",
      languages: (json['spoken_languages'] as List)
          .map((laung) => laung['english_name'])
          .toList(),
      genres: (json['genres'] as List).map((laung) => laung['name']).toList(),
      overview: json['overview'] ?? json['actors'] ?? '',
      backdrops: json['backdrop_path'] != null
          ? "https://image.tmdb.org/t/p/original" + json['backdrop_path']
          : "https://images.pexels.com/photos/4089658/pexels-photo-4089658.jpeg?cs=srgb&dl=pexels-victoria-borodinova-4089658.jpg&fm=jpg",
      poster: json['poster_path'] != null
          ? "https://image.tmdb.org/t/p/w500" + json['poster_path']
          : "https://images.pexels.com/photos/4089658/pexels-photo-4089658.jpeg?cs=srgb&dl=pexels-victoria-borodinova-4089658.jpg&fm=jpg",
      rateing: json['vote_average'].toDouble() ?? 0.0,
      runtime: json['runtime'],
      tagline: json['tagline'] ?? json['actors'] ?? '',
      tmdbId: json['id'].toString(),
      releaseDate: json['release_date'] ?? '',
      dateByMonth: string,
    );
  }
}
