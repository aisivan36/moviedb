part of 'like_button_cubit.dart';

class LikeButtonState extends Equatable {
  final bool isLiked;
  const LikeButtonState({required this.isLiked});

  LikeButtonState copyWith({bool? isLiked}) {
    return LikeButtonState(isLiked: isLiked ?? this.isLiked);
  }

  @override
  List<Object> get props => [isLiked];
}

class LikeButtonInitial extends LikeButtonState {
  ///
  final bool isLike;
  const LikeButtonInitial({required this.isLike}) : super(isLiked: isLike);
}
