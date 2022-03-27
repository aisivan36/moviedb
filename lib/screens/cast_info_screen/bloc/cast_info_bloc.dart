import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_db/helpers/debug_mode.dart';
import 'package:movie_db/models/cast_info_personal_model.dart';
import 'package:movie_db/models/error_model.dart';
import 'package:movie_db/models/movies/image_backdrop_model.dart';
import 'package:movie_db/models/movies/movie_model.dart';
import 'package:movie_db/models/tv_models/tv_model.dart';
import 'package:movie_db/services/fetch_cast_details.dart';

part 'cast_info_event.dart';
part 'cast_info_state.dart';

class CastInfoBloc extends Bloc<CastInfoEvent, CastInfoState> {
  final FetchCastInfoById repo = FetchCastInfoById();

  CastInfoBloc() : super(CastInfoInitial()) {
    on<CastInfoEvent>(_onEvent);
  }
  void _onEvent(
    CastInfoEvent event,
    Emitter<CastInfoState> emit,
  ) async {
    if (event is LoadCastInfo) {
      try {
        emit(CastInfoLoading());

        final data = await repo.getCastDetails(event.id);

        emit(
          CastInfoLoaded(
            info: data[0],
            socialMediaInfo: data[1],
            tvShows: data[4],
            images: data[2],
            movies: data[3],
          ),
        );
      } catch (err) {
        printLog(level: LogLevel.error, message: 'Cast Info bloc', error: err);
        emit(
          CastInfoError(
            error: FetchDataError.set(err.toString()),
          ),
        );
      }
    }
  }
}
