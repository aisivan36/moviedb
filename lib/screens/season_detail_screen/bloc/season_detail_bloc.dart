import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_db/helpers/debug_mode.dart';
import 'package:movie_db/models/error_model.dart';
import 'package:movie_db/models/movies/cast_info_model.dart';
import 'package:movie_db/models/movies/image_backdrop_model.dart';
import 'package:movie_db/models/movies/trailer_model.dart';
import 'package:movie_db/models/season_model.dart';
import 'package:movie_db/services/fetch_season_details.dart';

part 'season_detail_event.dart';
part 'season_detail_state.dart';

class SeasonDetailBloc extends Bloc<SeasonDetailEvent, SeasonDetailState> {
  final repo = FetchSeasonDetail();

  SeasonDetailBloc() : super(SeasonDetailInitial()) {
    on<SeasonDetailEvent>(_onEvent);
  }

  void _onEvent(
    SeasonDetailEvent event,
    Emitter<SeasonDetailState> emit,
  ) async {
    if (event is LoadSeasonInfo) {
      try {
        emit(SeasonDetailLoading());

        final data = await repo.getSeasonDetail(event.id, event.snum);
        emit(SeasonDetailLoaded(
          backdropList: data[3],
          cast: data[1],
          seasonModel: data[0],
          trailers: data[2],
        ));
      } catch (err) {
        printLog(
            level: LogLevel.error, message: 'Season Detail bloc', error: err);

        emit(SeasonDetailError(error: FetchDataError.set(err.toString())));
      }
    }
  }
}
