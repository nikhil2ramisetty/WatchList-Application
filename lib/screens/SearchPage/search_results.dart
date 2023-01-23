import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchlist/bloc/SideNavigation/sidenavigation_bloc.dart';
import 'package:watchlist/model/movie_response.dart';

import '../../bloc/MovieSearchBloc/moviesearch_bloc.dart';
import '../../bloc/MovieTappedOnHomeBloc/movietap_bloc.dart';

class SearchResults extends StatefulWidget {
  final MovieResponse ms;
  const SearchResults({super.key, required this.ms});

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoviesearchBloc, MovieSearchState>(
      builder: (context, state) {
        if (state is MovieSearchLoading) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 200),
            child: SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(strokeWidth: 2)),
          );
        } else if (state is MovieSearchLoaded) {
          return ArrayView(response: state.response);
        } else {
          return ArrayView(response: widget.ms);
        }
      },
    );
  }
}

class ArrayView extends StatefulWidget {
  final MovieResponse response;
  const ArrayView({super.key, required this.response});

  @override
  State<ArrayView> createState() => _ArrayViewState();
}

class _ArrayViewState extends State<ArrayView> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          ...?widget.response.results?.map((e) {
            Result nullable = e ?? Result();
            return Column(
              children: [
                Center(child: MovieCard(movie: nullable)),
                const SizedBox(height: 10)
              ],
            );
          })
        ],
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  final Result movie;
  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      const SizedBox(width: 5),
      Flexible(
        flex: 3,
        child: CachedNetworkImage(
          imageUrl: "https://image.tmdb.org/t/p/original${movie.posterPath}",
          placeholder: (context, url) => const Center(
            child: SizedBox(
                width: 20, height: 20, child: CircularProgressIndicator()),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
      const SizedBox(width: 10),
      Flexible(
        flex: 7,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                int movieId = movie.id ?? 0;
                BlocProvider.of<MovietapBloc>(context)
                    .add(MovieTappedEvent(id: movieId));
                BlocProvider.of<SideNavigationBloc>(context)
                    .add(MoviePressed());
              },
              child: Text(movie.originalTitle.toString(),
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 30),
            Text(movie.overview.toString(), overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
      const SizedBox(width: 20)
    ]);
  }
}
