import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/gestures.dart';
import 'package:movie_db/models/error_model.dart';
import 'package:movie_db/models/movies/cast_info_model.dart';
import 'package:movie_db/models/movies/image_backdrop_model.dart';
import 'package:movie_db/models/movies/trailer_model.dart';
import 'package:movie_db/models/tv_models/tv_model.dart';
import 'package:movie_db/models/tv_models/tvinfo_model.dart';
import 'package:movie_db/services/fetch_tv_show_detail.dart';

part 'tv_show_detail_event.dart';
part 'tv_show_detail_state.dart';

class TvShowDetailBloc extends Bloc<TvShowDetailEvent, TvShowDetailState> {
  final FetchTvShowDetail repo = FetchTvShowDetail();

  TvShowDetailBloc() : super(TvShowDetailInitial()) {
    on<TvShowDetailEvent>(_onEvent);
  }

  void _onEvent(
    TvShowDetailEvent event,
    Emitter<TvShowDetailState> emit,
  ) async {
    if (event is LoadTvInfo) {
      try {
        emit(TvShowDetailLoading());

        final data = await repo.getTvDetails(event.id);
        emit(
          TvShowDetailLoaded(
            tmdbData: data[0],
            similar: data[4],
            cast: data[3],
            backdrops: data[2],
            trailers: data[1],
          ),
        );
      } on FetchDataError catch (e) {
        emit(TvShowDetailError(error: e));
      } catch (err) {
        emit(TvShowDetailError(error: FetchDataError.set(err.toString())));
      }
    }
  }
}
