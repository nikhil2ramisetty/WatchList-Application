import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchlist/model/movie_response.dart';
import 'package:watchlist/screens/SearchPage/search_results.dart';
import 'package:watchlist/screens/SearchPage/searchbar.dart';

import '../../bloc/MovieSearchBloc/moviesearch_bloc.dart';
import '../../services/getSearch.dart';
// import '../bloc/moviesearch_bloc.dart';

class SearchPage extends StatefulWidget {
  final MovieResponse ms;
  const SearchPage({super.key, required this.ms});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MoviesearchBloc(Searching()),
      child: Column(
        children: [
          const Flexible(flex: 1, child: SearchBar()),
          Flexible(flex: 9, child: SearchResults(ms: widget.ms))
        ],
      ),
    );
  }
}
