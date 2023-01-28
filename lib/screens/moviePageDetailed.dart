import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchlist/bloc/MovieTappedOnHomeBloc/movietap_bloc.dart';
import 'package:watchlist/bloc/NavigationBloc/navigation_bloc.dart';
import 'package:watchlist/services/user_details_update.dart';

import '../model/movie_response.dart';

class Movie extends StatefulWidget {
  const Movie({super.key});

  @override
  State<Movie> createState() => _MovieState();
}

class _MovieState extends State<Movie> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovietapBloc, MovietapState>(
      builder: (context, state) {
        if (state is MovieTappedLoading) {
          return Container(
            decoration: BoxDecoration(color: Color.fromARGB(255, 67, 23, 80)),
            child: const Center(
              child: SizedBox(
                  width: 50, height: 50, child: CircularProgressIndicator()),
            ),
          );
        } else if (state is MovieTappedLoaded) {
          return MoviePage(result: state.movie);
        } else {
          return Container();
        }
      },
    );
  }
}

class MoviePage extends StatefulWidget {
  final Result result;
  const MoviePage({super.key, required this.result});

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(1), BlendMode.dstATop),
            opacity: 0.3,
            image: CachedNetworkImageProvider(
                "https://image.tmdb.org/t/p/original${widget.result.backdropPath}"),
            fit: BoxFit.cover),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: SizedBox(
          width: 500,
          child: ListView(scrollDirection: Axis.vertical, children: [
            const SizedBox(height: 10),
            DecoratedBox(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(223, 70, 69, 69)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: CachedNetworkImage(
                          imageUrl:
                              "https://image.tmdb.org/t/p/original${widget.result.posterPath}"),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            textAlign: TextAlign.left,
                            widget.result.originalTitle ?? "",
                            style: const TextStyle(
                                color: Color.fromARGB(255, 181, 90, 197),
                                fontSize: 30,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            textAlign: TextAlign.left,
                            "Rating",
                            style: TextStyle(
                                color: Color.fromARGB(255, 181, 90, 197),
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          Text(
                            textAlign: TextAlign.left,
                            "${widget.result.voteAverage.toString()} / 10",
                            style: const TextStyle(
                                color: Color.fromARGB(255, 223, 132, 239),
                                fontWeight: FontWeight.bold,
                                fontSize: 30),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            textAlign: TextAlign.left,
                            "Release Date  ",
                            style: TextStyle(
                                color: Color.fromARGB(255, 181, 90, 197),
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          Text(
                            textAlign: TextAlign.left,
                            widget.result.releaseDate.toString(),
                            style: const TextStyle(
                                color: Color.fromARGB(255, 223, 132, 239),
                                fontWeight: FontWeight.bold,
                                fontSize: 30),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 5),
            SizedBox(
              child: ElevatedButton(
                  onPressed: () async {
                    try {
                      await UserDetailsUpdate()
                          .addWatchLater(widget.result.id.toString());
                    } on Exception {
                      BlocProvider.of<NavigationBloc>(context)
                          .add(MoviesClicked());
                    }
                  },
                  child: const Text(
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                      "Add to WatchLater")),
            ),
            const SizedBox(height: 0),
            SizedBox(
                child: ElevatedButton(
                    onPressed: () async {
                      try {
                        await UserDetailsUpdate()
                            .addAlreadyWatched(widget.result.id.toString());
                      } on Exception {
                        BlocProvider.of<NavigationBloc>(context)
                            .add(MoviesClicked());
                      }
                    },
                    child: const Text(
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 20),
                        "Watched ?"))),
            const SizedBox(height: 5),
            DecoratedBox(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(223, 70, 69, 69)),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Overview",
                          style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 181, 90, 197))),
                      const SizedBox(height: 10),
                      Text(
                          "${widget.result.overview}. ${widget.result.overview}. ${widget.result.overview}. ${widget.result.overview}.",
                          style: const TextStyle(
                              wordSpacing: 5,
                              color: Colors.white70,
                              fontSize: 20,
                              fontWeight: FontWeight.w600))
                    ]),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
