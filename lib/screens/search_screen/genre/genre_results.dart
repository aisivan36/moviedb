import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_db/models/error_model.dart';
import 'package:movie_db/screens/search_screen/genre/cubit/genre_result_cubit.dart';
import 'package:movie_db/widgets/error_screen.dart';
import 'package:movie_db/widgets/movie_cards.dart';
import 'package:movie_db/widgets/no_results_found.dart';

class GenreResults extends StatefulWidget {
  const GenreResults({Key? key, required this.query}) : super(key: key);

  final String query;

  @override
  State<GenreResults> createState() => _GenreResultsState();
}

class _GenreResultsState extends State<GenreResults> {
  ScrollController movieController = ScrollController();
  ScrollController tvController = ScrollController();

  int currentPage = 0;

  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(
      initialPage: currentPage,
    );

    movieController.addListener(movieScrollListenre);
    tvController.addListener(tvScrollListenre);
  }

  void movieScrollListenre() {
    if (movieController.offset >= movieController.position.maxScrollExtent &&
        !movieController.position.outOfRange) {
      context.read<GenreResultCubit>().loadNetxMoviePage();
    }
  }

  void tvScrollListenre() {
    if (tvController.offset >= tvController.position.maxScrollExtent &&
        !tvController.position.outOfRange) {
      context.read<GenreResultCubit>().loadNextTvPage();
    }
  }

  @override
  void dispose() {
    movieController.dispose();
    tvController.dispose();
    pageController.dispose();

    super.dispose();
  }

  static const List<String> buttons = ['Movies', 'Tv'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<GenreResultCubit, GenreResultState>(
        builder: (context, state) {
          return Stack(
            children: [
              PageView(
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                  if (value == 1) {
                    context.read<GenreResultCubit>().initTv(widget.query);
                  }
                },
                controller: pageController,
                children: [
                  state.movieStatus != MovieStatus.loading
                      ? ListView(
                          controller: movieController,
                          children: [
                            const SizedBox(height: 126),
                            if (state.movies.isEmpty) const NoResultsFound(),
                            ...state.movies.map(
                              (data) => HorizontalMovieCard(
                                poster: data.poster,
                                name: data.title,
                                backdrop: data.backdrop,
                                date: data.releaseDate,
                                rate: data.voteAverage,
                                id: data.id,
                                color: Colors.white,
                                isMovie: true,
                              ),
                            ),
                            if (state.movieStatus == MovieStatus.adding)
                              Center(
                                child: LinearProgressIndicator(
                                  backgroundColor: Colors.grey[700],
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                          ],
                        )
                      : state.movieStatus == MovieStatus.loading
                          ? Center(
                              child: SizedBox(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.grey[700],
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                ),
                              ),
                            )
                          : Center(
                              child: ErrorScreen(
                                error: FetchDataError(
                                  message: state.fetchDataError.getError,
                                ),
                              ),
                            ),
                  state.tvStatus != TvStatus.loaded
                      ? ListView(
                          controller: tvController,
                          children: [
                            const SizedBox(height: 126),
                            if (state.shows.isEmpty) const NoResultsFound(),
                            ...state.shows.map(
                              (data) => HorizontalMovieCard(
                                poster: data.poster,
                                name: data.title,
                                backdrop: data.backdrop,
                                date: data.releaseDate,
                                rate: data.voteAverage,
                                id: data.id,
                                color: Colors.white,
                                // isMovie: false,
                              ),
                            ),
                          ],
                        )
                      : state.tvStatus == TvStatus.loading
                          ? Center(
                              child: SizedBox(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.grey[700],
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                ),
                              ),
                            )
                          : Center(
                              child: ErrorScreen(
                                error: FetchDataError(
                                  message: state.fetchDataError.getError,
                                ),
                              ),
                            ),
                ],
              ),
              Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        color: Color.fromARGB(137, 54, 48, 48),
                        border: Border(
                            bottom: BorderSide(
                                color: Colors.grey[900]!, width: 0.6))),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 10.0),
                            Row(children: [
                              InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: Icon(
                                    CupertinoIcons.back,
                                    color: Colors.white,
                                    size: 26,
                                  ),
                                ),
                                onTap: () => Navigator.pop(context),
                              ),
                            ]),
                          ],
                        ),
                      ),
                    ),
                  ))
            ],
          );
        },
      ),
    );
  }
}
