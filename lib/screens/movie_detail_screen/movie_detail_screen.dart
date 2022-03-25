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
import 'package:movie_db/widgets/cast_list.dart';
import 'package:movie_db/widgets/draggable_sheet.dart';
import 'package:movie_db/widgets/error_screen.dart';
import 'package:movie_db/widgets/expandable_group.dart';
import 'package:movie_db/widgets/horizontal_list_cards.dart';
import 'package:movie_db/widgets/like_button/like_button.dart';
import 'package:movie_db/widgets/star_icon_widget.dart';
import 'package:movie_db/widgets/trailer_widget.dart';
import 'package:readmore/readmore.dart';
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

                /// Bottom Image Draggable sheet widget
                BottomInfoSheet(
                  backdrops: info.backdrops,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
                              padding: const EdgeInsets.only(left: 13.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DelayedDisplay(
                                    delay: const Duration(microseconds: 700),
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: info.title,
                                            style:
                                                heading.copyWith(fontSize: 22),
                                          ),
                                          TextSpan(
                                            text:
                                                ' (${info.releaseDate.split(',').join(',')})',
                                            style: heading.copyWith(
                                              color:
                                                  Colors.white.withOpacity(0.8),
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  DelayedDisplay(
                                    padding: const EdgeInsets.only(top: 5),
                                    delay: const Duration(microseconds: 700),
                                    child: Text(
                                      imdbInfo.genre,
                                      style: normalText.copyWith(
                                          color: Colors.white),
                                    ),
                                  ),
                                  DelayedDisplay(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Row(
                                      children: [
                                        IconTheme(
                                          data: const IconThemeData(
                                              color: Colors.amber, size: 20),
                                          child: StarDisplay(
                                            value:
                                                (info.rating * 5 / 10).round(),
                                          ),
                                        ),
                                        Text(
                                          '  ${info.rating}/10',
                                          style: normalText.copyWith(
                                            color: Colors.amber,
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  DelayedDisplay(
                                    padding: const EdgeInsets.only(top: 5),
                                    delay: const Duration(microseconds: 800),
                                    child: LikeButton(
                                      date: info.releaseDate,
                                      id: info.tmdbId,
                                      title: info.title,
                                      rate: info.rating,
                                      poster: info.poster,
                                      type: 'MOVIE',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (info.overview != '')
                      Container(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DelayedDisplay(
                              delay: const Duration(microseconds: 800),
                              child: Text(
                                'OverView',
                                style: heading.copyWith(color: Colors.white),
                              ),
                            ),
                            DelayedDisplay(
                              padding: const EdgeInsets.only(top: 10),
                              child: ReadMoreText(
                                info.overview,
                                trimLines: 6,
                                colorClickableText: CupertinoColors.systemGrey,
                                trimMode: TrimMode.Line,
                                trimCollapsedText: 'More',
                                trimExpandedText: 'Less',
                                style: normalText.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                                moreStyle: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                lessStyle: const TextStyle(
                                  fontSize: 13,
                                  color: Color.fromARGB(255, 92, 184, 17),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (trailers.isNotEmpty)
                      TrailerWidget(
                        backdrop: info.backdrops,
                        backdropsList: backdropList,
                        trailers: trailers,
                      ),
                    // if (castList.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Text(
                            'Cast',
                            style: heading.copyWith(color: Colors.white),
                          ),
                        ),
                        CastList(castList: castList),
                      ],
                    ),
                    ExpandableGroup(
                      isExpanded: true,
                      expandedIcon: Icon(
                        Icons.arrow_drop_up,
                        color: Colors.white != Colors.white
                            ? Colors.black
                            : Colors.white,
                      ),
                      header: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14.0),
                        child: Text(
                          'About Movie',
                          style: heading.copyWith(color: Colors.white),
                        ),
                      ),
                      collapsedIcon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white != Colors.white
                            ? Colors.black
                            : Colors.white,
                      ),
                      items: [
                        ListTile(
                          title: Text(
                            'Runtime',
                            style: heading.copyWith(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                          subtitle: Text(
                            imdbInfo.runtime,
                            style: normalText.copyWith(color: Colors.white),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'Writers',
                            style: heading.copyWith(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                          subtitle: Text(
                            imdbInfo.writer,
                            style: normalText.copyWith(color: Colors.white),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'Director',
                            style: heading.copyWith(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                          subtitle: Text(
                            imdbInfo.director,
                            style: normalText.copyWith(color: Colors.white),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'Released on/Releasing on',
                            style: heading.copyWith(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                          subtitle: Text(
                            imdbInfo.released,
                            style: normalText.copyWith(color: Colors.white),
                          ),
                        ),
                      ],
                    ),

                    /// Second Widget
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: ExpandableGroup(
                        isExpanded: false,
                        expandedIcon: Icon(
                          Icons.arrow_drop_up,
                          color: Colors.white != Colors.white
                              ? Colors.black
                              : Colors.black,
                        ),
                        collapsedIcon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white != Colors.white
                              ? Colors.black
                              : Colors.white,
                        ),
                        header: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14.0),
                          child: Text(
                            'Movie on BoxOffice',
                            style: heading.copyWith(color: Colors.white),
                          ),
                        ),
                        items: [
                          ListTile(
                            title: Text(
                              'Rated',
                              style: heading.copyWith(
                                  color: Colors.white, fontSize: 16),
                            ),
                            subtitle: Text(
                              imdbInfo.rated,
                              style: normalText.copyWith(color: Colors.white),
                            ),
                          ),
                          ListTile(
                            title: Text(
                              'Budget',
                              style: heading.copyWith(
                                  color: Colors.white, fontSize: 16),
                            ),
                            subtitle: Text(
                              kmbGenerator(info.budget) == '0'
                                  ? 'N/A'
                                  : kmbGenerator(info.budget),
                              style: normalText.copyWith(color: Colors.white),
                            ),
                          ),
                          ListTile(
                            title: Text(
                              'BoxOffice',
                              style: heading.copyWith(
                                  color: Colors.white, fontSize: 16),
                            ),
                            subtitle: Text(
                              imdbInfo.boxOffice,
                              style: normalText.copyWith(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// Similar Widget screen
                    if (similar.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.all(14),
                            child: Text(
                              'You might also like',
                              style: heading.copyWith(color: Colors.white),
                            ),
                          ),

                          /// Horizontal List Movie screen widget
                          HorizontalListViewMovies(
                              list: similar, color: Colors.white)
                        ],
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

String kmbGenerator(num num) {
  if (num > 999 && num < 99999) {
    return "${(num / 1000).toStringAsFixed(1)} K";
  } else if (num > 99999 && num < 999999) {
    return "${(num / 1000).toStringAsFixed(0)} K";
  } else if (num > 999999 && num < 999999999) {
    return "${(num / 1000000).toStringAsFixed(1)} M";
  } else if (num > 999999999) {
    return "${(num / 1000000000).toStringAsFixed(1)} B";
  } else {
    return num.toString();
  }
}
