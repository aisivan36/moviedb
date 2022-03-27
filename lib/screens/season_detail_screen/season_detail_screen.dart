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
import 'package:movie_db/models/season_model.dart';
import 'package:movie_db/screens/movie_detail_screen/detail_widgets/create_icon.dart';
import 'package:movie_db/screens/season_detail_screen/bloc/season_detail_bloc.dart';
import 'package:movie_db/screens/season_detail_screen/episodes_details.dart';
import 'package:movie_db/widgets/appbar.dart';
import 'package:movie_db/widgets/cast_list.dart';
import 'package:movie_db/widgets/draggable_sheet.dart';
import 'package:movie_db/widgets/error_screen.dart';
import 'package:movie_db/widgets/star_icon_widget.dart';
import 'package:movie_db/widgets/trailer_widget.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';

class SeasonDetailScreen extends StatelessWidget {
  const SeasonDetailScreen({
    Key? key,
    required this.backdrop,
    required this.id,
    required this.snum,
  }) : super(key: key);
  final String id;
  final String backdrop;
  final String snum;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SeasonDetailBloc>(
      create: (context) => SeasonDetailBloc()
        ..add(
          LoadSeasonInfo(id: id, snum: snum),
        ),
      child: BlocBuilder<SeasonDetailBloc, SeasonDetailState>(
        builder: (context, state) {
          if (state is SeasonDetailLoaded) {
            return SeasonDetailWidget(
              info: state.seasonModel,
              tvId: id,
              castList: state.cast,
              textColor: Colors.white,
              color: Colors.black,
              backdrop: backdrop,
              trailers: state.trailers,
              backdropList: state.backdropList,
            );
          } else if (state is SeasonDetailError) {
            return ErrorScreen(error: state.error);
          } else if (state is SeasonDetailLoading) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: Colors.grey[300],
                  strokeWidth: 2,
                  backgroundColor: Colors.cyanAccent,
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class SeasonDetailWidget extends StatelessWidget {
  const SeasonDetailWidget({
    Key? key,
    required this.backdrop,
    required this.castList,
    required this.color,
    required this.info,
    required this.tvId,
    required this.backdropList,
    required this.textColor,
    required this.trailers,
  }) : super(key: key);

  final SeasonModel info;
  final List<CastInfo> castList;
  final Color color;
  final String backdrop;
  final String tvId;

  final List<ImageBackdrop> backdropList;
  final List<TrailerModel> trailers;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(info.posterPath),
            fit: BoxFit.cover,
            alignment: Alignment.topLeft,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 50, sigmaY: 100),
          child: ColoredBox(
            color: Colors.black.withOpacity(0.5),
            child: Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * (1 - 0.49),
                  width: MediaQuery.of(context).size.width,
                  child: CachedNetworkImage(
                    imageUrl: info.posterPath,
                    fit: BoxFit.cover,
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CreateIcons(
                          child: const Icon(
                            CupertinoIcons.back,
                            color: Colors.white,
                          ),
                          onTap: () => Navigator.of(context).pop(),
                        ),
                        CreateIcons(
                          onTap: () {
                            showModalBottomSheet<void>(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              backgroundColor:
                                  const Color.fromARGB(255, 30, 34, 45),
                              context: context,
                              builder: (BuildContext ctx) {
                                return Container(
                                  color: Colors.black26,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(
                                        height: 14,
                                      ),
                                      Container(
                                        height: 5,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Column(
                                        children: [
                                          CopyLink(
                                            title: info.name,
                                            id: tvId,
                                            type: 'season-${info.seasonNumber}',
                                          ),
                                          Divider(
                                            height: .5,
                                            thickness: .5,
                                            color: Colors.grey.shade800,
                                          )
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          ListTile(
                                            onTap: () {
                                              launch(
                                                  "https://www.themoviedb.org/tv/$tvId/season/" +
                                                      info.seasonNumber
                                                          .toString());
                                            },
                                            leading: Icon(
                                              CupertinoIcons.share,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            title: Text(
                                              "Open in Brower ",
                                              style: normalText.copyWith(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Divider(
                                            height: .5,
                                            thickness: .5,
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
                  backdrops: info.posterPath,
                  minSize: 0.5,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: DelayedDisplay(
                              delay: const Duration(milliseconds: 500),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  boxShadow: kElevationToShadow[8],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: CachedNetworkImage(
                                    imageUrl: info.posterPath,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DelayedDisplay(
                                    delay: const Duration(microseconds: 700),
                                    child: Text(
                                      info.name,
                                      style: heading.copyWith(
                                        color: textColor,
                                        fontSize: 24,
                                      ),
                                    ),
                                  ),
                                  DelayedDisplay(
                                    delay: const Duration(microseconds: 700),
                                    child: RichText(
                                      text: TextSpan(
                                        style: normalText.copyWith(
                                          color: textColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        children: [
                                          TextSpan(
                                              text: info.customDate + ' | '),
                                          TextSpan(
                                              text: info.episodes.length
                                                      .toString() +
                                                  ' Episodes'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DelayedDisplay(
                            delay: const Duration(microseconds: 800),
                            child: Text(
                              "Overview",
                              style: heading.copyWith(color: textColor),
                            ),
                          ),
                          const SizedBox(height: 10),
                          DelayedDisplay(
                            delay: const Duration(microseconds: 1000),
                            child: ReadMoreText(
                              info.overview == "N/A"
                                  ? "${info.name} premiered on " +
                                      info.customDate
                                  : info.overview,
                              trimLines: 8,
                              colorClickableText: Colors.pink,
                              trimMode: TrimMode.Line,
                              trimCollapsedText: 'Show more',
                              trimExpandedText: 'Show less',
                              style: normalText.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: textColor),
                              moreStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          /// Trailer Widget
                          if (trailers.isNotEmpty)
                            TrailerWidget(
                              trailers: trailers,
                              backdropsList: backdropList,
                              backdrop: backdrop,
                            ),

                          /// Cast Lists
                          if (castList.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: Text(
                                    "Cast",
                                    style: heading.copyWith(color: textColor),
                                  ),
                                ),
                                CastList(castList: castList),
                              ],
                            ),

                          /// Episodes
                          if (info.episodes.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: Text(
                                    "Episodes",
                                    style: heading.copyWith(color: textColor),
                                  ),
                                ),
                              ],
                            ),
                          for (var i = 0; i < info.episodes.length; i++)
                            InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                  ),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  context: context,
                                  builder: (context) {
                                    return BottomSheet(
                                      builder: (context) => EpisodeInfo(
                                        color: info.posterPath,
                                        model: info.episodes[i],
                                        textColor: textColor,
                                      ),
                                      onClosing: () {},
                                    );
                                  },
                                );
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * .8,
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        DecoratedBox(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.grey.shade800,
                                            boxShadow: kElevationToShadow[8],
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 250,
                                              imageUrl:
                                                  info.episodes[i].stillPath,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          child: Container(
                                            color: color,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                info.episodes[i].number,
                                                style: heading.copyWith(
                                                  color: textColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: info.episodes[i].name,
                                                  style: heading.copyWith(
                                                    color: textColor,
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            info.episodes[i].customDate,
                                            style: heading.copyWith(
                                              color: textColor.withOpacity(.8),
                                              fontSize: 18,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            children: [
                                              IconTheme(
                                                data: IconThemeData(
                                                  color:
                                                      textColor == Colors.white
                                                          ? Colors.amber
                                                          : Colors.cyanAccent,
                                                  size: 20,
                                                ),
                                                child: StarDisplay(
                                                  value: ((info.episodes[i]
                                                                  .voteAverage *
                                                              5) /
                                                          10)
                                                      .round(),
                                                ),
                                              ),
                                              Text(
                                                "  " +
                                                    info.episodes[i].voteAverage
                                                        .toString() +
                                                    "/10",
                                                style: normalText.copyWith(
                                                  color:
                                                      textColor == Colors.white
                                                          ? Colors.amber
                                                          : Colors.blue,
                                                  letterSpacing: 1.2,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
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
