part of 'home_screen_bloc.dart';

abstract class HomeScreenState extends Equatable {
  const HomeScreenState();

  @override
  List<Object> get props => [];
}

class HomeScreenInitial extends HomeScreenState {}

class HomeScreenLoading extends HomeScreenState {}

class HomeScreenLoaded extends HomeScreenState {
  final List<MovieModel> tranding;
  final List<MovieModel> topRated;
  final List<TvModel> tvShows;
  final List<TvModel> topShows;
  final List<MovieModel> upcoming;
  final List<MovieModel> nowPlaying;

  const HomeScreenLoaded({
    required this.tranding,
    required this.topRated,
    required this.tvShows,
    required this.topShows,
    required this.upcoming,
    required this.nowPlaying,
  });

  @override
  List<Object> get props {
    return [
      tranding,
      topRated,
      tvShows,
      topShows,
      upcoming,
      nowPlaying,
    ];
  }
}

class HomeScreenError extends HomeScreenState {
  final FetchDataError error;

  const HomeScreenError({required this.error});

  @override
  List<Object> get props => [error];
}
