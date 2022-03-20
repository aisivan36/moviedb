part of 'movie_detail_bloc.dart';

abstract class MovieDetailEvent extends Equatable {
  const MovieDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadMoviesDetail extends MovieDetailEvent {
  final String id;

  const LoadMoviesDetail({required this.id});

  @override
  List<Object> get props => [id];
}
