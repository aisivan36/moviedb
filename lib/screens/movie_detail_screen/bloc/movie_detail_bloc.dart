import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_db/helpers/debug_mode.dart';
import 'package:movie_db/models/error_model.dart';
import 'package:movie_db/models/movies/image_backdrop_model.dart';
import 'package:movie_db/models/movies/movie_info_imdb_model.dart';
import 'package:movie_db/models/movies/movie_info_model.dart';
import 'package:movie_db/models/movies/trailer_model.dart';
import 'package:movie_db/services/fetch_movie_data_by_id.dart';

import '../../../models/movies/cast_info_model.dart';
import '../../../models/movies/movie_model.dart';

part 'movie_detail_event.dart';
part 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final repo = FetchMovieDataById();
  MovieDetailBloc() : super(MovieDetailInitial()) {
    on<MovieDetailEvent>(_onEvent);
  }

  Future<void> _onEvent(
      MovieDetailEvent event, Emitter<MovieDetailState> emit) async {
    if (event is LoadMoviesDetail) {
      try {
        emit(MovieDetailLoading());

        final List<dynamic> info = await repo.getDetails(event.id);

        emit(MovieDetailLoaded(
          imdbData: info[4],
          trailers: info[1],
          backdrops: info[2],
          tmdbData: info[0],
          cast: info[3],
          similar: info[5],
        ));
      } on FetchDataError catch (err) {
        printLog(
            level: LogLevel.error, message: 'Bloc Movie Detail 1', error: err);

        emit(MovieDatailError(error: err));
      } catch (err) {
        printLog(
            level: LogLevel.error, message: 'Bloc Movie Detail 2', error: err);
        emit(MovieDatailError(error: FetchDataError(message: err.toString())));
      }
    }
  }
}
