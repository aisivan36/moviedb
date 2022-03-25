part of 'genre_result_cubit.dart';

enum MovieStatus {
  initial,
  loading,
  loaded,
  adding,
  error,
  allFetchId,
}

enum TvStatus {
  initial,
  loading,
  loaded,
  adding,

  allFetched,
  error,
}

class GenreResultState extends Equatable {
  const GenreResultState({
    required this.moviePage,
    required this.tvPage,
    required this.moviesFull,
    required this.tvFull,
    required this.query,
    required this.movieStatus,
    required this.tvStatus,
    required this.movies,
    required this.shows,
    required this.fetchDataError,
  });

  final int moviePage;
  final int tvPage;
  final bool moviesFull;
  final bool tvFull;
  final String query;
  final MovieStatus movieStatus;
  final TvStatus tvStatus;
  final List<MovieModel> movies;
  final List<TvModel> shows;

  /// Fetch Error Data
  final FetchDataError fetchDataError;

  factory GenreResultState.initial() {
    return const GenreResultState(
      tvPage: 1,
      tvStatus: TvStatus.initial,
      shows: [],
      moviePage: 1,
      movieStatus: MovieStatus.initial,
      tvFull: false,
      moviesFull: false,
      movies: [],
      query: '',
      fetchDataError: FetchDataError(message: 'Empty'),
    );
  }

  @override
  List<Object> get props {
    return [
      moviePage,
      tvPage,
      moviesFull,
      tvFull,
      query,
      movieStatus,
      tvStatus,
      movies,
      shows,
      fetchDataError,
    ];
  }

  GenreResultState copyWith({
    int? moviePage,
    int? tvPage,
    bool? moviesFull,
    bool? tvFull,
    String? query,
    MovieStatus? movieStatus,
    TvStatus? tvStatus,
    List<MovieModel>? movies,
    List<TvModel>? shows,
    FetchDataError? fetchDataError,
  }) {
    return GenreResultState(
      fetchDataError: fetchDataError ?? this.fetchDataError,
      moviePage: moviePage ?? this.moviePage,
      tvPage: tvPage ?? this.tvPage,
      moviesFull: moviesFull ?? this.moviesFull,
      tvFull: tvFull ?? this.tvFull,
      query: query ?? this.query,
      movieStatus: movieStatus ?? this.movieStatus,
      tvStatus: tvStatus ?? this.tvStatus,
      movies: movies ?? this.movies,
      shows: shows ?? this.shows,
    );
  }
}
