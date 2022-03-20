import 'package:equatable/equatable.dart';

class FetchDataError extends Equatable {
  final String message;

  const FetchDataError({required this.message});

  factory FetchDataError.set(String err) {
    return FetchDataError(message: err);
  }

  String get getError => message;

  // void setErr(String err) {
  //   message = err;
  // }

  @override
  List<Object> get props => [message];
}
