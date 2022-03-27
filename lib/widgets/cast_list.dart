import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_db/animation.dart';
import 'package:movie_db/constants/theme.dart';
import 'package:movie_db/models/movies/cast_info_model.dart';
import 'package:movie_db/screens/cast_info_screen/bloc/cast_info_bloc.dart';
import 'package:movie_db/screens/cast_info_screen/cast_info_screen.dart';

class CastList extends StatelessWidget {
  const CastList({Key? key, required this.castList}) : super(key: key);
  final List<CastInfo> castList;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      // color: Colors.white,
      constraints: const BoxConstraints(minHeight: 300, maxHeight: 320),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: [
          const SizedBox(height: 10),
          for (var i = 0; i < castList.length; i++)
            if (castList[i].image != '')
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: GestureDetector(
                  onTap: () {
                    pushNewScreen(
                      context,
                      BlocProvider<CastInfoBloc>(
                        create: (context) => CastInfoBloc(),
                        child: CastInfoScreen(
                          backdrop: castList[i].image,
                          id: castList[i].id,
                        ),
                      ),
                    );
                  },
                  child: Tooltip(
                    message: '${castList[i].name} as ${castList[i].character}',
                    child: Container(
                      width: 130,
                      constraints: const BoxConstraints(minHeight: 290),
                      child: Column(
                        children: [
                          Container(
                            // constraints: BoxConstraints.expand(height: 200),
                            height: 200,
                            width: 130,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.transparent,
                              boxShadow: kElevationToShadow[8],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: castList[i].image,
                                height: 250,
                                width: 130,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: SizedBox(
                              width: 130,
                              child: Text(
                                castList[i].name,
                                maxLines: 2,
                                style: normalText.copyWith(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Expanded(
                            child: SizedBox(
                              width: 130,
                              child: Text(
                                castList[i].character,
                                maxLines: 2,
                                style: normalText.copyWith(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
