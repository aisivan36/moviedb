import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movie_db/constants/theme.dart';
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
    final heights = MediaQuery.of(context).size.height * 0.56;
    final widths = MediaQuery.of(context).size.width;
    final positionHeight = MediaQuery.of(context).size.height * 0.4;
    return SizedBox(
      height: heights,
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: widget.movies[current].backdrop,
            fit: BoxFit.cover,
            height: heights,
          ),
          Positioned(
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 50, sigmaY: 100),
                child: Container(
                  height: heights,
                  width: widths,
                  color: Colors.black.withOpacity(0.5),
                  alignment: Alignment.topLeft,
                  child: SafeArea(
                    /// MovieDB title
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 50, right: 50, top: 9, bottom: 9),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 1.0, bottom: 1.0),
                            child: Text(
                              'MovieDB',
                              style: heading.copyWith(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(13),
                              bottomRight: Radius.circular(13)),
                          color: Color.fromARGB(134, 20, 199, 44),
                          // border: Border(
                          //   bottom: BorderSide(
                          //     color: Colors.grey,
                          //     width: 0.6,
                          //   ),
                          // ),
                        ),
                      ),
                    ),
                    //
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            top: 0,
            child: Container(
              height: positionHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black38.withOpacity(1),
                    Colors.black38.withOpacity(1),
                    Colors.black38.withOpacity(.7),
                    Colors.black38.withOpacity(.6),
                    Colors.black38.withOpacity(.4),
                    Colors.black38.withOpacity(.3),
                    Colors.black38.withOpacity(0.5),
                    Colors.black38.withOpacity(0.3),
                    Colors.black38.withOpacity(0.0),
                    Colors.black38.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
              bottom: 0,
              height: positionHeight,
              width: widths,
              // TODO DelayedDisplay
              child: Text(
                'Test',
                style: TextStyle(color: Colors.white),
              )),
        ],
      ),
    );
  }
}
