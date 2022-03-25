import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movie_db/constants/api.dart';
import 'package:movie_db/helpers/debug_mode.dart';
import 'package:movie_db/models/error_model.dart';
import 'package:movie_db/models/movies/movie_model.dart';
import 'package:movie_db/models/tv_models/tv_model.dart';

class GenreResultsRepo {
  Future<List<dynamic>> getMovies(String query, int page) async {
    http.Response res = await http
        .get(Uri.parse(baseURL + '/genre/movie?id=$query&p${page.toString()}'));
    if (res.statusCode == 200) {
      return [
        (jsonDecode(res.body)['data'] as List)
            .map((data) => MovieModel.fromJson(data))
            .toList(),
        jsonDecode(res.body)['total_pages'],
      ];
    } else {
      printLog(
          level: LogLevel.error,
          error: 'Something went wrong!',
          message: 'fetch Genre data');
      throw const FetchDataError(
          message: 'There is an error in the Fetch Genre repository');
    }
  }

  Future<List<dynamic>> getTvShows(String query, int page) async {
    http.Response res = await http
        .get(Uri.parse('$baseURL/genre/tv?id=$query&page=${page.toString()}'));

    if (res.statusCode == 200) {
      return [
        (jsonDecode(res.body)['data'] as List)
            .map((data) => TvModel.fromJson(data))
            .toList(),
        jsonDecode(res.body)['total_pages'],
      ];
    } else {
      printLog(
          level: LogLevel.error,
          error: 'Something went wrong!',
          message: 'fetch Genre data');

      throw const FetchDataError(
          message: 'There is an error in the Fetch Genre repository');
    }
  }
}
