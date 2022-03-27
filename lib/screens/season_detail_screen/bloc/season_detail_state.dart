part of 'season_detail_bloc.dart';

abstract class SeasonDetailState extends Equatable {
  const SeasonDetailState();

  @override
  List<Object> get props => [];
}

class SeasonDetailInitial extends SeasonDetailState {}

class SeasonDetailLoaded extends SeasonDetailState {
  final SeasonModel seasonModel;
  final List<ImageBackdrop> backdropList;
  final List<TrailerModel> trailers;
  final List<CastInfo> cast;

  const SeasonDetailLoaded({
    required this.backdropList,
    required this.cast,
    required this.seasonModel,
    required this.trailers,
  });

  @override
  List<Object> get props => [
        seasonModel,
        backdropList,
        trailers,
        cast,
      ];
}

class SeasonDetailLoading extends SeasonDetailState {}

class SeasonDetailError extends SeasonDetailState {
  final FetchDataError error;
  const SeasonDetailError({required this.error});
  @override
  List<Object> get props => [error];
}
