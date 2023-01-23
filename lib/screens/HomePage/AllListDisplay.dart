import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchlist/model/movie_response.dart';

import '../../bloc/MovieTappedOnHomeBloc/movietap_bloc.dart';
import '../../bloc/SideNavigation/sidenavigation_bloc.dart';
import '../SearchPage/search_results.dart';

class AllListsDisplay extends StatefulWidget {
  final List<MovieResponse> ms;
  const AllListsDisplay({super.key, required this.ms});

  @override
  State<AllListsDisplay> createState() => _AllListsDisplayState();
}

class _AllListsDisplayState extends State<AllListsDisplay> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      decoration: const BoxDecoration(color: Color.fromARGB(255, 46, 15, 56)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 10),
              const Text(
                'Popular Movies',
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 221, 194, 235)),
              ),
              const SizedBox(height: 10),
              SizedBox(
                  height: 280.0,
                  child: ListView(
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: [
                      ...widget.ms[0].results!
                          .map((e) => MovieSingleCard(movie: e ?? Result()))
                    ],
                  )),
              const SizedBox(height: 40),
              const Text(
                'Upcoming Movies',
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 221, 194, 235)),
              ),
              const SizedBox(height: 10),
              SizedBox(
                  height: 280.0,
                  child: ListView(
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: [
                      ...widget.ms[1].results!
                          .map((e) => MovieSingleCard(movie: e ?? Result()))
                    ],
                  )),
              const SizedBox(height: 30),
              const Text(
                'Top Rated Movies',
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 221, 194, 235)),
              ),
              const SizedBox(height: 10),
              SizedBox(
                  height: 280.0,
                  child: ListView(
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: [
                      ...widget.ms[3].results!
                          .map((e) => MovieSingleCard(movie: e ?? Result()))
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class MovieSingleCard extends StatefulWidget {
  const MovieSingleCard({super.key, required this.movie});
  final Result movie;
  @override
  State<MovieSingleCard> createState() => _MovieSingleCardState();
}

class _MovieSingleCardState extends State<MovieSingleCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: const Color.fromARGB(100, 81, 88, 140)),
        // width: 200,
        margin: const EdgeInsets.only(right: 10),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: SizedBox(
            width: 140,
            child: InkWell(
              onTap: () {
                int movieId = widget.movie.id ?? 0;
                BlocProvider.of<MovietapBloc>(context)
                    .add(MovieTappedEvent(id: movieId));
                BlocProvider.of<SideNavigationBloc>(context)
                    .add(MoviePressed());
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                      flex: 8,
                      child: CachedNetworkImage(
                        height: 1000,
                        fit: BoxFit.fill,
                        imageUrl:
                            "https://image.tmdb.org/t/p/original${widget.movie.posterPath}",
                        placeholder: (context, url) => const Center(
                          child: SizedBox(
                              width: 10,
                              height: 10,
                              child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      )),
                  const SizedBox(height: 5),
                  Flexible(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 3, bottom: 0),
                        child: Text(
                          overflow: TextOverflow.clip,
                          widget.movie.originalTitle ?? "Hello World",
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 186, 199, 251)),
                          textAlign: TextAlign.center,
                        ),
                      ))
                ],
              ),
            ),
          ),
        ));
  }
}
