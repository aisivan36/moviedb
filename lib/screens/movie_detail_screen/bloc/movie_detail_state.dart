part of 'movie_detail_bloc.dart';

abstract class MovieDetailState extends Equatable {
  const MovieDetailState();

  @override
  List<Object> get props => [];
}

class MovieDetailInitial extends MovieDetailState {}

class MovieDetailLoading extends MovieDetailState {}

class MovieDetailLoaded extends MovieDetailState {
  final MovieInfoModel tmdbData;
  final MovieInfoImdb imdbData;
  final List<MovieModel> similar;
  final List<CastInfo> cast;
  final List<ImageBackdrop> backdrops;
  final List<TrailerModel> trailers;

  const MovieDetailLoaded({
    required this.tmdbData,
    required this.imdbData,
    required this.similar,
    required this.cast,
    required this.backdrops,
    required this.trailers,
  });

  @override
  List<Object> get props {
    return [
      tmdbData,
      imdbData,
      similar,
      cast,
      backdrops,
      trailers,
    ];
  }
}

class MovieDatailError extends MovieDetailState {
  final FetchDataError error;
  final String? message;

  const MovieDatailError({
    this.message,
    required this.error,
  });

  @override
  List<Object> get props => [message ?? '', error];
}
