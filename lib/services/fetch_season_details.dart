import 'dart:convert';

import 'package:movie_db/constants/api.dart';
import 'package:movie_db/helpers/debug_mode.dart';
import 'package:movie_db/models/movies/cast_info_model.dart';
import 'package:movie_db/models/movies/image_backdrop_model.dart';
import 'package:movie_db/models/movies/trailer_model.dart';
import 'package:movie_db/models/season_model.dart';

import 'package:http/http.dart' as http;

class FetchSeasonDetail {
  Future<List<dynamic>> getSeasonDetail(String id, String snum) async {
    SeasonModel seasonInfoModel;
    CastInfoList castInfoList;
    TrailerList trailerList;

    ImageBackdropList backdropList;

    http.Response response =
        await http.get(Uri.parse('$baseURL/tv/$id/season/$snum'));

    try {
      if (response.statusCode == 200) {
        seasonInfoModel =
            SeasonModel.fromJson(jsonDecode(response.body)['data']);
        castInfoList =
            CastInfoList.fromJson(jsonDecode(response.body)['credits']);
        trailerList = TrailerList.fromJson(jsonDecode(response.body)['videos']);
        backdropList = ImageBackdropList.fromJson(
            jsonDecode(response.body)['images']['posters']);

        return [
          seasonInfoModel,
          castInfoList.castList,
          trailerList.trailers,
          backdropList.backdrops,
        ];
      } else {
        Exception? err;
        printLog(
            level: LogLevel.error,
            message: 'Fetch Season detail Exception',
            error: err);

        throw Exception();
      }
    } catch (err) {
      printLog(
          level: LogLevel.error, message: 'Fetch Season detail', error: err);

      throw Exception();
    }
  }
}
