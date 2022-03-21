import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_db/constants/theme.dart';

class CopyLink extends StatelessWidget {
  const CopyLink({
    Key? key,
    required this.id,
    required this.title,
    required this.type,
  }) : super(key: key);
  final String title;
  final String id;
  final String type;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        CupertinoIcons.link,
        color: Theme.of(context).primaryColor,
      ),
      title: Text(
        'Copy URL',
        style: normalText.copyWith(color: Colors.white),
      ),
      onTap: () {
        Clipboard.setData(ClipboardData(
            text: "https://anshrathod.vercel.app/moviedb?id=$id-$type"));
      },
    );
  }
}
