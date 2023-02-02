import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchlist/bloc/SideNavigation/sidenavigation_bloc.dart';
import 'package:watchlist/model/movie_response.dart';
import 'package:watchlist/screens/HomePage/AllListDisplay.dart';
import 'package:watchlist/screens/listDisplayPage.dart';

// import '../../bloc/MovieTappedOnHomeBloc/movietap_bloc.dart';
import '../SearchPage/searchPage.dart';
import '../moviePageDetailed.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.ms});
  final List<MovieResponse> ms;
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SideNavigationBloc, SideNavigationState>(
        builder: (context, state) {
      if (state is SideNavigationInitialHome) {
        if (state.movieResponse.isNotEmpty) {
          return AllListsDisplay(ms: state.movieResponse);
        }
        return AllListsDisplay(ms: widget.ms);
      } else if (state is SideNavigationPopular) {
        return ListDisplayPage(
            listName: "Popular Movies", ms: state.movieResponse);
      } else if (state is SideNavigationTopRated) {
        return ListDisplayPage(
            listName: "Top Rated Movies", ms: state.movieResponse);
      } else if (state is SideNavigationUpcoming) {
        return ListDisplayPage(
            listName: "Upcoming Movies", ms: state.movieResponse);
      } else if (state is MoviePageRequest) {
        return const Movie();
      } else if (state is SideNavigationSearch) {
        return SearchPage(ms: state.movieResponse[0]);
      } else {
        return Container(
          decoration: const BoxDecoration(color: Colors.purple),
        );
      }
    });
  }
}
