import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_db/animation.dart';
import 'package:movie_db/constants/theme.dart';

import 'package:movie_db/models/movies/cast_info_model.dart';
import 'package:movie_db/models/movies/image_backdrop_model.dart';
import 'package:movie_db/models/movies/trailer_model.dart';
import 'package:movie_db/models/tv_models/tv_model.dart';
import 'package:movie_db/models/tv_models/tvinfo_model.dart';
import 'package:movie_db/screens/movie_detail_screen/detail_widgets/create_icon.dart';
import 'package:movie_db/screens/tvshow_detail_screen/bloc/tv_show_detail_bloc.dart';
import 'package:movie_db/screens/tvshow_detail_screen/tvshow_widgets/about_show.dart';
import 'package:movie_db/screens/tvshow_detail_screen/tvshow_widgets/overview_wdiget.dart';
import 'package:movie_db/screens/tvshow_detail_screen/tvshow_widgets/seasons_widget.dart';
import 'package:movie_db/widgets/appbar.dart';
import 'package:movie_db/widgets/cast_list.dart';
import 'package:movie_db/widgets/draggable_sheet.dart';
import 'package:movie_db/widgets/error_screen.dart';
import 'package:movie_db/widgets/horizontal_list_cards.dart';
import 'package:movie_db/widgets/star_icon_widget.dart';
import 'package:movie_db/widgets/trailer_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/like_button/like_button.dart';

class TvShowDetailScreen extends StatelessWidget {
  const TvShowDetailScreen({
    Key? key,
    required this.id,
    required this.backdrop,
  }) : super(key: key);

  final String id;
  final String backdrop;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TvShowDetailBloc>(
      create: (context) => TvShowDetailBloc()
        ..add(
          LoadTvInfo(id: id),
        ),
      child: BlocBuilder<TvShowDetailBloc, TvShowDetailState>(
        builder: (context, state) {
          if (state is TvShowDetailLoaded) {
            return TvInfoScrollableWidget(
              info: state.tmdbData,
              backdropsList: state.backdrops,
              trailers: state.trailers,
              castList: state.cast,
              backdrop: backdrop,
              similar: state.similar,
            );
          } else if (state is TvShowDetailError) {
            return ErrorScreen(
              error: state.error,
            );
          } else if (state is TvShowDetailLoading) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.cyanAccent,
                  strokeWidth: 2,
                  color: Colors.grey[700],
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class TvInfoScrollableWidget extends StatelessWidget {
  const TvInfoScrollableWidget({
    Key? key,
    required this.info,
    required this.backdropsList,
    required this.trailers,
    required this.castList,
    required this.backdrop,
    required this.similar,
  }) : super(key: key);
  final TvInfoModel info;
  final List<ImageBackdrop> backdropsList;
  final List<TrailerModel> trailers;
  final List<CastInfo> castList;
  final String backdrop;
  final List<TvModel> similar;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(info.poster),
            fit: BoxFit.cover,
            alignment: Alignment.topLeft,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 50, sigmaY: 100),
          child: ColoredBox(
            // color: Colors.black.withOpacity(0.9),
            color: Colors.black.withOpacity(0.5),
            child: Stack(
              children: [
                InkWell(
                  onTap: () {
                    // TODO ViewPhoto
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
                                                  'https://www.themoviedb.org/tv/${info.tmdbId}');
                                            },
                                            leading: Icon(
                                              CupertinoIcons.photo,
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          Flexible(
                            child: DelayedDisplay(
                              delay: const Duration(milliseconds: 500),
                              child: Container(
                                width: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey[900],
                                  boxShadow: kElevationToShadow[8],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    imageUrl: info.poster,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
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
                                            style: heading.copyWith(
                                                color: Colors.white,
                                                fontSize: 22),
                                          ),
                                          TextSpan(
                                            text:
                                                "  (${info.date.split(',').join(',')})",
                                            style: heading.copyWith(
                                                color: Colors.white
                                                    .withOpacity(0.8),
                                                fontSize: 18),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  DelayedDisplay(
                                    delay: const Duration(microseconds: 700),
                                    child: RichText(
                                      text: TextSpan(
                                        style: normalText.copyWith(
                                            color: Colors.white),
                                        children: [
                                          ...info.genres.map(
                                            (data) => TextSpan(text: '$data, '),
                                          ),
                                        ],
                                      ),
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
                                      date: info.date,
                                      id: info.tmdbId,
                                      title: info.title,
                                      rate: info.rating,
                                      poster: info.poster,
                                      type: 'TV',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// OverView Widget
                    if (info.overview != '')
                      OverviewWidget(info: info, textColor: Colors.white),
                    if (trailers.isNotEmpty)
                      TrailerWidget(
                        backdrop: info.backdrops,
                        backdropsList: backdropsList,
                        trailers: trailers,
                      ),

                    if (castList.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Text(
                              'Cast',
                              style: heading.copyWith(color: Colors.white),
                            ),
                          ),
                          CastList(castList: castList),
                        ],
                      ),

                    /// About Show Widget screen
                    AboutShowWidget(info: info, textColor: Colors.white),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Text(
                        'Seasons',
                        style: heading.copyWith(color: Colors.white),
                      ),
                    ),

                    /// Seasons Widget
                    ...info.seasons.map(
                      (data) => SeasonsWidget(
                        info: info,
                        season: data,
                        textColor: Colors.white,
                      ),
                    ),

                    if (similar.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20.0),
                          Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Text(
                              'You might also like',
                              style: heading.copyWith(color: Colors.white),
                            ),
                          ),

                          /// Horizontal List View TV
                          HorizontalListViewTv(list: similar),
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
