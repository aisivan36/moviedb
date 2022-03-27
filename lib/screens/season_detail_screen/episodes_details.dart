import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_db/constants/theme.dart';
import 'package:movie_db/models/episode_model.dart';
import 'package:movie_db/widgets/cast_list.dart';
import 'package:movie_db/widgets/star_icon_widget.dart';
import 'package:readmore/readmore.dart';

class EpisodeInfo extends StatelessWidget {
  const EpisodeInfo({
    Key? key,
    required this.color,
    required this.model,
    required this.textColor,
  }) : super(key: key);
  final EpisodeModel model;
  final String color;
  final Color textColor;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: model.castInfoList.isNotEmpty
          ? MediaQuery.of(context).size.height * .8
          : MediaQuery.of(context).size.height * .7,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          image: DecorationImage(
            image: CachedNetworkImageProvider(color),
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 50, sigmaY: 100),
          child: ColoredBox(
            color: Colors.black.withOpacity(0.6),
            child: ListView(
              shrinkWrap: true,
              children: [
                Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: model.stillPath,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          model.number,
                          style: heading.copyWith(color: textColor),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: model.name,
                              style: heading.copyWith(
                                color: textColor,
                                fontSize: 20.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        model.customDate,
                        style: heading.copyWith(
                            color: textColor.withOpacity(0.8), fontSize: 18),
                      ),
                      const SizedBox(height: 5),
                      ReadMoreText(
                        model.overview,
                        trimLines: 4,
                        colorClickableText: Colors.pink,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: 'Show more',
                        trimExpandedText: 'Show less',
                        style: normalText.copyWith(
                            fontWeight: FontWeight.w500, color: textColor),
                        moreStyle: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          IconTheme(
                            data: IconThemeData(
                              color: textColor == Colors.white
                                  ? Colors.amber
                                  : Colors.blue,
                              size: 20,
                            ),
                            child: StarDisplay(
                              value: ((model.voteAverage * 5) / 10).round(),
                            ),
                          ),
                          Text(
                            "  " + model.voteAverage.toString() + "/10",
                            style: normalText.copyWith(
                              color: textColor == Colors.white
                                  ? Colors.amber
                                  : Colors.blue,
                              letterSpacing: 1.2,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),

                /// Guest Stars Widget
                if (model.castInfoList.isNotEmpty ||
                    // ignore: unnecessary_null_comparison
                    model.castInfoList != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Text(
                          "Guest stars",
                          style: heading.copyWith(color: textColor),
                        ),
                      ),
                      CastList(
                        castList: model.castInfoList,
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
