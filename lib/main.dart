import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_db/screens/bottom_nav_bar.dart';

void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO SOME EXERCISE

  runApp(const MyApp());
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
        // scaffoldBackgroundColor: Colors.black, TODO using this
        scaffoldBackgroundColor: const Color.fromARGB(123, 48, 53, 51),
        primarySwatch: Colors.blue,
        splashColor: Colors.transparent,
        primaryColor: Colors.cyanAccent,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const BottomNavBar(),
    );
  }
}
