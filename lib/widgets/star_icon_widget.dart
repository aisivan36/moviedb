import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StarDisplay extends StatelessWidget {
  const StarDisplay({Key? key, this.value = 0}) : super(key: key);
  final int value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (index) {
          // print(value);
          return Icon(
            index < value ? CupertinoIcons.star_fill : CupertinoIcons.star,
            color: Colors.amber,
            size: 16,
          );
        },
      ),
    );
  }
}
