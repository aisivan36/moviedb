import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movie_db/constants/api.dart';
import 'package:movie_db/helpers/debug_mode.dart';

import 'package:movie_db/models/movies/movie_model.dart';
import 'package:movie_db/models/tv_models/tv_model.dart';

class FetchHomeRepository {
  Future<List<dynamic>> getHomePageMovies() async {
    MovieModelList trandingData;
    MovieModelList nowPlayingData;
    MovieModelList topRatedData;
    MovieModelList upcomingData;
    TvModelList tvShowData;
    TvModelList topRatedTvData;

    final response = await http.get(Uri.parse('$baseURL/home'));

    if (response.statusCode == 200) {
      trandingData =
          MovieModelList.fromJson(jsonDecode(response.body)['trandingMovies']);
      nowPlayingData = MovieModelList.fromJson(
          jsonDecode(response.body)['nowPlayingMovies']);
      topRatedData =
          MovieModelList.fromJson(json.decode(response.body)['topRatedMovies']);
      upcomingData =
          MovieModelList.fromJson(json.decode(response.body)['upcoming']);
      tvShowData =
          TvModelList.fromJson(json.decode(response.body)['trandingtv']);
      topRatedTvData =
          TvModelList.fromJson(json.decode(response.body)['topRatedTv']);

      return [
        trandingData.movies,
        nowPlayingData.movies,
        topRatedData.movies,
        upcomingData.movies,
        tvShowData.movies,
        topRatedTvData.movies,
      ];
    } else {
      printLog(level: LogLevel.error, message: 'Error Fetch-HomeRepo: ');
      throw Exception('Error Falied to Fetch Home Data');
    }
  }
}
