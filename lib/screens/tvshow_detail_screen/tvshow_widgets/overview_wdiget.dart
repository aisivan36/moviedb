import 'package:flutter/material.dart';
import 'package:movie_db/animation.dart';
import 'package:movie_db/constants/theme.dart';
import 'package:movie_db/models/tv_models/tvinfo_model.dart';
import 'package:readmore/readmore.dart';

class OverviewWidget extends StatelessWidget {
  const OverviewWidget({Key? key, required this.info, required this.textColor})
      : super(key: key);

  final Color textColor;
  final TvInfoModel info;

  @override
  Widget build(BuildContext context) {
    return Padding(
      // color: Colors.white,
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
          const SizedBox(height: 10),
          DelayedDisplay(
            delay: const Duration(microseconds: 1000),
            child: ReadMoreText(
              info.overview,
              trimLines: 6,
              colorClickableText: Colors.grey[400],
              trimMode: TrimMode.Line,
              trimCollapsedText: 'More',
              trimExpandedText: 'Less',
              style: normalText.copyWith(
                  color: Colors.white, fontWeight: FontWeight.w500),
              moreStyle:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
