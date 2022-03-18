import 'package:flutter/material.dart';
import 'package:movie_db/constants/theme.dart';

class HeaderText extends StatelessWidget {
  const HeaderText({Key? key, required this.text}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 10),
      child: Text(
        text,
        style: heading.copyWith(color: Colors.white),
      ),
    );
  }
}
