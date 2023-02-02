// import 'dart:html';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchlist/bloc/ListSectionMovie/list_section_movie_bloc.dart';
import 'package:watchlist/bloc/NavigationBloc/navigation_bloc.dart';
import 'package:watchlist/model/movie_response.dart';
import 'package:watchlist/model/userDetails.dart';
import 'package:watchlist/screens/LoginPage/login.dart';
import 'package:watchlist/services/user_details_update.dart';

import '../../bloc/InternetBloc/internet_bloc.dart';
import '../HomePage/AllListDisplay.dart';

class Movies extends StatefulWidget {
  const Movies({super.key});

  @override
  State<Movies> createState() => _MoviesState();
}

class _MoviesState extends State<Movies> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        BlocProvider.of<NavigationBloc>(context).add(HomeClicked());
        return false;
      },
      child: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const MoviesTypeLists();
            } else {
              return const LoginScreen();
            }
          }),
    );
  }
}

class MoviesTypeLists extends StatefulWidget {
  const MoviesTypeLists({super.key});

  @override
  State<MoviesTypeLists> createState() => _MoviesTypeListsState();
}

class _MoviesTypeListsState extends State<MoviesTypeLists> {
  late Stream firebaseData;
  @override
  void initState() {
    super.initState();
    firebaseData = FirebaseFirestore.instance
        .collection('Nikhil')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InternetBloc, InternetState>(builder: (context, state) {
      return StreamBuilder(
        stream: firebaseData,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          } else {
            var userDetails = snapshot.data?.data();
            UserDetails user = UserDetails.fromJson(userDetails!);
            List<String?>? lis1 = user.alreadyWatched?.toList();
            List<String?>? lis2 = user.watchLater?.toList();
            BlocProvider.of<ListSectionMovieBloc>(context)
                .add(MoviesListLoaded(movieLists1: lis1, movieLists2: lis2));
            return MoviesListPageLoggedIn(lis1: lis1, lis2: lis2);
          }
        },
      );
    });
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
    return BlocBuilder<ListSectionMovieBloc, ListSectionMovieState>(
      builder: (context, state) {
        if (state is ListSectionMovieLoading) {
          return Container(
              decoration:
                  const BoxDecoration(color: Color.fromARGB(100, 81, 88, 140)),
              child: const Center(
                  child: SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator())));
        } else if (state is ListSectionMovieLoaded) {
          return Container(
            padding: const EdgeInsets.all(4),
            width: 500,
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 46, 15, 56)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Text("Already Watched",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 221, 194, 235))),
                const SizedBox(
                  height: 10,
                ),
                Flexible(
                  flex: 5,
                  child: VerticalCarousel(
                    title: "Already Watched",
                    movieResponse: state.movieResponse1,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text("Watch Later",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 221, 194, 235))),
                const SizedBox(
                  height: 10,
                ),
                Flexible(
                  flex: 5,
                  child: VerticalCarousel(
                      movieResponse: state.movieResponse2,
                      title: "Watch Later"),
                )
              ],
            ),
          );
        } else {
          return Container(
            decoration: const BoxDecoration(color: Colors.black),
          );
        }
      },
    );
  }
}

class VerticalCarousel extends StatefulWidget {
  final String title;
  final List<Result> movieResponse;
  const VerticalCarousel(
      {required this.title, required this.movieResponse, super.key});

  @override
  State<VerticalCarousel> createState() => _VerticalCarouselState();
}

class _VerticalCarouselState extends State<VerticalCarousel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      clipBehavior: Clip.hardEdge,
      child: ListView(
        children: [
          ...widget.movieResponse.map((e) => HorizontalMovieCard(result: e))
        ],
      ),
    );
  }
}

class HorizontalMovieCard extends StatefulWidget {
  const HorizontalMovieCard({required this.result, super.key});
  final Result result;

  @override
  State<HorizontalMovieCard> createState() => _HorizontalMovieCardState();
}

class _HorizontalMovieCardState extends State<HorizontalMovieCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.all(4),
        height: 200,
        decoration: BoxDecoration(
            color: const Color.fromARGB(99, 110, 31, 103),
            border: Border.all(color: Colors.black)),
        child: Row(
          children: [
            CachedNetworkImage(
                imageUrl:
                    "https://image.tmdb.org/t/p/original${widget.result.posterPath}"),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(widget.result.originalTitle ?? "",
                          overflow: TextOverflow.fade,
                          style: const TextStyle(
                              fontSize: 25,
                              color: Color.fromARGB(255, 221, 194, 235))),
                    ),
                    ToggleButtons(
                        selectedBorderColor: Colors.white,
                        selectedColor: Colors.red,
                        isSelected: const [true, false],
                        onPressed: ((index) {}),
                        children: const [
                          Text("Watch Later"),
                          Text("Already Watched")
                        ])
                  ]),
            ),
          ],
        ));
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
                // physics: const ClampingScrollPhysics(),
                // shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: [
                  ...widget.movieResponse1.map((e) => InkWell(
                      onLongPress: () {
                        _popupDialog(context, widget.title, e.id.toString());
                      },
                      child: MovieSingleCard(movie: e)))
                ],
              )),
        ),
      ]),
    );
  }

  void _popupDialog(BuildContext context, String str, String eid) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Delete ?'),
            actions: <Widget>[
              ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('CANCEL')),
              ElevatedButton(
                  onPressed: () {
                    if (str == "Watch Later") {
                      UserDetailsUpdate().removeWatchLater(eid);
                    } else if (str == "Already Watched") {
                      UserDetailsUpdate().removeAlreadyWatched(eid);
                    }
                    Navigator.of(context).pop();
                  },
                  child: const Text('DELETE')),
            ],
          );
        });
  }
}
