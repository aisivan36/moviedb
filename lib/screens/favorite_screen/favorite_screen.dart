import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_db/widgets/no_results_found.dart';

import '../../models/helper_model/formated_timer_generator.dart';
import '../../widgets/movie_cards.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            largeTitle: Text(
              'Favorite',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            border: Border(
              bottom: BorderSide(
                color: Colors.grey[900]!,
                width: 0.6,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: ValueListenableBuilder<Box>(
              valueListenable: Hive.box('Favorites').listenable(),
              builder: (context, box, child) {
                if (box.isEmpty) {
                  return const EmptyFavorites();
                }
                return ListView.builder(
                  itemCount: box.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final info = box.getAt(index);

                    return Dismissible(
                      key: Key(info['id'].toString()),
                      onDismissed: (direction) {
                        box.deleteAt(index);
                      },
                      direction: DismissDirection.endToStart,
                      background: const Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Icon(
                            CupertinoIcons.delete,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      child: HorizontalMovieCard(
                        poster: info['poster'],
                        name: info['title'],
                        backdrop: '',
                        date: info['date'] != ''
                            ? "${monthgenrater(info['date'].split("-")[1])} ${info['date'].split("-")[2]}, ${info['date'].split("-")[0]}"
                            : "Not Available",
                        id: info['id'],
                        color: Colors.white,
                        isMovie: info['type'] == 'MOVIE',
                        rate: info['rating'],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
