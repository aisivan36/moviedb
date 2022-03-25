import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_db/animation.dart';
import 'package:movie_db/constants/theme.dart';
import 'package:movie_db/models/genre_model.dart';
import 'package:movie_db/screens/search_screen/search_widgets/genre_tile.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final genres = GenresList.fromJson(genreslist).list;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Search",
                style: heading.copyWith(color: Colors.cyanAccent, fontSize: 36),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                style: normalText.copyWith(color: Colors.white),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  suffixIcon: Icon(
                    Icons.search,
                    color: Theme.of(context).primaryColor,
                  ),
                  hintText: 'Search movies, tv shows or cast...',
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  hintStyle: TextStyle(
                    letterSpacing: 0.0,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  fillColor: Colors.white.withOpacity(0.1),
                  //Border
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.grey[600]!, width: 0.2),
                  ),
                  border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.grey[600]!, width: 0.2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.grey[600]!, width: 0.2),
                  ),
                ),
                onSubmitted: (String query) {
                  if (query.isNotEmpty) {
                    // pushNewScreen(context,BlocProvider(create: create))
                    // TODO SearchResultCubit and Search Results Page
                  }
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Text(
                'Popular Genres',
                style: heading.copyWith(color: Colors.white, fontSize: 16.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 28 / 16),
                children: [
                  /// Popular Genres Set it to 4 tiles
                  for (int iterable = 0; iterable < 4; iterable++)
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: GenreTile(genres: genres[iterable]),
                    ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Text(
                'Browse All',
                style: heading.copyWith(color: Colors.white, fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView(
                shrinkWrap: true,

                /// Disable Scrollable for GridView to avoid conflict of listview's parent
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 28 / 16),
                children: [
                  for (int iterable = 0; iterable < genres.length; iterable++)
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: GenreTile(genres: genres[iterable]),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
