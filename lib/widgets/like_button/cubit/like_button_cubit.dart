import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/adapters.dart';

part 'like_button_state.dart';

class LikeButtonCubit extends Cubit<LikeButtonState> {
  LikeButtonCubit() : super(const LikeButtonInitial(isLike: false));

  /// Set an id
  void init(String id) {
    Box box = Hive.box('Favorites');
    bool value = box.containsKey(id);

    if (value) {
      emit(state.copyWith(isLiked: true));
    } else {
      emit(state.copyWith(isLiked: false));
    }
  }

  void like({
    required String id,
    required String title,
    required String poster,
    required double rating,
    required String type,
    required String date,
  }) {
    Box box = Hive.box('Favorites');

    if (state.isLiked) {
      box.delete(id);
      emit(state.copyWith(isLiked: false));
    } else {
      emit(state.copyWith(isLiked: true));

      box.put(id, {
        'id': id,
        'title': title,
        'poster': poster,
        'rating': rating,
        'type': type,
        'date': date,
      });
    }
  }
}
