import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movie_db/animation.dart';
import 'package:movie_db/constants/theme.dart';
import 'package:movie_db/models/cast_info_personal_model.dart';
import 'package:movie_db/models/movies/image_backdrop_model.dart';
import 'package:movie_db/models/movies/movie_model.dart';
import 'package:movie_db/models/tv_models/tv_model.dart';
import 'package:movie_db/screens/cast_info_screen/bloc/cast_info_bloc.dart';
import 'package:movie_db/screens/movie_detail_screen/detail_widgets/create_icon.dart';
import 'package:movie_db/widgets/appbar.dart';
import 'package:movie_db/widgets/draggable_sheet.dart';
import 'package:movie_db/widgets/error_screen.dart';
import 'package:movie_db/widgets/horizontal_list_cards.dart';
import 'package:movie_db/widgets/image_view.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';

class CastInfoScreen extends StatelessWidget {
  const CastInfoScreen({Key? key, required this.backdrop, required this.id})
      : super(key: key);
  final String id;
  final String backdrop;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CastInfoBloc>(
      create: (context) => CastInfoBloc()..add(LoadCastInfo(id: id)),
      child: BlocBuilder<CastInfoBloc, CastInfoState>(
        builder: (context, state) {
          if (state is CastInfoLoaded) {
            return CastScreenWidget(
              backgroundImage: backdrop,
              images: state.images,
              info: state.info,
              movies: state.movies,
              socialMediaInfo: state.socialMediaInfo,
              tv: state.tvShows,
            );
          } else if (state is CastInfoError) {
            return ErrorScreen(
              error: state.error,
            );
          } else if (state is CastInfoLoading) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: Colors.grey[700],
                  strokeWidth: 2,
                  backgroundColor: Colors.cyanAccent,
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

class CastScreenWidget extends StatelessWidget {
  const CastScreenWidget({
    Key? key,
    required this.backgroundImage,
    required this.images,
    required this.info,
    required this.movies,
    required this.socialMediaInfo,
    required this.tv,
  }) : super(key: key);

  final CastPersonalInfo info;
  final String backgroundImage;
  final List<TvModel> tv;
  final SocialMediaInfo socialMediaInfo;
  final List<MovieModel> movies;
  final List<ImageBackdrop> images;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(backgroundImage),
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
                // Stack(
                //   children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * (1 - 0.48),
                  width: MediaQuery.of(context).size.width,
                  child: CachedNetworkImage(
                    imageUrl: info.image,
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
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            CupertinoIcons.back,
                            color: Colors.white,
                          ),
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
                                            id: info.id,
                                            type: 'cast',
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
                                                  "https://www.themoviedb.org/person/" +
                                                      info.id);
                                            },
                                            leading: Icon(
                                              CupertinoIcons.share,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            title: Text(
                                              "Open in Brower",
                                              style: normalText.copyWith(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Divider(
                                            height: .5,
                                            thickness: .5,
                                            color: Colors.grey.shade800,
                                          )
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
                Padding(
                  padding: const EdgeInsets.only(top: 258.0),
                  child: DelayedDisplay(
                    delay: const Duration(microseconds: 800),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        info.name,
                        textAlign: TextAlign.center,
                        style: heading.copyWith(
                          color: Colors.white,
                          fontSize: 34,
                          shadows: kElevationToShadow[8],
                        ),
                      ),
                    ),
                  ),
                ),
                //   ],

                // ),
                BottomInfoSheet(
                  minSize: 0.50,
                  children: [
                    IconTheme(
                      data: const IconThemeData(color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 12.0),
                        child: DelayedDisplay(
                          slidingBeginOffset: const Offset(0, 0.2),
                          delay: const Duration(microseconds: 700),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (socialMediaInfo.facebook != '')
                                IconButton(
                                  onPressed: () {
                                    launch(socialMediaInfo.facebook);
                                  },
                                  icon: const FaIcon(
                                    FontAwesomeIcons.facebookSquare,
                                    size: 40,
                                  ),
                                ),
                              if (socialMediaInfo.twitter != "")
                                IconButton(
                                  icon: const FaIcon(
                                      FontAwesomeIcons.twitterSquare,
                                      size: 40),
                                  onPressed: () {
                                    launch(socialMediaInfo.twitter);
                                  },
                                ),
                              if (socialMediaInfo.instagram != "")
                                IconButton(
                                  icon: const FaIcon(
                                      FontAwesomeIcons.instagramSquare,
                                      size: 40),
                                  onPressed: () {
                                    launch(socialMediaInfo.instagram);
                                  },
                                ),
                              if (socialMediaInfo.imdbId != "")
                                IconButton(
                                  icon: const FaIcon(FontAwesomeIcons.imdb,
                                      size: 40),
                                  onPressed: () {
                                    launch(socialMediaInfo.imdbId);
                                  },
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 12.0),
                      child: DelayedDisplay(
                        delay: const Duration(microseconds: 800),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Personal Info',
                              style: heading.copyWith(
                                color: Colors.white,
                                fontSize: 22.0,
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Row(
                              children: [
                                Flexible(
                                  flex: 2,
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.5,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Known For',
                                          style: heading.copyWith(
                                            color: Colors.white,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        Text(
                                          info.knownfor,
                                          style: normalText.copyWith(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Gender',
                                        style: heading.copyWith(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      Text(
                                        info.gender,
                                        style: normalText.copyWith(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Birthday',
                                  style: heading.copyWith(
                                      color: Colors.white, fontSize: 16.0),
                                ),
                                Text(
                                  info.birthday + ' (${info.old})',
                                  style: normalText.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Place of Birth',
                                  style: heading.copyWith(
                                      color: Colors.white, fontSize: 16.0),
                                ),
                                Text(
                                  info.placeOfBirth,
                                  style: normalText.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    /// Images of person
                    if (images.isNotEmpty)
                      Column(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20.0),
                          DelayedDisplay(
                            delay: const Duration(microseconds: 900),
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Text(
                                'Images of ' + info.name,
                                style: heading.copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                          DelayedDisplay(
                            delay: const Duration(microseconds: 1100),
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  for (int i = 0; i < images.length; i++)
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: () {
                                          pushNewScreen(
                                            context,
                                            ViewPhotos(
                                              color: Colors.white,
                                              imageIndex: i,
                                              imageList: images,
                                            ),
                                          );
                                        },
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          child: Container(
                                            height: 200,
                                            color: Colors.black,
                                            width: 130,
                                            child: CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              imageUrl: images[i].image,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                    /// Biography
                    if (info.bio != '')
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Biography',
                              style: heading.copyWith(color: Colors.white),
                            ),
                            const SizedBox(height: 10.0),
                            ReadMoreText(
                              info.bio,
                              trimLines: 10,
                              colorClickableText: Colors.grey[700],
                              trimMode: TrimMode.Line,
                              trimCollapsedText: 'Show more',
                              trimExpandedText: 'Show less',
                              style: normalText.copyWith(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                              moreStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                      ),

                    if (movies.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20.0),
                          Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Text(
                              'Movies',
                              style: heading.copyWith(color: Colors.white),
                            ),
                          ),
                          HorizontalListViewMovies(
                            list: movies,
                            color: Colors.white,
                          ),
                        ],
                      ),

                    if (tv.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20.0),
                            Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Text(
                                'Tv Shows',
                                style: heading.copyWith(color: Colors.white),
                              ),
                            ),
                            HorizontalListViewTv(
                              list: tv,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                  ],
                  backdrops: info.image,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
