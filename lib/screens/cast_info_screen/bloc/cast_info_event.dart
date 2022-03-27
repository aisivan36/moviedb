part of 'cast_info_bloc.dart';

abstract class CastInfoEvent extends Equatable {
  const CastInfoEvent();

  @override
  List<Object> get props => [];
}

class LoadCastInfo extends CastInfoEvent {
  final String id;
  const LoadCastInfo({required this.id});

  @override
  List<Object> get props => [id];
}
