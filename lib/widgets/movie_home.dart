import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movie_db/models/movies/movie_model.dart';

class MoviePage extends StatefulWidget {
  const MoviePage({Key? key, required this.movies}) : super(key: key);

  final List<MovieModel> movies;

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  final CarouselController _carouselController = CarouselController();

  int current = 0;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
