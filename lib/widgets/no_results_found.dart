import 'package:flutter/material.dart';
import 'package:movie_db/constants/theme.dart';

class NoResultsFound extends StatelessWidget {
  const NoResultsFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.expand(
        height: MediaQuery.of(context).size.height,
      ),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.search,
                size: 45,
                color: Colors.white.withOpacity(0.6),
              ),
              const SizedBox(height: 10),
              Text(
                '404 NOT Found',
                style: heading.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              Text(
                'We did NOT Found anything related with your query, please search with little accurate word,',
                textAlign: TextAlign.center,
                style: normalText.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmptyFavorites extends StatelessWidget {
  const EmptyFavorites({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.favorite,
              size: 45,
              color: Colors.white,
            ),
            const SizedBox(height: 10),
            Text(
              'Your Favorites is Empty',
              style: heading.copyWith(
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Add Your Favorites movies and tv shows to track your favorites list.',
              textAlign: TextAlign.center,
              style: normalText.copyWith(
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
