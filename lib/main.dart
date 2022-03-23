import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:movie_db/helpers/bloc_observer.dart';
import 'package:movie_db/screens/bottom_nav_bar.dart';
import 'package:path_provider/path_provider.dart';

/// Hive
Future<Box> openHiveBox(String boxName) async {
  if (!kIsWeb && !Hive.isBoxOpen(boxName)) {
    Hive.init((await getApplicationDocumentsDirectory()).path);
  }

  return await Hive.openBox(boxName);
}

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  openHiveBox('Movies');
  openHiveBox('Favorites');
  openHiveBox('Tv');

  // Directory dir = await getApplicationDocumentsDirectory();
  // Hive.init(dir.path);
  // await Hive.openBox(dir.path);
  // await Hive.openBox('Movies');
  // await Hive.openBox('Favorites');
  // await Hive.openBox('Tv');

  //Enable stringify when on Debug mode
  EquatableConfig.stringify = kDebugMode;

  BlocOverrides.runZoned(
    () => runApp(const MyApp()),
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie DB',
      theme: ThemeData(
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        // scaffoldBackgroundColor: Colors.black,
        scaffoldBackgroundColor: const Color.fromARGB(123, 48, 53, 51),
        primarySwatch: Colors.blue,
        splashColor: Colors.transparent,
        primaryColor: Colors.cyanAccent,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: ScrollConfiguration(
            behavior: NoGlowBehavior(),
            child: child ?? const SizedBox(),
          ),
        );
      },
      home: const BottomNavBar(),
    );
  }
}

class NoGlowBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
