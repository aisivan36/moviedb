import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_db/constants/theme.dart';
import 'package:movie_db/models/tv_models/season_tvmodel.dart';
import 'package:movie_db/models/tv_models/tvinfo_model.dart';
import 'package:readmore/readmore.dart';

class SeasonsWidget extends StatelessWidget {
  const SeasonsWidget({
    Key? key,
    required this.info,
    required this.season,
    required this.textColor,
  }) : super(key: key);

  final TvInfoModel info;
  final Seasons season;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //  TODO Seasons Detail BLoc
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    boxShadow: kElevationToShadow[4],
                  ),
                  child: CachedNetworkImage(
                    imageUrl: season.image,
                    width: 180,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      season.name,
                      style:
                          heading.copyWith(color: Colors.white, fontSize: 24.0),
                    ),
                    const SizedBox(height: 5),
                    RichText(
                      text: TextSpan(
                        style: normalText.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                            text: season.date.split('-')[0] + ' | ',
                          ),
                          TextSpan(
                            text: season.episodes + ' Episodes',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    ReadMoreText(
                      season.overview == 'N/A'
                          ? '${season.name} of ${info.title} ${season.customOverView}'
                          : season.overview,
                      trimLines: 4,
                      colorClickableText: Colors.grey[300],
                      trimMode: TrimMode.Line,
                      trimCollapsedText: 'Show more',
                      trimExpandedText: 'Show less',
                      style: normalText.copyWith(
                          fontWeight: FontWeight.w500, color: Colors.white),
                      moreStyle: const TextStyle(
                          fontSize: 14.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
