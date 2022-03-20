import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:movie_db/models/movies/cast_info_model.dart';
import 'package:movie_db/models/movies/image_backdrop_model.dart';
import 'package:movie_db/models/movies/movie_info_imdb_model.dart';
import 'package:movie_db/models/movies/movie_info_model.dart';
import 'package:movie_db/models/movies/movie_model.dart';
import 'package:movie_db/models/movies/trailer_model.dart';
import 'package:movie_db/screens/movie_detail_screen/bloc/movie_detail_bloc.dart';
import 'package:movie_db/widgets/error_screen.dart';

class MovieDetailScreen extends StatelessWidget {
  const MovieDetailScreen({Key? key, required this.backdrop, required this.id})
      : super(key: key);

  final String id;
  final String backdrop;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<MovieDetailBloc>(
      create: (context) => MovieDetailBloc()..add(LoadMoviesDetail(id: id)),
      child: BlocBuilder<MovieDetailBloc, MovieDetailState>(
        builder: (context, state) {
          if (state is MovieDetailLoaded) {
            return MovieDetailScreenWidget(
              info: state.tmdbData,
              imdbInfo: state.imdbData,
              backdropList: state.backdrops,
              trailers: state.trailers,
              castList: state.cast,
              backdrop: backdrop,
              similar: state.similar,
            );
          } else if (state is MovieDatailError) {
            return ErrorScreen(
              error: state.error,
            );
          } else if (state is MovieDetailLoading) {
            return Scaffold(
              body: Center(
                  child: CircularProgressIndicator(
                color: Colors.grey.shade700,
                strokeWidth: 2,
                backgroundColor: Colors.cyanAccent,
              )),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class MovieDetailScreenWidget extends StatelessWidget {
  const MovieDetailScreenWidget({
    Key? key,
    required this.info,
    required this.imdbInfo,
    required this.backdropList,
    required this.trailers,
    required this.castList,
    required this.backdrop,
    required this.similar,
  }) : super(key: key);
  final MovieInfoModel info;
  final MovieInfoImdb imdbInfo;
  final List<ImageBackdrop> backdropList;
  final List<TrailerModel> trailers;
  final List<CastInfo> castList;
  final String backdrop;
  final List<MovieModel> similar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(info.poster),
            fit: BoxFit.cover,
            alignment: Alignment.topLeft,
          ),
        ),
      ),
    );
  }
}
