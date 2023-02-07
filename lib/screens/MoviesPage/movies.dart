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
            List<String?>? lis1 = user.movies?.toList();
            List<bool?>? aw = user.alreadyWatched?.toList();
            List<bool?>? wl = user.watchLater?.toList();
            if (lis1!.isEmpty) {
              // debugPrint("&&&&&&&&&&&&&&&&&&&");
              BlocProvider.of<ListSectionMovieBloc>(context)
                  .add(MoviesListLoaded(movieLists1: []));

              return MoviesListPageLoggedIn(aw: [], wl: []);
            }
            BlocProvider.of<ListSectionMovieBloc>(context)
                .add(MoviesListLoaded(movieLists1: lis1));
            return MoviesListPageLoggedIn(aw: aw, wl: wl);
          }
        },
      );
    });
  }
}

class MoviesListPageLoggedIn extends StatefulWidget {
  const MoviesListPageLoggedIn({super.key, required this.aw, required this.wl});
  final List<bool?>? aw;
  final List<bool?>? wl;

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
                const SizedBox(
                  height: 10,
                ),
                Flexible(
                  flex: 5,
                  child: VerticalCarousel(
                    aw: widget.aw,
                    wl: widget.wl,
                    movieResponse: state.movieResponse1,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
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
  final List<Result> movieResponse;
  final List<bool?>? aw;
  final List<bool?>? wl;

  const VerticalCarousel(
      {required this.aw,
      required this.wl,
      required this.movieResponse,
      super.key});

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
          ...widget.movieResponse
              .asMap()
              .entries
              .map((e) => HorizontalMovieCard(
                    index: e.key,
                    result: e.value,
                    aw: widget.aw,
                    wl: widget.wl,
                  ))
        ],
      ),
    );
  }
}

class HorizontalMovieCard extends StatefulWidget {
  const HorizontalMovieCard(
      {required this.index,
      this.aw,
      required this.wl,
      required this.result,
      super.key});
  final Result result;
  final int index;
  final List<bool?>? aw;
  final List<bool?>? wl;
  @override
  State<HorizontalMovieCard> createState() => _HorizontalMovieCardState();
}

class _HorizontalMovieCardState extends State<HorizontalMovieCard> {
  @override
  Widget build(BuildContext context) {
    bool? aw;
    bool? wl;

    if (widget.aw!.isNotEmpty && widget.wl!.isNotEmpty) {
      try {
        aw = widget.aw![widget.index];
        wl = widget.wl![widget.index];
      } catch (e) {
        aw = false;
        wl = false;
      }
    }

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
                placeholder: (context, url) => Container(
                      width: 127,
                      child: const Center(
                        child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator()),
                      ),
                    ),
                imageUrl:
                    "https://image.tmdb.org/t/p/original${widget.result.posterPath}"),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              // flex: 8,
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
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width),
                        fillColor: Colors.purple,
                        color: Colors.white,
                        textStyle: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                        selectedBorderColor: Colors.white,
                        borderColor: Colors.white,
                        selectedColor: Colors.white,
                        isSelected: [wl ?? false, aw ?? false],
                        onPressed: ((index) {
                          if (index == 0) {
                            if (wl != null && wl) {
                              UserDetailsUpdate().removeWatchLater(
                                  widget.result.id.toString());
                            } else if (wl != null && !wl) {
                              UserDetailsUpdate()
                                  .addWatchLater(widget.result.id.toString());
                            }
                          } else {
                            if (aw != null && aw) {
                              UserDetailsUpdate().removeAlreadyWatched(
                                  widget.result.id.toString());
                            } else {
                              UserDetailsUpdate().addAlreadyWatched(
                                  widget.result.id.toString());
                            }
                          }
                        }),
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Watch Later"),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Already Watched"),
                          )
                        ])
                  ]),
            ),
          ],
        ));
  }
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
