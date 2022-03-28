import 'dart:convert';

import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:movie_db/constants/api.dart';
import 'package:movie_db/helpers/debug_mode.dart';
import 'package:movie_db/models/error_model.dart';
import 'package:movie_db/models/movies/cast_info_model.dart';
import 'package:movie_db/models/movies/image_backdrop_model.dart';
import 'package:movie_db/models/movies/movie_info_imdb_model.dart';
import 'package:movie_db/models/movies/movie_info_model.dart';
import 'package:movie_db/models/movies/movie_model.dart';
import 'package:movie_db/models/movies/trailer_model.dart';

class FetchMovieDataById {
  ///
  Future<List<dynamic>> getDetails(String id) async {
    MovieInfoModel movieData;
    MovieInfoImdb omdbData;
    TrailerList trailerData;
    ImageBackdropList backdropDataList;
    CastInfoList castData;
    MovieModelList similarData;

    List<dynamic> images = [];
    Box box = Hive.box('Movies');
    String string = jsonEncode(box.get(id));
    var movie = jsonDecode(string);
    // Map<String, dynamic>? movie = jsonDecode(string);

    /// Check is movie is null then gain new object from it
    if (movie == null) {
      http.Response response = await http.get(Uri.parse('$baseURL/movie/$id'));
      if (response.statusCode == 200) {
        movie = jsonDecode(response.body);
        await box.put(id, jsonDecode(response.body));
      } else {
        throw FetchDataError.set('Something went wrong');
      }
    }

    movieData = MovieInfoModel.fromJson(movie?['data']);
    trailerData = TrailerList.fromJson(movie?['videos']);
    images.addAll(movie?['images']['backdrops']);
    images.addAll(movie?['images']['posters']);
    images.addAll(movie?['images']['logos']);

    backdropDataList = ImageBackdropList.fromJson(images);

    castData = CastInfoList.fromJson(movie?['credits']);

    similarData = MovieModelList.fromJson(movie?['similar']['results']);

    var imdbId = movieData.imdbid;
    final omdbResponse =
        await http.get(Uri.parse('$baseURL/movie/omdb/' + imdbId.toString()));

    // try {
    // if (omdbResponse.statusCode == 200) {
    omdbData = MovieInfoImdb.fromJson(jsonDecode(omdbResponse.body)?['data']);
    // }
    // } catch (err) {
    //   printLog(level: LogLevel.error, message: 'FetchMovie Data y', error: err);
    // }

    return [
      movieData,
      trailerData.trailers,
      backdropDataList.backdrops,
      castData.castList,
      omdbData,
      similarData.movies,
    ];
  }
}
