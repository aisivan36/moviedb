import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movie_db/constants/api.dart';
import 'package:movie_db/helpers/debug_mode.dart';
import 'package:movie_db/models/cast_info_personal_model.dart';
import 'package:movie_db/models/error_model.dart';
import 'package:movie_db/models/movies/image_backdrop_model.dart';
import 'package:movie_db/models/movies/movie_model.dart';
import 'package:movie_db/models/tv_models/tv_model.dart';

class FetchCastInfoById {
  Future<List<dynamic>> getCastDetails(String id) async {
    CastPersonalInfo prinfo;
    SocialMediaInfo socialMediaInfo;
    ImageBackdropList backdropList;
    MovieModelList movies;
    TvModelList tv;

    http.Response response = await http.get(Uri.parse('$baseURL/person/$id'));

    try {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        prinfo = CastPersonalInfo.fromJson(data['data']);
        socialMediaInfo = SocialMediaInfo.fromJson(data['socialmedia']);
        backdropList = ImageBackdropList.fromJson(data['images']['profiles']);

        movies = MovieModelList.fromJson(data['movies']['cast']);
        tv = TvModelList.fromJson(data['tv']['cast']);

        return [
          prinfo,
          socialMediaInfo,
          backdropList.backdrops,
          movies.movies,
          tv.movies,
        ];
      } else {
        Exception? err;
        printLog(
            level: LogLevel.error,
            message: 'Fetch Cast Details Exception',
            error: err);
        throw Exception();
      }
    } catch (err) {
      printLog(
          level: LogLevel.error, message: 'Fetch Cast Details', error: err);
      throw FetchDataError.set(err.toString());
    }
  }
}
