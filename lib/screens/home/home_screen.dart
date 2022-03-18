import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:movie_db/models/movies/movie_model.dart';
import 'package:movie_db/models/tv_models/tv_model.dart';
import 'package:movie_db/screens/home/bloc/home_screen_bloc.dart';
import 'package:movie_db/widgets/error_screen.dart';
import 'package:movie_db/widgets/header_text.dart';
import 'package:movie_db/widgets/movie_home.dart';

class HomeSreen extends StatelessWidget {
  const HomeSreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeScreenBloc>(
      create: (context) => HomeScreenBloc()..add(HomeScreenData()),
      child: BlocBuilder<HomeScreenBloc, HomeScreenState>(
        builder: (context, state) {
          if (state is HomeScreenLoaded) {
            return HomeScreenWidget(
              topRated: state.topRated,
              topShows: state.topShows,
              nowPlaying: state.nowPlaying,
              tvShows: state.tvShows,
              tranding: state.tranding,
              upcoming: state.upcoming,
            );
          } else if (state is HomeScreenError) {
            return ErrorScreen(
              error: context.read<HomeScreenError>().error,
            );
          } else if (state is HomeScreenLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: Colors.grey,
                  strokeWidth: 2,
                  backgroundColor: Colors.cyanAccent,
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class HomeScreenWidget extends StatelessWidget {
  const HomeScreenWidget({
    Key? key,
    required this.tranding,
    required this.topRated,
    required this.tvShows,
    required this.topShows,
    required this.upcoming,
    required this.nowPlaying,
  }) : super(key: key);
  final List<MovieModel> tranding;
  final List<MovieModel> topRated;
  final List<TvModel> tvShows;
  final List<TvModel> topShows;
  final List<MovieModel> upcoming;
  final List<MovieModel> nowPlaying;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(85, 51, 47, 47),
      // extendBody: true,
      // extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MoviePage(movies: tranding),
            const SizedBox(height: 14),
            const HeaderText(text: 'In Theaters'),
            const HeaderText(text: 'Tv Shows'),
          ],
        ),
      ),
    );
  }
}
