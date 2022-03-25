import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:hive_flutter/adapters.dart';
import 'package:movie_db/constants/api.dart';
import 'package:movie_db/helpers/debug_mode.dart';
import 'package:movie_db/models/error_model.dart';
import 'package:movie_db/models/movies/cast_info_model.dart';
import 'package:movie_db/models/movies/image_backdrop_model.dart';
import 'package:movie_db/models/movies/trailer_model.dart';
import 'package:movie_db/models/tv_models/tv_model.dart';
import 'package:movie_db/models/tv_models/tvinfo_model.dart';

class FetchTvShowDetail {
  Future<List<dynamic>> getTvDetails(String id) async {
    TvInfoModel info;
    TrailerList trailerList;
    ImageBackdropList backdropList;

    List images = [];

    CastInfoList castInfoList;
    TvModelList similarShows;

    Box box = Hive.box('Tv');
    String string = json.encode(box.get(id));

    var tv = jsonDecode(string);
    if (tv == null) {
      http.Response res = await http.get(Uri.parse('$baseURL/tv/$id'));

      if (res.statusCode == 200) {
        tv = jsonDecode(res.body);

        box.put(id, jsonDecode(res.body));
      } else {
        printLog(
            level: LogLevel.error,
            message: 'Fetch Tv Show detail',
            error: 'Check it out');

        throw FetchDataError.set('Something went worng!');
      }

      info = TvInfoModel.fromJson(tv['data']);
      trailerList = TrailerList.fromJson(tv['videos']);
      images.addAll(tv['images']['backdrops']);
      images.addAll(tv['images']['posters']);
      images.addAll(tv['images']['logos']);

      backdropList = ImageBackdropList.fromJson(images);
      castInfoList = CastInfoList.fromJson(tv['credits']);
      similarShows = TvModelList.fromJson(tv['similar']['results']);
      return [
        info,
        trailerList.trailers,
        backdropList.backdrops,
        castInfoList.castList,
        similarShows.movies,
      ];
    }
  }
}
