import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:movie_db/constants/theme.dart';
import 'package:movie_db/models/tv_models/tvinfo_model.dart';
import 'package:movie_db/widgets/expandable_group.dart';

class AboutShowWidget extends StatelessWidget {
  const AboutShowWidget({Key? key, required this.info, required this.textColor})
      : super(key: key);
  final Color textColor;
  final TvInfoModel info;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.white,
      padding: const EdgeInsets.only(top: 12.0),
      child: ExpandableGroup(
        isExpanded: true,
        expandedIcon: Icon(
          Icons.arrow_drop_up,
          color: Colors.white != Colors.white ? Colors.black : Colors.white,
        ),
        collapsedIcon: Icon(
          Icons.arrow_drop_down,
          color: Colors.white != Colors.white ? Colors.black : Colors.white,
        ),
        header: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Text(
            'About Show',
            style: heading.copyWith(color: Colors.white),
          ),
        ),
        items: [
          if (info.created.isNotEmpty)
            ListTile(
              title: Text(
                'Created By',
                style: heading.copyWith(color: Colors.white, fontSize: 16),
              ),
              subtitle: RichText(
                text: TextSpan(
                  style: normalText.copyWith(color: Colors.white),
                  children: info.created
                      .map((data) => TextSpan(text: '$data, '))
                      .toList(),
                ),
              ),
            ),
          if (info.networks.isNotEmpty)
            ListTile(
              title: Text(
                'Available on',
                style: heading.copyWith(color: Colors.white, fontSize: 16.0),
              ),
              subtitle: RichText(
                text: TextSpan(
                  style: normalText.copyWith(color: Colors.white),
                  children: info.networks
                      .map((data) => TextSpan(text: '$data, '))
                      .toList(),
                ),
              ),
            ),
          ListTile(
            title: Text(
              'Number Of Seasons',
              style: heading.copyWith(color: Colors.white, fontSize: 16.0),
            ),
            subtitle: Text(
              info.numberOfSeasons,
              style: normalText.copyWith(color: Colors.white),
            ),
          ),
          ListTile(
              title: Text(
                "Episode Run Time",
                style: heading.copyWith(color: Colors.white, fontSize: 16),
              ),
              subtitle: Text(
                info.episoderuntime,
                style: normalText.copyWith(color: Colors.white),
              )),
          if (info.formatedDate != "")
            ListTile(
              title: Text(
                "First Episode Released on",
                style: heading.copyWith(color: Colors.white, fontSize: 16),
              ),
              subtitle: RichText(
                text: TextSpan(
                  style: normalText.copyWith(color: Colors.white),
                  children: [
                    TextSpan(text: info.formatedDate),
                  ],
                ),
              ),
            ),
          if (info.tagline != '')
            ListTile(
              title: Text(
                'Show Tagline',
                style: heading.copyWith(color: Colors.white, fontSize: 16.0),
              ),
              subtitle: Text(
                info.tagline,
                style: normalText.copyWith(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
