import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_db/helpers/debug_mode.dart';
import 'package:movie_db/models/error_model.dart';
import 'package:movie_db/models/movies/movie_model.dart';
import 'package:movie_db/models/tv_models/tv_model.dart';
import 'package:movie_db/services/fetch_genre_data.dart';

part 'genre_result_state.dart';

class GenreResultCubit extends Cubit<GenreResultState> {
  GenreResultCubit() : super(GenreResultState.initial());

  final repo = GenreResultsRepo();

  /// Initilize Movies
  void init(String query) async {
    try {
      emit(state.copyWith(movieStatus: MovieStatus.loading, query: query));

      final movies = await repo.getMovies(query, state.moviePage);
      emit(
        state.copyWith(
          movieStatus: MovieStatus.loaded,
          movies: movies[0],
          moviePage: state.moviePage + 1,
        ),
      );
    } catch (err) {
      printLog(
          level: LogLevel.error,
          message: 'Genre Reuslt Cubit init1',
          error: err);

      emit(
        state.copyWith(
          movieStatus: MovieStatus.error,
          fetchDataError: FetchDataError.set(err.toString()),
        ),
      );
    }
  }

  void loadNetxMoviePage() async {
    if (!state.moviesFull) {
      emit(state.copyWith(movieStatus: MovieStatus.adding));

      final movies = await repo.getMovies(state.query, state.moviePage);

      state.movies.addAll(movies[0]);

      emit(
        state.copyWith(
          movies: state.movies,
          moviePage: state.moviePage + 1,
          moviesFull: movies[1] != state.moviePage,
        ),
      );
    } else {
      emit(state.copyWith(movieStatus: MovieStatus.allFetchId));
    }
  }

  void loadNextTvPage() async {
    if (!state.tvFull) {
      emit(state.copyWith(tvStatus: TvStatus.adding));

      final shows = await repo.getTvShows(state.query, state.tvPage);

      state.shows.addAll(shows[0]);

      emit(
        state.copyWith(
            shows: state.shows,
            tvPage: state.tvPage,
            tvFull: shows[1] != state.tvPage),
      );
    } else {
      emit(state.copyWith(tvStatus: TvStatus.allFetched));
    }
  }

  /// Initilize Tvs
  void initTv(String query) async {
    try {
      emit(state.copyWith(tvStatus: TvStatus.loading));

      final shows = await repo.getTvShows(query, state.tvPage);

      emit(
        state.copyWith(
          tvStatus: TvStatus.loaded,
          shows: shows[0],
          tvPage: state.tvPage + 1,
        ),
      );
    } catch (err) {
      printLog(
          level: LogLevel.error,
          message: 'Genre Reuslt Cubit initTv',
          error: err);

      emit(
        state.copyWith(
          tvStatus: TvStatus.error,
          fetchDataError: FetchDataError(message: err.toString()),
        ),
      );
    }
  }

  // @override
  // void emit(GenreResultState state) {
  //   if (!isClosed) {
  //     super.emit(state);
  //   }
  // }
}
