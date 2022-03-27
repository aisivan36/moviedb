import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movie_db/constants/api.dart';
import 'package:movie_db/helpers/debug_mode.dart';
import 'package:movie_db/models/error_model.dart';
import 'package:movie_db/models/movies/movie_model.dart';
import 'package:movie_db/models/people_model.dart';
import 'package:movie_db/models/tv_models/tv_model.dart';

class SearchResultsRepo {
  Future<List<dynamic>> getMovies(String query, int page) async {
    http.Response response = await http.get(Uri.parse(
        baseURL + '/search/movie?text=$query&page=${page.toString()}'));

    try {
      if (response.statusCode == 200) {
        return [
          (jsonDecode(response.body)['data'] as List)
              .map((list) => MovieModel.fromJson(list))
              .toList(),
          jsonDecode(response.body)['total_pages'],
        ];
      } else {
        Exception? err;
        printLog(
            level: LogLevel.error,
            message: 'Search Results getMovies',
            error: err);
        throw const FetchDataError(message: "Something went wrong!");
      }
    } catch (err) {
      printLog(
          level: LogLevel.error,
          message: 'Search Results getMovies 2',
          error: err);
      throw const FetchDataError(message: "Something went wrong!");
    }
  }

  Future<List<dynamic>> gettvShows(String query, int page) async {
    var res = await http.get(
        Uri.parse(baseURL + '/search/tv?text=$query&page=${page.toString()}'));
    try {
      if (res.statusCode == 200) {
        return [
          (jsonDecode(res.body)['data'] as List)
              .map((list) => TvModel.fromJson(list))
              .toList(),
          jsonDecode(res.body)['total_pages'],
        ];
      } else {
        Exception? err;
        printLog(
            level: LogLevel.error,
            message: 'Search Results getTvShows',
            error: err);
        throw const FetchDataError(message: "Something went wrong!");
      }
    } catch (err) {
      printLog(
          level: LogLevel.error,
          message: 'Search Results Get TV SHOWs 2',
          error: err);
      throw const FetchDataError(message: "Something went wrong!");
    }
  }

  Future<List<dynamic>> getPersons(String query, int page) async {
    var res = await http.get(Uri.parse(
        baseURL + '/search/person?text=$query&page=${page.toString()}'));

    try {
      if (res.statusCode == 200) {
        return [
          (jsonDecode(res.body)['data'] as List)
              .map((list) => PeopleModel.fromJson(list))
              .toList(),
          jsonDecode(res.body)['total_pages'],
        ];
      } else {
        Exception? err;
        printLog(
            level: LogLevel.error,
            message: 'Search Results Get Persons',
            error: err);
        throw const FetchDataError(message: "Something went wrong!");
      }
    } catch (err) {
      printLog(
          level: LogLevel.error,
          message: 'Search Results Get Persons 2',
          error: err);
      throw const FetchDataError(message: "Something went wrong!");
    }
  }
}
