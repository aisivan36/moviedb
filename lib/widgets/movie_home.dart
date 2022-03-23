import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movie_db/animation.dart';
import 'package:movie_db/constants/theme.dart';
import 'package:movie_db/models/movies/movie_model.dart';
import 'package:movie_db/screens/movie_detail_screen/movie_detail_screen.dart';

class MoviePage extends StatefulWidget {
  const MoviePage({Key? key, required this.movies}) : super(key: key);

  final List<MovieModel> movies;

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  final CarouselController carouselController = CarouselController();

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
          /// Background blur image on every each
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
                  color: const Color.fromARGB(61, 0, 0, 0),
                  // color: Colors.black.withOpacity(0.5),
                  alignment: Alignment.topCenter,
                  child: SafeArea(
                    /// MovieDB title
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 50, right: 50, top: 9, bottom: 9),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 1.0, bottom: 1.0),
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
            child: DelayedDisplay(
              delay: const Duration(microseconds: 800),
              child: SizedBox(
                height: 350,
                width: 460,
                child: CarouselSlider(
                  options: CarouselOptions(
                    // pageSnapping: true,
                    // disableCenter: true,
                    height: positionHeight,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.85,
                    // enlargeCenterPage: true,
                    // enlargeStrategy: CenterPageEnlargeStrategy.height,
                    onPageChanged: (index, reason) {
                      setState(() {
                        current = index;
                      });
                    },
                  ),
                  carouselController: carouselController,
                  items: widget.movies.map((movie) {
                    return Builder(
                      builder: (BuildContext context) {
                        return InkWell(
                          onTap: () {
                            pushNewScreen(
                                context,
                                MovieDetailScreen(
                                  backdrop: movie.backdrop,
                                  id: movie.id,
                                ));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    boxShadow: kElevationToShadow[8],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: DelayedDisplay(
                                    delay: const Duration(microseconds: 800),
                                    slidingBeginOffset:
                                        const Offset(0.0, -0.01),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                          imageUrl: movie.backdrop,
                                          width: double.infinity,
                                          height: (MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .38) *
                                              .6,
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              Container(
                                                color: Colors.grey.shade900,
                                              ),
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                if (current == widget.movies.indexOf(movie))
                                  DelayedDisplay(
                                    delay: const Duration(microseconds: 800),
                                    slidingBeginOffset:
                                        const Offset(0.0, -0.10),
                                    child: Text(
                                      movie.title,
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 18.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                const SizedBox(height: 6),
                                if (current == widget.movies.indexOf(movie))
                                  Expanded(
                                    flex: 1,
                                    child: DelayedDisplay(
                                      delay: const Duration(microseconds: 900),
                                      slidingBeginOffset:
                                          const Offset(0.0, -0.10),
                                      child: Text(
                                        movie.releaseDate,
                                        style: normalText.copyWith(
                                            color: Colors.white60,
                                            fontSize: 16),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
