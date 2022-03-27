import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_db/animation.dart';
import 'package:movie_db/models/error_model.dart';
import 'package:movie_db/screens/cast_info_screen/cast_info_screen.dart';
import 'package:movie_db/screens/search_screen/results/cubit/search_results_cubit.dart';
import 'package:movie_db/widgets/error_screen.dart';
import 'package:movie_db/widgets/movie_cards.dart';
import 'package:movie_db/widgets/no_results_found.dart';

class SearchResults extends StatefulWidget {
  const SearchResults({Key? key, required this.query}) : super(key: key);
  final String query;
  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  ScrollController movieController = ScrollController();
  ScrollController tvController = ScrollController();
  ScrollController personController = ScrollController();

  int currentPage = 0;
  late PageController pageViewController;

  @override
  void initState() {
    super.initState();
    pageViewController = PageController(
      initialPage: currentPage,
    );
    movieController.addListener(movieScrollListener);
    tvController.addListener(tvScrollListener);
    personController.addListener(personScrollListener);
  }

  void movieScrollListener() {
    if (movieController.offset >= movieController.position.maxScrollExtent &&
        !movieController.position.outOfRange) {
      context.read<SearchResultsCubit>().loadNextMoviePage();
    }
  }

  void tvScrollListener() {
    if (tvController.offset >= tvController.position.maxScrollExtent &&
        !tvController.position.outOfRange) {
      context.read<SearchResultsCubit>().loadNextTvPage();
    }
  }

  void personScrollListener() {
    if (personController.offset >= personController.position.maxScrollExtent &&
        !personController.position.outOfRange) {
      context.read<SearchResultsCubit>().loadNextPersonPage();
    }
  }

  @override
  void dispose() {
    personController.dispose();
    movieController.dispose();
    tvController.dispose();
    pageViewController.dispose();
    super.dispose();
  }

  static const buttons = ['Movies', 'Tv', 'Person'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<SearchResultsCubit, SearchResultsState>(
        builder: (context, state) => Stack(
          children: [
            PageView(
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                });

                if (index == 1) {
                  if (state.shows.isEmpty) {
                    context.read<SearchResultsCubit>().initTv(widget.query);
                  }
                }
                if (index == 2) {
                  if (state.people.isEmpty) {
                    context.read<SearchResultsCubit>().initPeople(widget.query);
                  }
                }
              },
              controller: pageViewController,
              children: [
                ///
                state.movieStatus != MovieStatus.loading
                    ? ListView(
                        controller: movieController,
                        children: [
                          const SizedBox(height: 120),
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

                    /// Movie Loading
                    : state.movieStatus == MovieStatus.loading
                        ? Center(
                            child: SizedBox(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.grey[700],
                                backgroundColor: Theme.of(context).primaryColor,
                              ),
                            ),
                          )

                        /// Error Screen widget
                        : const Center(
                            child: ErrorScreen(
                              error: FetchDataError(
                                  message: 'Something went wrong!'),
                            ),
                          ),

                state.peopleStatus != PeopleStatus.loading
                    ? Padding(
                        padding: const EdgeInsets.only(top: 120),
                        child: GridView(
                          controller: personController,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 9 / 16,
                          ),
                          children: [
                            if (state.shows.isEmpty) const NoResultsFound(),
                            ...state.people.map(
                              (data) => Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: InkWell(
                                  onTap: () {
                                    pushNewScreen(
                                      context,
                                      CastInfoScreen(backdrop: '', id: data.id),
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        child: AspectRatio(
                                          aspectRatio: 9 / 14,
                                          child: CachedNetworkImage(
                                            imageUrl: data.profile,
                                            fit: BoxFit.cover,
                                            progressIndicatorBuilder: (context,
                                                url, downloadProgress) {
                                              return ColoredBox(
                                                color: Colors.grey[900]!,
                                                child: Center(
                                                  child: SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Colors.grey[700],
                                                      backgroundColor:
                                                          Theme.of(context)
                                                              .primaryColor,
                                                      strokeWidth: 1,
                                                      value: downloadProgress
                                                          .progress,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        data.name,
                                        maxLines: 2,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            if (state.peopleStatus == PeopleStatus.adding)
                              Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.grey[700],
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                          ],
                        ),
                      )
                    : state.peopleStatus == PeopleStatus.loading
                        ? Center(
                            child: SizedBox(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.grey[700],
                                backgroundColor: Theme.of(context).primaryColor,
                              ),
                            ),
                          )
                        : const Center(
                            child: ErrorScreen(),
                          ),
              ],
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  // color: Colors.black,
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey[900]!,
                      width: 0.6,
                    ),
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            InkWell(
                              onTap: () => Navigator.pop(context),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: Icon(
                                  CupertinoIcons.back,
                                  color: Colors.white,
                                  size: 26,
                                ),
                              ),
                            ),
                            Text(
                              'Results for "${widget.query}"',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              ...buttons.map(
                                (data) => Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color:
                                            currentPage == buttons.indexOf(data)
                                                ? Theme.of(context).primaryColor
                                                : Colors.grey[700]!,
                                        width: 0.6,
                                      ),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: InkWell(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14.0, vertical: 4.0),
                                      child: Text(
                                        data,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: currentPage ==
                                                  buttons.indexOf(data)
                                              ? const Color.fromARGB(
                                                  255, 138, 62, 62)
                                              : Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        currentPage = buttons.indexOf(data);
                                      });
                                      pageViewController.animateToPage(
                                        currentPage,
                                        duration:
                                            const Duration(microseconds: 1000),
                                        curve: Curves.bounceInOut,
                                      );

                                      if (currentPage == 1) {
                                        if (state.shows.isEmpty) {
                                          context
                                              .read<SearchResultsCubit>()
                                              .initTv(widget.query);
                                        }
                                      }
                                      if (currentPage == 2) {
                                        if (state.people.isEmpty) {
                                          context
                                              .read<SearchResultsCubit>()
                                              .initPeople(widget.query);
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
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
      ),
    );
  }
}
