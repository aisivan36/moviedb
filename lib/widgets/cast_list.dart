import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_db/models/movies/cast_info_model.dart';

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
        children: castList
            .map((data) {
              if (data.image != '') {
                return SizedBox(
                  width: 10,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        // TODO CastInfo Screen
                      },
                      child: Tooltip(
                        message: '${data.name} test',
                        child: Column(
                          children: [
                            Container(
                              height: 250,
                              width: 130,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.green[900],
                                boxShadow: kElevationToShadow[8],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl: data.image,
                                  height: 250,
                                  width: 130,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return const SizedBox(
                  child: Text('Empty'),
                );
              }
            })
            .cast<Widget>()
            .toList(),
      ),
    );
  }
}
