import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_db/animation.dart';
import 'package:movie_db/constants/theme.dart';

import 'package:movie_db/models/movies/cast_info_model.dart';
import 'package:movie_db/models/movies/image_backdrop_model.dart';
import 'package:movie_db/models/movies/movie_info_imdb_model.dart';
import 'package:movie_db/models/movies/movie_info_model.dart';
import 'package:movie_db/models/movies/movie_model.dart';
import 'package:movie_db/models/movies/trailer_model.dart';
import 'package:movie_db/screens/movie_detail_screen/bloc/movie_detail_bloc.dart';
import 'package:movie_db/screens/movie_detail_screen/detail_widgets/create_icon.dart';
import 'package:movie_db/widgets/appbar.dart';
import 'package:movie_db/widgets/draggable_sheet.dart';
import 'package:movie_db/widgets/error_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieDetailScreen extends StatelessWidget {
  const MovieDetailScreen({Key? key, required this.backdrop, required this.id})
      : super(key: key);

  final String id;
  final String backdrop;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<MovieDetailBloc>(
      create: (context) => MovieDetailBloc()..add(LoadMoviesDetail(id: id)),
      child: BlocBuilder<MovieDetailBloc, MovieDetailState>(
        builder: (context, state) {
          if (state is MovieDetailLoaded) {
            return MovieDetailScreenWidget(
              info: state.tmdbData,
              imdbInfo: state.imdbData,
              backdropList: state.backdrops,
              trailers: state.trailers,
              castList: state.cast,
              backdrop: backdrop,
              similar: state.similar,
            );
          } else if (state is MovieDatailError) {
            return ErrorScreen(
              error: state.error,
            );
          } else if (state is MovieDetailLoading) {
            return Scaffold(
              body: Center(
                  child: CircularProgressIndicator(
                color: Colors.grey.shade700,
                strokeWidth: 2,
                backgroundColor: Colors.cyanAccent,
              )),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class MovieDetailScreenWidget extends StatelessWidget {
  const MovieDetailScreenWidget({
    Key? key,
    required this.info,
    required this.imdbInfo,
    required this.backdropList,
    required this.trailers,
    required this.castList,
    required this.backdrop,
    required this.similar,
  }) : super(key: key);
  final MovieInfoModel info;
  final MovieInfoImdb imdbInfo;
  final List<ImageBackdrop> backdropList;
  final List<TrailerModel> trailers;
  final List<CastInfo> castList;
  final String backdrop;
  final List<MovieModel> similar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(info.poster),
            fit: BoxFit.cover,
            alignment: Alignment.topLeft,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 50),
          child: Container(
            color: Colors.black.withOpacity(0.5),
            // TODO may wrap within Stack again
            child: Stack(
              children: [
                InkWell(
                  onTap: () {
                    // TODO View Photo
                  },
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * (1 - 0.63),
                    width: MediaQuery.of(context).size.width,
                    child: CachedNetworkImage(
                      imageUrl: info.backdrops,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CreateIcons(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            CupertinoIcons.back,
                            color: Colors.white,
                          ),
                        ),
                        CreateIcons(
                          onTap: () {
                            showModalBottomSheet<void>(
                              context: context,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              backgroundColor: const Color(0xFF1E222D),
                              builder: (context) {
                                return Container(
                                  color: Colors.black26,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(height: 14),
                                      Container(
                                        height: 5,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      const SizedBox(height: 20.0),
                                      CopyLink(
                                        id: info.tmdbId,
                                        title: info.title,
                                        type: 'movie',
                                      ),
                                      Divider(
                                        color: Colors.grey.shade800,
                                        height: 0.5,
                                        thickness: 0.5,
                                      ),
                                      Column(
                                        children: [
                                          ListTile(
                                            onTap: () {
                                              launch(
                                                  'https://www.themoviedb.org/movie/${info.tmdbId}');
                                            },
                                            leading: Icon(
                                              CupertinoIcons.share,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            title: Text(
                                              'Open In Browser',
                                              style: normalText.copyWith(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Divider(
                                            height: 0.5,
                                            thickness: 0.5,
                                            color: Colors.grey.shade800,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: const Icon(
                            CupertinoIcons.ellipsis,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                BottomInfoSheet(
                  backdrops: info.backdrops,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      color: Colors.white,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            flex: 1,
                            child: DelayedDisplay(
                              delay: const Duration(microseconds: 500),
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: kElevationToShadow[8],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: CachedNetworkImage(
                                    imageUrl: info.poster,
                                    width: 120,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: info.title,
                                          style: heading.copyWith(fontSize: 22),
                                        ),
                                        TextSpan(
                                          text:
                                              ' (${info.releaseDate.split('-')[0]})',
                                          style: heading.copyWith(
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}