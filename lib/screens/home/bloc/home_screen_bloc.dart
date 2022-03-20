import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_db/helpers/debug_mode.dart';
import 'package:movie_db/models/error_model.dart';
import 'package:movie_db/models/movies/movie_model.dart';
import 'package:movie_db/models/tv_models/tv_model.dart';
import 'package:movie_db/services/fetch_home_screen.dart';

part 'home_screen_event.dart';
part 'home_screen_state.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  final FetchHomeRepository repository = FetchHomeRepository();

  HomeScreenBloc() : super(HomeScreenInitial()) {
    on<HomeScreenEvent>(getData);
  }

  void getData(HomeScreenEvent event, Emitter<HomeScreenState> emit) async {
    if (event is HomeScreenData) {
      emit(HomeScreenLoading());
      try {
        final data = await repository.getHomePageMovies();
        emit(HomeScreenLoaded(
          tranding: data[0],
          topRated: data[2],
          tvShows: data[5],
          topShows: data[4],
          upcoming: data[3],
          nowPlaying: data[1],
        ));
      } on FetchDataError catch (e) {
        printLog(level: LogLevel.error, error: e, message: 'Home Screen Bloc');

        emit(HomeScreenError(error: e));
      } catch (errr) {
        printLog(
            level: LogLevel.error, error: errr, message: 'Home Screen Bloc');

        emit(
          HomeScreenError(
            error: FetchDataError(message: errr.toString()),
          ),
        );
      }
    }
  }
}
