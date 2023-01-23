import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/async.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchlist/bloc/ListSectionMovie/list_section_movie_bloc.dart';
import 'package:watchlist/bloc/MovieSearchBloc/moviesearch_bloc.dart';
import 'package:watchlist/bloc/NavigationBloc/navigation_bloc.dart';
import 'package:watchlist/model/movie_response.dart';
import 'package:watchlist/model/userDetails.dart';
import 'package:watchlist/screens/LoginPage/login.dart';
import 'package:watchlist/screens/moviePageDetailed.dart';

import '../../services/getSearch.dart';
import '../HomePage/AllListDisplay.dart';

class Movies extends StatefulWidget {
  const Movies({super.key});

  @override
  State<Movies> createState() => _MoviesState();
}

class _MoviesState extends State<Movies> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const MoviesTypeLists();
          } else {
            return const LoginScreen();
          }
        });
  }
}

class MoviesTypeLists extends StatefulWidget {
  const MoviesTypeLists({super.key});

  @override
  State<MoviesTypeLists> createState() => _MoviesTypeListsState();
}

class _MoviesTypeListsState extends State<MoviesTypeLists> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Nikhil')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        } else {
          var userDetails = snapshot.data?.data();
          UserDetails user = UserDetails.fromJson(userDetails!);
          List<String?>? lis1 = user.alreadyWatched?.toList();
          List<String?>? lis2 = user.watchLater?.toList();
          return MoviesListPageLoggedIn(lis1: lis1, lis2: lis2);
        }
      },
    );
  }
}

class MoviesListPageLoggedIn extends StatefulWidget {
  const MoviesListPageLoggedIn(
      {super.key, required this.lis1, required this.lis2});
  final List<String?>? lis1;
  final List<String?>? lis2;

  @override
  State<MoviesListPageLoggedIn> createState() => _MoviesListPageLoggedInState();
}

class _MoviesListPageLoggedInState extends State<MoviesListPageLoggedIn> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ListSectionMovieBloc()
        ..add(MoviesListLoaded(
            movieLists1: widget.lis1, movieLists2: widget.lis2)),
      child: BlocBuilder<ListSectionMovieBloc, ListSectionMovieState>(
        builder: (context, state) {
          if (state is ListSectionMovieLoading) {
            return Container(
                decoration: const BoxDecoration(
                    color: Color.fromARGB(100, 81, 88, 140)),
                child: const Center(
                    child: SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator())));
          } else if (state is ListSectionMovieLoaded) {
            return Container(
              width: 500,
              decoration:
                  const BoxDecoration(color: Color.fromARGB(255, 46, 15, 56)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 5,
                    child: SideCarousel(
                      title: "Already Watched",
                      movieResponse1: state.movieResponse1,
                    ),
                  ),
                  Flexible(
                    flex: 5,
                    child: SideCarousel(
                        movieResponse1: state.movieResponse2,
                        title: "Watch Later"),
                  )
                ],
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

class SideCarousel extends StatefulWidget {
  const SideCarousel(
      {super.key, required this.movieResponse1, required this.title});
  final List<Result> movieResponse1;
  final String title;
  @override
  State<SideCarousel> createState() => _SideCarouselState();
}

class _SideCarouselState extends State<SideCarousel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 10),
        Flexible(
          flex: 1,
          child: Text(
            widget.title,
            style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 221, 194, 235)),
          ),
        ),
        const SizedBox(height: 10),
        Flexible(
          flex: 9,
          child: SizedBox(
              height: 300.0,
              child: ListView(
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: [
                  ...widget.movieResponse1.map((e) => MovieSingleCard(movie: e))
                ],
              )),
        ),
      ]),
    );
  }
}
