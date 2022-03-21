import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_db/widgets/like_button/cubit/like_button_cubit.dart';

class LikeButton extends StatelessWidget {
  const LikeButton({
    Key? key,
    required this.date,
    required this.id,
    required this.poster,
    required this.rate,
    required this.title,
    required this.type,
  }) : super(key: key);

  final String id;
  final String date;
  final String title;
  final String poster;
  final String type;
  final double rate;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LikeButtonCubit>(
      create: (context) => LikeButtonCubit()..init(id),
      child: BlocBuilder<LikeButtonCubit, LikeButtonState>(
        builder: (context, state) => Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: kElevationToShadow[2],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 30, sigmaY: 50),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13),
                      color: Colors.black.withOpacity(0.3),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        context.read<LikeButtonCubit>().like(
                              id: id,
                              title: title,
                              poster: poster,
                              rating: rate,
                              type: type,
                              date: date,
                            );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            !state.isLiked
                                ? const Icon(
                                    CupertinoIcons.heart,
                                    color: Colors.white,
                                    size: 30,
                                  )
                                : const Icon(
                                    CupertinoIcons.heart_solid,
                                    color: Colors.amber,
                                    size: 30,
                                  ),
                            Text(
                              !state.isLiked
                                  ? 'Add to Favorite'
                                  : 'Your Favorite',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
