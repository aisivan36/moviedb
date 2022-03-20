import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_db/helpers/debug_mode.dart';

class MyBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    printLog(
      level: LogLevel.warning,
      message: 'Bloc OnChange',
      error: change,
    );
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    printLog(
      level: LogLevel.error,
      message: 'Bloc OnError',
      error: error,
      stackTrace: stackTrace,
    );
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    printLog(
        level: LogLevel.warning, error: transition, message: 'Bloc Transition');
  }

  // @override
  // void onEvent(Bloc bloc, Object? event) {
  //   super.onEvent(bloc, event);
  //   printLog(level: LogLevel.warning, error: event, message: 'Bloc onEvents');
  // }
}
